# Ventanita para que el dueno escriba un dato delicado sin pasarlo por el chat (Windows).
# El asistente la abre; se abre una ventana aparte; el dueno escribe el dato dos veces (no se ve);
# al dar Enter se guarda en 1Password. Al asistente solo le regresa: guardado, cancelado o error.
#
# Uso, desde la carpeta del cerebro:
#   Guardar un dato en 1Password:
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/ventanita.ps1 -Boveda Negocio -Elemento "Banco del negocio" -Campo contrasena
#     (-Visible si el dato no es secreto, como un usuario; -Reemplazar no existe: si ya hay valor, la ventana le pregunta al dueno)
#   Guardar la llave de servicio de 1Password en la caja de esta compu (la primera vez):
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/ventanita.ps1 -LlaveDeServicio
#   Saber si un dato existe, sin verlo:
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/ventanita.ps1 -Existe -Boveda Negocio -Elemento "Banco del negocio" -Campo contrasena
param(
  [string]$Boveda = "",
  [string]$Elemento = "",
  [string]$Campo = "",
  [switch]$Visible,
  [switch]$LlaveDeServicio,
  [switch]$Existe,
  [switch]$Dentro,
  [string]$Aviso = ""
)

$ErrorActionPreference = "Continue"
$cerebro = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$caja = Join-Path $PSScriptRoot ".caja"

function Cargar-Llave {
  if (Test-Path $caja) {
    $seguro = (Get-Content $caja -Raw).Trim() | ConvertTo-SecureString
    $b = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($seguro)
    try { $env:OP_SERVICE_ACCOUNT_TOKEN = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($b) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b) }
    return $true
  }
  return [bool]$env:OP_SERVICE_ACCOUNT_TOKEN
}

function Texto-Plano($seguro) {
  $b = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($seguro)
  try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($b) }
  finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b) }
}

function Buscar-Elemento {
  $json = & op item get $Elemento --vault $Boveda --format json 2>$null
  if ($LASTEXITCODE -ne 0 -or -not $json) { return $null }
  return ($json | Out-String | ConvertFrom-Json)
}

function Tiene-Campo($item) {
  if (-not $item) { return $false }
  foreach ($f in $item.fields) {
    if (($f.label -eq $Campo -or $f.id -eq $Campo) -and $f.value) { return $true }
  }
  return $false
}

# --- Saber si existe, sin abrir ventana y sin ver el valor ---
if ($Existe) {
  if (-not (Get-Command op -ErrorAction SilentlyContinue)) { Write-Output "error: 1Password no esta instalado en esta compu"; exit 2 }
  if (-not (Cargar-Llave)) { Write-Output "error: falta la llave de servicio de 1Password en esta compu"; exit 2 }
  $item = Buscar-Elemento
  if (Tiene-Campo $item) { Write-Output "si existe" } else { Write-Output "no existe" }
  exit 0
}

# --- Lado del asistente: abre la ventana aparte y espera ---
if (-not $Dentro) {
  if (-not $LlaveDeServicio -and (-not $Boveda -or -not $Elemento -or -not $Campo)) {
    Write-Output "error: faltan -Boveda, -Elemento y -Campo (o -LlaveDeServicio)"; exit 2
  }
  $paso = Join-Path $cerebro "entrada\_paso"
  New-Item -ItemType Directory -Force $paso | Out-Null
  $avisoArchivo = Join-Path $paso ("ventanita-" + [guid]::NewGuid().ToString("N") + ".txt")
  $argumentos = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"", "-Dentro", "-Aviso", "`"$avisoArchivo`"")
  if ($LlaveDeServicio) { $argumentos += "-LlaveDeServicio" }
  else { $argumentos += @("-Boveda", "`"$Boveda`"", "-Elemento", "`"$Elemento`"", "-Campo", "`"$Campo`"") }
  if ($Visible) { $argumentos += "-Visible" }
  $p = Start-Process powershell.exe -ArgumentList $argumentos -Wait -PassThru
  $nota = ""
  if (Test-Path $avisoArchivo) { $nota = (Get-Content $avisoArchivo -Raw).Trim(); Remove-Item $avisoArchivo -Force }
  if ((Test-Path $paso) -and -not (Get-ChildItem $paso -Force)) { Remove-Item $paso -Force }
  switch ($p.ExitCode) {
    0 { Write-Output "guardado" }
    1 { Write-Output "cancelado" }
    3 { Write-Output "sin cambios: ya tenia valor y el dueno no quiso reemplazarlo" }
    default { Write-Output ("error: " + $(if ($nota) { $nota } else { "la ventana se cerro sin terminar" })) }
  }
  exit $p.ExitCode
}

# --- Lado de la ventana: aqui escribe el dueno ---
function Termina($codigo, $nota) {
  if ($nota -and $Aviso) { Set-Content -Path $Aviso -Value $nota -Encoding UTF8 }
  if ($codigo -ne 0 -and $codigo -ne 3) { Write-Host ""; Write-Host "Presiona Enter para cerrar."; [void](Read-Host) }
  exit $codigo
}

$Host.UI.RawUI.WindowTitle = "Dato privado del negocio"
Write-Host ""
Write-Host "  Aqui escribes un dato privado. No se ve en pantalla ni le llega al asistente." -ForegroundColor Cyan
Write-Host "  Se guarda directo en tu 1Password." -ForegroundColor Cyan
Write-Host ""

try {
  if (-not (Get-Command op -ErrorAction SilentlyContinue)) { Termina 2 "1Password no esta instalado en esta compu" }

  if ($LlaveDeServicio) {
    Write-Host "  Que vas a guardar: la llave de servicio de 1Password para tu asistente."
    Write-Host "  (Empieza con ops_ . La copias de 1Password, en Integraciones > Cuentas de servicio.)"
  } else {
    Write-Host ("  Que vas a guardar: " + $Campo + " de " + $Elemento + " (en tu cajon " + $Boveda + " de 1Password)")
    if (-not (Cargar-Llave)) { Termina 2 "falta la llave de servicio de 1Password en esta compu" }
    $item = Buscar-Elemento
    if (Tiene-Campo $item) {
      Write-Host ""
      $r = Read-Host "  Ese dato ya tiene un valor guardado. Quieres reemplazarlo? (s/n)"
      if ($r -notmatch '^(s|si|y|yes)$') { Termina 3 "" }
    }
  }
  Write-Host "  Para cancelar, deja vacio y da Enter."
  Write-Host ""

  $uno = Read-Host "  Escribelo" -AsSecureString
  $valor = Texto-Plano $uno
  if (-not $valor) { Termina 1 "" }
  $dos = Read-Host "  Escribelo otra vez" -AsSecureString
  if ((Texto-Plano $dos) -ne $valor) { Termina 2 "los dos no coinciden; no se guardo nada" }

  if ($LlaveDeServicio) {
    $env:OP_SERVICE_ACCOUNT_TOKEN = $valor
    & op whoami *> $null
    if ($LASTEXITCODE -ne 0) { Termina 2 "1Password no acepto esa llave; no se guardo nada" }
    $uno | ConvertFrom-SecureString | Set-Content -Path $caja -Encoding ASCII
    $valor = $null
    Write-Host ""; Write-Host "  Listo: la llave quedo guardada en la caja de esta compu, cifrada para tu usuario." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Termina 0 ""
  }

  $tipo = if ($Visible) { "STRING" } else { "CONCEALED" }
  if (-not $item) {
    $nuevo = [ordered]@{
      title    = $Elemento
      category = "SECURE_NOTE"
      fields   = @(
        [ordered]@{ id = "notesPlain"; type = "STRING"; purpose = "NOTES"; label = "notesPlain"; value = "Guardado por el asistente del negocio con la ventanita." },
        [ordered]@{ id = $Campo; type = $tipo; label = $Campo; value = $valor }
      )
    }
    $nuevo | ConvertTo-Json -Depth 5 -Compress | & op item create --vault $Boveda - *> $null
  } else {
    $tipoOp = if ($Visible) { "text" } else { "password" }
    $nombre = $Campo -replace '\\', '\\' -replace '\.', '\.' -replace '=', '\='
    & op item edit $item.id --vault $Boveda ("{0}[{1}]={2}" -f $nombre, $tipoOp, $valor) *> $null
  }
  $ok = ($LASTEXITCODE -eq 0)
  $valor = $null
  if (-not $ok) { Termina 2 "1Password no lo acepto; revisa que la llave de servicio pueda escribir en el cajon $Boveda" }
  Write-Host ""; Write-Host "  Listo: quedo guardado en tu 1Password." -ForegroundColor Green
  Start-Sleep -Seconds 2
  Termina 0 ""
} catch {
  Termina 2 ("fallo: " + $_.Exception.Message)
}
