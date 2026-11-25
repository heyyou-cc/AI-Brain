# Lanzador de las alarmas para Windows cuando el asistente corre sus hooks con PowerShell
# (Copilot, y Codex con commandWindows). Busca el sh de Git for Windows y le pasa lo que llega por stdin;
# devuelve el mismo codigo de salida, la misma salida y los mismos mensajes de error.
# Uso:  powershell -NoProfile -ExecutionPolicy Bypass -File sistema/alarmas/correr.ps1 [-Agente codex|copilot] <alarma.sh> [argumentos]
#   Una sola vez, si el .claude/settings.json tambien lo corre PowerShell (Copilot lo lee):
#       powershell -NoProfile -ExecutionPolicy Bypass -File sistema/alarmas/correr.ps1 -ArreglarRuta
#   (agrega la carpeta bin de Git a la ruta de TU usuario, para que PowerShell encuentre "sh").
# Si no hay Git Bash: sale 0 sin decir nada (no bloquea todo), salvo dos reglas minimas que si aplica
# solo con PowerShell: no escribir fuera de la carpeta del cerebro y no leer _privado.
# Sin acentos a proposito: PowerShell 5.1 lee mal un .ps1 sin BOM.
param(
  [string]$Agente = '',
  [switch]$ArreglarRuta,
  [Parameter(Position = 0)][string]$Alarma = '',
  [Parameter(Position = 1, ValueFromRemainingArguments = $true)][string[]]$Resto = @()
)
$ErrorActionPreference = 'Stop'

function Buscar-Sh {
  if ($env:CEREBRO_SIN_SH -eq '1') { return $null }   # solo para las pruebas
  $c = Get-Command sh.exe -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($c) { return $c.Source }
  $raices = @()
  $g = Get-Command git.exe -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($g) {
    # ...\Git\cmd\git.exe  ->  ...\Git
    $raices += (Split-Path (Split-Path $g.Source -Parent) -Parent)
    try {
      $x = (& git --exec-path 2>$null | Select-Object -First 1)
      if ($x) { $d = $x -replace '/', '\'; for ($i = 0; $i -lt 6 -and $d; $i++) { $raices += $d; $d = Split-Path $d -Parent } }
    } catch { }
  }
  foreach ($b in @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramW6432, (Join-Path $env:LOCALAPPDATA 'Programs'))) {
    if ($b) { $raices += (Join-Path $b 'Git') }
  }
  foreach ($r in $raices) {
    if (-not $r) { continue }
    foreach ($rel in @('bin\sh.exe', 'usr\bin\sh.exe')) {
      $p = Join-Path $r $rel
      if (Test-Path -LiteralPath $p) { return $p }
    }
  }
  return $null
}

$sh = Buscar-Sh

if ($ArreglarRuta) {
  if (-not $sh) { Write-Error 'No encontre Git para Windows. Instalalo de https://git-scm.com y vuelve a correr esto.'; exit 1 }
  $dir = Split-Path $sh -Parent
  $usuario = [Environment]::GetEnvironmentVariable('Path', 'User')
  if (($usuario -split ';') -contains $dir) { Write-Output "Ya estaba: $dir"; exit 0 }
  [Environment]::SetEnvironmentVariable('Path', ($usuario.TrimEnd(';') + ';' + $dir), 'User')
  Write-Output "Listo: agregue $dir a la ruta de tu usuario. Cierra y abre otra vez tu asistente."
  exit 0
}

if (-not $Alarma) { exit 0 }
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
$script = Join-Path $aqui $Alarma
if (-not (Test-Path -LiteralPath $script)) { exit 0 }
if ($Agente) { $env:CEREBRO_AGENTE = $Agente }

# Todo lo que llega por stdin, en bytes (sin tocar la codificacion).
$ent = New-Object System.IO.MemoryStream
try {
  $stdin = [Console]::OpenStandardInput()
  $stdin.CopyTo($ent)
} catch { }
$bytes = $ent.ToArray()

if (-not $sh) {
  # Regla minima solo con PowerShell.
  $txt = [System.Text.Encoding]::UTF8.GetString($bytes)
  $raiz = (Resolve-Path (Join-Path $aqui '..\..')).Path
  try {
    $ev = $txt | ConvertFrom-Json
    $args2 = $null
    if ($ev.toolArgs) { try { $args2 = $ev.toolArgs | ConvertFrom-Json } catch { $args2 = $null } }
    elseif ($ev.tool_input) { $args2 = $ev.tool_input }
    $nombre = ('' + $ev.toolName + $ev.tool_name).ToLower()
    $ruta = ''
    $cmd = ''
    if ($args2) {
      foreach ($k in 'file_path', 'filePath', 'path', 'notebook_path') { if ($args2.$k) { $ruta = [string]$args2.$k; break } }
      if ($args2.command) { $cmd = [string]$args2.command }
    }
    $escribe = ($nombre -match 'write|edit|patch|replace|create')
    if ($Alarma -eq 'antes-de-leer.sh') {
      $t = (($ruta + ' ' + $cmd) -replace '\\', '/').ToLower()
      if (-not $escribe -and $t -match '(^|[/\s])_privado(/|\s|$)' -and ($ruta -or $cmd -match '\b(cat|type|get-content|gc|more|less|head|tail|grep|rg|findstr|select-string|sls|sed|awk)\b')) {
        [Console]::Error.WriteLine('Alarma del cerebro: Esa carpeta es privada (_privado). Pidele permiso al dueno en el chat; si dice que si, que el te pegue el contenido o abra el archivo.')
        exit 2
      }
    }
    if ($Alarma -eq 'antes-de-escribir.sh' -and $escribe -and $ruta) {
      $r = ($ruta -replace '\\', '/').ToLower()
      $b = ($raiz -replace '\\', '/').ToLower().TrimEnd('/')
      $absoluta = ($r -match '^[a-z]:/') -or $r.StartsWith('/')
      if ($r -match '(^|/)\.\.(/|$)' -or ($absoluta -and -not ($r -eq $b -or $r.StartsWith($b + '/')))) {
        [Console]::Error.WriteLine("Alarma del cerebro: no se escribe fuera de la carpeta del cerebro ($ruta). Lo de paso va en entrada/_paso/ (AGENTS.md, punto 5).")
        exit 2
      }
    }
  } catch { }
  exit 0
}

$pi = New-Object System.Diagnostics.ProcessStartInfo
$pi.FileName = $sh
$comillas = { param($s) '"' + ($s -replace '"', '\"') + '"' }
$lista = @((& $comillas ($script -replace '\\', '/')))
foreach ($a in $Resto) { $lista += (& $comillas $a) }
$pi.Arguments = ($lista -join ' ')
$pi.UseShellExecute = $false
$pi.RedirectStandardInput = $true
$pi.RedirectStandardOutput = $true
$pi.RedirectStandardError = $true
$pi.CreateNoWindow = $true
$pi.WorkingDirectory = (Get-Location).Path
$p = [System.Diagnostics.Process]::Start($pi)
$salida = [Console]::OpenStandardOutput()
$error2 = [Console]::OpenStandardError()
$t1 = $p.StandardOutput.BaseStream.CopyToAsync($salida)
$t2 = $p.StandardError.BaseStream.CopyToAsync($error2)
try {
  if ($bytes.Length -gt 0) { $p.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length) }
  $p.StandardInput.BaseStream.Flush()
} catch { }
try { $p.StandardInput.Close() } catch { }
$p.WaitForExit()
$t1.Wait(); $t2.Wait()
$salida.Flush(); $error2.Flush()
exit $p.ExitCode
