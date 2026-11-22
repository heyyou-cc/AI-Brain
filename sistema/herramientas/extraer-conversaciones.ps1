# extraer-conversaciones.ps1
# Saca de las conversaciones guardadas de Claude Code y Codex SOLO lo que tecleo el dueno,
# tapa claves y lo imprime en pantalla, por paginas. No escribe ningun archivo.
# Las conversaciones que se tuvieron dentro de la carpeta actual (el cerebro) no salen.
# Uso: powershell.exe -NoProfile -ExecutionPolicy Bypass -File extraer-conversaciones.ps1 -CarpetaPersonal ruta [-Pagina N] [-Tamano 20000]
# Compatible con PowerShell 5.1. Codigo fuente solo ASCII (sin acentos) a proposito.

param(
    [string]$CarpetaPersonal = $env:USERPROFILE,
    [int]$Pagina = 1,
    [int]$Tamano = 20000,
    [string]$Salida = ''
)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$script:out = New-Object System.IO.StreamWriter([Console]::OpenStandardOutput(), $utf8)
function Say([string]$s) { $script:out.Write($s + "`n") }

if ($Tamano -lt 4000) { $Tamano = 4000 }
if ($Pagina -lt 1) { $Pagina = 1 }

$MaxConversaciones = 200
$MaxCaracteres = 400000
$Pieza = $Tamano - 1000

Add-Type -AssemblyName System.Web.Extensions
$js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$js.MaxJsonLength = [int]::MaxValue
$js.RecursionLimit = 500

$script:tapadas = 0
$prefijos = @('<command-name>', '<command-message>', '<command-args>', '<local-command-stdout>', '<system-reminder>', 'Caveat:', '[Request interrupted')

function G($d, [string]$k) {
    if ($d -is [System.Collections.IDictionary] -and $d.ContainsKey($k)) { return , $d[$k] }
    return $null
}

function Tapar([string]$t) {
    $ev = { param($m) $script:tapadas++; return '[clave tapada]' }
    $evKw = { param($m) $script:tapadas++; return ($m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value + '[clave tapada]') }
    # palabra clave, hasta seis palabras de por medio, luego ":" o "es", luego el valor
    $kw = '(?i)\b(contrase(?:\xf1|n|n.)as?|passwords?|claves?|pin|tokens?|llaves?)\b((?:\s+[^\s:]+){0,6}?)(\s*:\s*|\s+es\s*:?\s*)(\S+)'
    $t = [regex]::Replace($t, $kw, $evKw)
    $formas = @(
        'sk-[A-Za-z0-9_\-]{16,}',
        'gh[pousr]_[A-Za-z0-9]{20,}',
        'github_pat_[A-Za-z0-9_]{20,}',
        'AKIA[0-9A-Z]{16}',
        'xox[abprs]-[A-Za-z0-9\-]{10,}',
        'eyJ[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}',
        '(?<![\d])(?:\d[ \-]?){12,18}\d(?![\d])'
    )
    foreach ($f in $formas) { $t = [regex]::Replace($t, $f, $ev) }
    return $t
}

function EsRuido([string]$t) {
    $x = $t.TrimStart()
    if ($x -eq '') { return $true }
    foreach ($p in $prefijos) { if ($x.StartsWith($p, [System.StringComparison]::Ordinal)) { return $true } }
    return $false
}

function Fecha([string]$ts, $respaldo) {
    try { return [DateTimeOffset]::Parse($ts, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime }
    catch { return $respaldo }
}

function Normal([string]$p) {
    if (-not $p) { return '' }
    return ($p -replace '\\', '/').TrimEnd('/').ToLowerInvariant()
}
$cerebro = Normal (Get-Location).Path

# ---- reunir archivos
$archivos = New-Object System.Collections.Generic.List[object]
$dClaude = Join-Path $CarpetaPersonal '.claude\projects'
if (Test-Path -LiteralPath $dClaude) {
    foreach ($d in (Get-ChildItem -LiteralPath $dClaude -Directory -ErrorAction SilentlyContinue)) {
        foreach ($f in (Get-ChildItem -LiteralPath $d.FullName -Filter '*.jsonl' -File -ErrorAction SilentlyContinue)) {
            $archivos.Add([pscustomobject]@{ Ruta = $f.FullName; Origen = 'claude-code'; Fecha = $f.LastWriteTime })
        }
    }
}
$dCodex = Join-Path $CarpetaPersonal '.codex\sessions'
if (Test-Path -LiteralPath $dCodex) {
    foreach ($f in (Get-ChildItem -LiteralPath $dCodex -Filter 'rollout-*.jsonl' -File -Recurse -ErrorAction SilentlyContinue)) {
        $archivos.Add([pscustomobject]@{ Ruta = $f.FullName; Origen = 'codex'; Fecha = $f.LastWriteTime })
    }
}
$elegidos = @($archivos | Sort-Object Fecha -Descending | Select-Object -First $MaxConversaciones)

# ---- armar las paginas en memoria
$script:paginas = New-Object System.Collections.Generic.List[string]
$script:sb = New-Object System.Text.StringBuilder
$script:sigue = ''

function Cerrar {
    if ($script:sb.Length -gt 0) { $script:paginas.Add($script:sb.ToString()); [void]$script:sb.Clear() }
}
function Agregar([string]$bloque, [bool]$esCabecera) {
    if ($script:sb.Length -gt 0 -and ($script:sb.Length + $bloque.Length) -gt $Tamano) {
        Cerrar
        if (-not $esCabecera) { [void]$script:sb.Append($script:sigue) }
    }
    [void]$script:sb.Append($bloque)
}

$leidas = 0; $conDueno = 0; $delCerebro = 0; $saltadas = 0; $total = 0
$tope = $false

foreach ($a in $elegidos) {
    $leidas++
    if ($tope) { $saltadas++; continue }
    $msgs = New-Object System.Collections.Generic.List[object]
    $cwd = ''; $subagente = $false
    $sr = $null
    try {
        $sr = New-Object System.IO.StreamReader($a.Ruta, $utf8)
        while ($null -ne ($linea = $sr.ReadLine())) {
            if ($linea.Length -lt 10) { continue }
            if ($a.Origen -eq 'claude-code') {
                if ($linea -notmatch '"type"\s*:\s*"user"') { continue }
                try { $o = $js.DeserializeObject($linea) } catch { continue }
                if ((G $o 'type') -ne 'user') { continue }
                $c = G $o 'cwd'; if ($c -and -not $cwd) { $cwd = [string]$c }
                if ((G $o 'isSidechain') -eq $true) { continue }
                if ((G $o 'isMeta') -eq $true) { continue }
                if ((G $o 'isCompactSummary') -eq $true) { continue }
                $m = G $o 'message'
                $cont = G $m 'content'
                $textos = @()
                if ($cont -is [string]) { $textos = @($cont) }
                elseif ($cont -is [System.Collections.IEnumerable]) {
                    foreach ($b in $cont) {
                        if ((G $b 'type') -eq 'text') {
                            $tx = G $b 'text'
                            if ($tx -is [string]) { $textos += $tx }
                        }
                    }
                }
                foreach ($tx in $textos) {
                    if (EsRuido $tx) { continue }
                    $msgs.Add([pscustomobject]@{ Ts = [string](G $o 'timestamp'); Texto = $tx })
                }
            } else {
                if ($linea -notmatch '"type"\s*:\s*"(session_meta|user_message)"') { continue }
                try { $o = $js.DeserializeObject($linea) } catch { continue }
                $tipo = G $o 'type'
                $p = G $o 'payload'
                if ($tipo -eq 'session_meta') {
                    $c = G $p 'cwd'; if ($c -and -not $cwd) { $cwd = [string]$c }
                    $src = G $p 'source'
                    if ($null -ne $src -and $src -isnot [string]) {
                        if ($js.Serialize($src) -match 'subagent') { $subagente = $true }
                    }
                } elseif ($tipo -eq 'event_msg' -and (G $p 'type') -eq 'user_message') {
                    $tx = G $p 'message'
                    if ($tx -is [string] -and -not (EsRuido $tx)) {
                        $msgs.Add([pscustomobject]@{ Ts = [string](G $o 'timestamp'); Texto = $tx })
                    }
                }
            }
        }
    } catch {
        $saltadas++
        continue
    } finally {
        if ($null -ne $sr) { $sr.Dispose() }
    }
    if ($subagente -or $msgs.Count -eq 0) { $saltadas++; continue }
    $nc = Normal $cwd
    if ($cerebro -and $nc -and ($nc -eq $cerebro -or $nc.StartsWith($cerebro + '/'))) { $delCerebro++; continue }

    # bloques de esta conversacion
    $num = $conDueno + 1
    $f0 = Fecha $msgs[0].Ts $a.Fecha
    $cab = "`n=== Conversacion $num | $($a.Origen) | $($f0.ToString('yyyy-MM-dd HH:mm')) | carpeta: $cwd ===`n"
    $bloques = New-Object System.Collections.Generic.List[string]
    foreach ($m in $msgs) {
        $fm = Fecha $m.Ts $f0
        $tx = Tapar ($m.Texto.Trim() -replace "`r`n", "`n")
        $titulo = "`n### $($fm.ToString('yyyy-MM-dd HH:mm'))`n`n"
        if ($tx.Length -le $Pieza) {
            $bloques.Add($titulo + $tx + "`n")
        } else {
            $i = 0
            while ($i -lt $tx.Length) {
                $n = [Math]::Min($Pieza, $tx.Length - $i)
                $t2 = $titulo
                if ($i -gt 0) { $t2 = "`n### (sigue el mensaje)`n`n" }
                $bloques.Add($t2 + $tx.Substring($i, $n) + "`n")
                $i += $n
            }
        }
    }
    $largo = $cab.Length
    foreach ($b in $bloques) { $largo += $b.Length }
    if ($total + $largo -gt $MaxCaracteres) { $tope = $true; $saltadas++; continue }

    $conDueno++
    $total += $largo
    $script:sigue = "(sigue la conversacion $num | $($a.Origen) | $($f0.ToString('yyyy-MM-dd HH:mm')))`n"
    Agregar $cab $true
    foreach ($b in $bloques) { Agregar $b $false }
}
Cerrar

$M = $script:paginas.Count
$extra = ''
if ($tope) { $extra = ' Se alcanzo el tope de 400 000 caracteres: las mas viejas no salen.' }
$resumen = "Resumen: leyo $leidas conversaciones; con mensajes del dueno: $conDueno; de esta misma carpeta (no salen): $delCerebro; saltadas: $saltadas; claves tapadas en total: $($script:tapadas).$extra"
if ($Salida) { Say 'Aviso: este extractor ya no escribe archivos; -Salida no se usa.' }

if ($M -eq 0) {
    Say 'No hay conversaciones del dueno fuera de esta carpeta.'
    Say $resumen
} elseif ($Pagina -gt $M) {
    Say "No hay pagina $Pagina`: son $M paginas."
    Say $resumen
} else {
    $txt = $script:paginas[$Pagina - 1]
    $enPagina = ([regex]::Matches($txt, [regex]::Escape('[clave tapada]'))).Count
    Say "=== Pagina $Pagina de $M | solo los mensajes del dueno, con las claves tapadas | no se escribio ningun archivo ==="
    Say $txt
    if ($Pagina -lt $M) { Say "=== Fin de la pagina $Pagina de $M. Sigue con -Pagina $($Pagina + 1). ===" }
    else { Say "=== Fin de la pagina $Pagina de $M. Ya no hay mas. ===" }
    Say "$resumen Claves tapadas en esta pagina: $enPagina."
}
$script:out.Flush()
