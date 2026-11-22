# Mesero (Windows): lleva datos de 1Password a donde hacen falta sin que el asistente los vea.
# El asistente solo nombra los datos con referencias op://<cajon>/<elemento>/<campo>; el valor lo pone 1Password.
#
# Uso, desde la carpeta del cerebro:
#   Revisar que 1Password responde y que cajones ve la llave (solo nombres):
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/mesero.ps1 revisar
#   Correr un programa con datos de 1Password como variables (en lo que imprima, 1Password tapa los valores):
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/mesero.ps1 correr <archivo-de-referencias> <programa> [argumentos...]
#     El archivo de referencias tiene renglones NOMBRE=op://Negocio/Banco del negocio/contrasena (nunca valores).
#   Llenar un archivo de configuracion de otro programa a partir de una plantilla con referencias {{ op://... }}:
#     powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/mesero.ps1 llenar <plantilla> <archivo-de-salida>
#     El archivo de salida queda con los valores: el asistente nunca lo abre ni lo copia.
param(
  [Parameter(Position = 0)][string]$Accion = "",
  [Parameter(Position = 1, ValueFromRemainingArguments = $true)][string[]]$Resto
)

$ErrorActionPreference = "Continue"
$caja = Join-Path $PSScriptRoot ".caja"

if (-not (Get-Command op -ErrorAction SilentlyContinue)) { Write-Output "error: 1Password no esta instalado en esta compu"; exit 2 }
if (Test-Path $caja) {
  $seguro = (Get-Content $caja -Raw).Trim() | ConvertTo-SecureString
  $b = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($seguro)
  try { $env:OP_SERVICE_ACCOUNT_TOKEN = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($b) }
  finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b) }
}
if (-not $env:OP_SERVICE_ACCOUNT_TOKEN) { Write-Output "error: falta la llave de servicio de 1Password en esta compu (abrir la ventanita con -LlaveDeServicio)"; exit 2 }

switch ($Accion) {
  "revisar" {
    & op whoami *> $null
    if ($LASTEXITCODE -ne 0) { Write-Output "error: 1Password no acepta la llave guardada"; exit 2 }
    Write-Output "1Password responde. Cajones que ve la llave:"
    $cajones = (& op vault list --format json | Out-String | ConvertFrom-Json)
    foreach ($c in $cajones) { Write-Output ("- " + $c.name) }
    exit 0
  }
  "correr" {
    if (-not $Resto -or $Resto.Count -lt 2) { Write-Output "error: uso: correr <archivo-de-referencias> <programa> [argumentos...]"; exit 2 }
    $refs = $Resto[0]
    if (-not (Test-Path $refs)) { Write-Output "error: no encuentro $refs"; exit 2 }
    foreach ($r in Get-Content $refs) {
      $t = $r.Trim()
      if (-not $t -or $t.StartsWith("#")) { continue }
      if ($t -notmatch '^[A-Za-z_][A-Za-z0-9_]*=op://') { Write-Output "error: el archivo de referencias solo lleva renglones NOMBRE=op://...; no valores"; exit 2 }
    }
    $programa = $Resto[1]
    $args2 = @()
    if ($Resto.Count -gt 2) { $args2 = $Resto[2..($Resto.Count - 1)] }
    & op run --env-file $refs -- $programa @args2
    exit $LASTEXITCODE
  }
  "llenar" {
    if (-not $Resto -or $Resto.Count -lt 2) { Write-Output "error: uso: llenar <plantilla> <archivo-de-salida>"; exit 2 }
    & op inject -i $Resto[0] -o $Resto[1] -f *> $null
    if ($LASTEXITCODE -ne 0) { Write-Output "error: 1Password no pudo llenar la plantilla (revisa que cada referencia exista)"; exit 2 }
    Write-Output ("listo: " + $Resto[1] + " quedo lleno. No lo abras ni lo copies: trae los valores.")
    exit 0
  }
  default {
    Write-Output "uso: mesero.ps1 revisar | correr <referencias> <programa> [args] | llenar <plantilla> <salida>"
    exit 2
  }
}
