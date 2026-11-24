# extraer-conversaciones.ps1
# Saca de las conversaciones guardadas de Claude Code y Codex SOLO lo que tecleo el dueno,
# tapa claves y lo imprime en pantalla, por paginas. No escribe ningun archivo.
# Las conversaciones que se tuvieron dentro de la carpeta actual (el cerebro) no salen.
# Uso: powershell.exe -NoProfile -ExecutionPolicy Bypass -File extraer-conversaciones.ps1 -CarpetaPersonal ruta [-Pagina N] [-Tamano 20000]
# Con -Exportacion "ruta" lee, en vez de Claude Code y Codex, la exportacion de claude.ai o de ChatGPT:
# el .zip tal cual o el conversations.json ya descomprimido. Detecta el formato solo y descomprime en memoria.
# Compatible con PowerShell 5.1. Codigo fuente solo ASCII (sin acentos) a proposito.

param(
    [string]$CarpetaPersonal = $env:USERPROFILE,
    [int]$Pagina = 1,
    [int]$Tamano = 20000,
    [string]$Salida = '',
    [string]$Exportacion = ''
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

$script:leidas = 0; $script:conDueno = 0; $script:delCerebro = 0; $script:saltadas = 0; $script:total = 0
$script:tope = $false
$script:desconocidas = 0

# Imprime una conversacion ya reducida a los mensajes del dueno. $msgs: objetos con Ts (fecha en texto) y Texto.
function Emitir([string]$origen, $f0, [string]$etiqueta, $msgs) {
    $num = $script:conDueno + 1
    $cab = "`n=== Conversacion $num | $origen | $($f0.ToString('yyyy-MM-dd HH:mm')) | $etiqueta ===`n"
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
    if ($script:total + $largo -gt $MaxCaracteres) { $script:tope = $true; $script:saltadas++; return }

    $script:conDueno++
    $script:total += $largo
    $script:sigue = "(sigue la conversacion $num | $origen | $($f0.ToString('yyyy-MM-dd HH:mm')))`n"
    Agregar $cab $true
    foreach ($b in $bloques) { Agregar $b $false }
}

# ---- exportacion de claude.ai o de ChatGPT (.zip o conversations.json)
function Leer-Exportacion([string]$ruta) {
    if (-not (Test-Path -LiteralPath $ruta -PathType Leaf)) {
        Say "No encontre el archivo de exportacion: $ruta"
        $script:out.Flush(); exit 1
    }
    $jsons = New-Object System.Collections.Generic.List[string]
    $fs = [System.IO.File]::OpenRead($ruta)
    $b0 = New-Object byte[] 2
    [void]$fs.Read($b0, 0, 2)
    $fs.Dispose()
    if ($b0[0] -eq 0x50 -and $b0[1] -eq 0x4B) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $z = [System.IO.Compression.ZipFile]::OpenRead($ruta)
        try {
            foreach ($e in $z.Entries) {
                if ($e.FullName -match '(^|/)conversations(-\d+)?\.json$') {
                    $r = New-Object System.IO.StreamReader($e.Open(), $utf8)
                    try { $jsons.Add($r.ReadToEnd()) } finally { $r.Dispose() }
                }
            }
        } finally { $z.Dispose() }
        if ($jsons.Count -eq 0) {
            Say 'El .zip no trae ningun conversations.json. Revisa que sea la exportacion de claude.ai o de ChatGPT.'
            $script:out.Flush(); exit 1
        }
    } else {
        $jsons.Add([System.IO.File]::ReadAllText($ruta, $utf8))
    }
    return , $jsons
}

function Epoca-A-Texto($v, [string]$respaldo) {
    if ($null -eq $v -or $v -is [string]) { return $respaldo }
    try {
        $seg = [long][Math]::Floor([double]$v)
        return [DateTimeOffset]::FromUnixTimeSeconds($seg).ToString('o')
    } catch { return $respaldo }
}

function Mensajes-Claude($conv) {
    $lista = New-Object System.Collections.Generic.List[object]
    $ms = G $conv 'chat_messages'
    if ($ms -isnot [System.Collections.IEnumerable]) { return , $lista }
    foreach ($m in $ms) {
        if ((G $m 'sender') -ne 'human') { continue }
        $tx = G $m 'text'
        if ($tx -isnot [string] -or $tx.Trim() -eq '') {
            $partes = @()
            $cont = G $m 'content'
            if ($cont -is [System.Collections.IEnumerable] -and $cont -isnot [string]) {
                foreach ($b in $cont) {
                    if ((G $b 'type') -eq 'text') { $t = G $b 'text'; if ($t -is [string]) { $partes += $t } }
                }
            }
            $tx = ($partes -join "`n")
        }
        if (-not (EsRuido $tx)) {
            $lista.Add([pscustomobject]@{ Ts = [string](G $m 'created_at'); Texto = $tx })
        }
    }
    return , $lista
}

function Mensajes-ChatGPT($conv, [string]$tsConv) {
    $lista = New-Object System.Collections.Generic.List[object]
    $mapa = G $conv 'mapping'
    if ($mapa -isnot [System.Collections.IDictionary]) { return , $lista }
    $nodos = New-Object System.Collections.Generic.List[object]
    $actual = G $conv 'current_node'
    if ($actual -is [string] -and $mapa.ContainsKey($actual)) {
        # rama activa: de la hoja hacia la raiz, puesta al derecho
        $vistos = @{}
        while ($actual -is [string] -and $mapa.ContainsKey($actual) -and -not $vistos.ContainsKey($actual)) {
            $vistos[$actual] = $true
            $n = $mapa[$actual]
            $nodos.Insert(0, $n)
            $actual = G $n 'parent'
        }
    } else {
        $todos = @()
        foreach ($k in $mapa.Keys) { $todos += , $mapa[$k] }
        $orden = @($todos | Sort-Object { $mm = G $_ 'message'; $ct = G $mm 'create_time'; if ($null -eq $ct) { 0 } else { [double]$ct } })
        foreach ($n in $orden) { $nodos.Add($n) }
    }
    foreach ($n in $nodos) {
        $mm = G $n 'message'
        if ($null -eq $mm) { continue }
        $au = G $mm 'author'
        if ((G $au 'role') -ne 'user') { continue }
        $meta = G $mm 'metadata'
        if ((G $meta 'is_visually_hidden_from_conversation') -eq $true) { continue }
        $c = G $mm 'content'
        $ct = G $c 'content_type'
        if ($null -ne $ct -and $ct -ne 'text' -and $ct -ne 'multimodal_text') { continue }
        $partes = @()
        $ps = G $c 'parts'
        if ($ps -is [System.Collections.IEnumerable] -and $ps -isnot [string]) {
            foreach ($p in $ps) { if ($p -is [string] -and $p.Trim() -ne '') { $partes += $p } }
        }
        $tx = ($partes -join "`n")
        if (EsRuido $tx) { continue }
        $lista.Add([pscustomobject]@{ Ts = (Epoca-A-Texto (G $mm 'create_time') $tsConv); Texto = $tx })
    }
    return , $lista
}

function Procesar-Exportacion([string]$ruta) {
    $jsons = Leer-Exportacion $ruta
    $convs = New-Object System.Collections.Generic.List[object]
    foreach ($j in $jsons) {
        try { $raiz = $js.DeserializeObject($j.TrimStart([char]0xFEFF)) } catch { continue }
        if ($raiz -is [System.Collections.IDictionary]) { $convs.Add($raiz) }
        elseif ($raiz -is [System.Collections.IEnumerable]) { foreach ($c in $raiz) { $convs.Add($c) } }
    }
    # fecha de cada conversacion, para tomar las mas nuevas
    $items = New-Object System.Collections.Generic.List[object]
    foreach ($c in $convs) {
        if ($c -isnot [System.Collections.IDictionary]) { continue }
        if ($c.ContainsKey('chat_messages')) {
            $ts = [string](G $c 'created_at')
            $items.Add([pscustomobject]@{ Conv = $c; Origen = 'claude.ai'; Titulo = [string](G $c 'name'); Ts = $ts; F = (Fecha $ts ([DateTime]::MinValue)) })
        } elseif ($c.ContainsKey('mapping')) {
            $ts = Epoca-A-Texto (G $c 'create_time') ''
            $items.Add([pscustomobject]@{ Conv = $c; Origen = 'chatgpt'; Titulo = [string](G $c 'title'); Ts = $ts; F = (Fecha $ts ([DateTime]::MinValue)) })
        } else { $script:desconocidas++ }
    }
    $elegidos = @($items | Sort-Object F -Descending | Select-Object -First $MaxConversaciones)
    foreach ($it in $elegidos) {
        $script:leidas++
        if ($script:tope) { $script:saltadas++; continue }
        if ($it.Origen -eq 'claude.ai') { $msgs = Mensajes-Claude $it.Conv } else { $msgs = Mensajes-ChatGPT $it.Conv $it.Ts }
        if ($msgs.Count -eq 0) { $script:saltadas++; continue }
        $f0 = $it.F
        if ($f0 -eq [DateTime]::MinValue) { $f0 = Fecha $msgs[0].Ts (Get-Date) }
        $tit = (Tapar $it.Titulo) -replace '\s+', ' '
        $tit = $tit.Trim()
        if ($tit -eq '') { $tit = '(sin titulo)' }
        Emitir $it.Origen $f0 "titulo: $tit" $msgs
    }
}

# ---- conversaciones de Claude Code y Codex en esta compu
function Procesar-Locales {
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

    foreach ($a in $elegidos) {
        $script:leidas++
        if ($script:tope) { $script:saltadas++; continue }
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
            $script:saltadas++
            continue
        } finally {
            if ($null -ne $sr) { $sr.Dispose() }
        }
        if ($subagente -or $msgs.Count -eq 0) { $script:saltadas++; continue }
        $nc = Normal $cwd
        if ($cerebro -and $nc -and ($nc -eq $cerebro -or $nc.StartsWith($cerebro + '/'))) { $script:delCerebro++; continue }

        $f0 = Fecha $msgs[0].Ts $a.Fecha
        Emitir $a.Origen $f0 "carpeta: $cwd" $msgs
    }
}

$modoExport = [bool]$Exportacion
if ($modoExport) { Procesar-Exportacion $Exportacion } else { Procesar-Locales }
Cerrar

$M = $script:paginas.Count
$extra = ''
if ($script:tope) { $extra = ' Se alcanzo el tope de 400 000 caracteres: las mas viejas no salen.' }
if ($modoExport) {
    $resumen = "Resumen: leyo $($script:leidas) conversaciones de la exportacion; con mensajes del dueno: $($script:conDueno); saltadas: $($script:saltadas); claves tapadas en total: $($script:tapadas).$extra"
    if ($script:desconocidas -gt 0) { $resumen += " Entradas con formato desconocido (se ignoraron): $($script:desconocidas)." }
} else {
    $resumen = "Resumen: leyo $($script:leidas) conversaciones; con mensajes del dueno: $($script:conDueno); de esta misma carpeta (no salen): $($script:delCerebro); saltadas: $($script:saltadas); claves tapadas en total: $($script:tapadas).$extra"
}
if ($Salida) { Say 'Aviso: este extractor ya no escribe archivos; -Salida no se usa.' }

if ($M -eq 0) {
    if ($modoExport) { Say 'No hay mensajes del dueno en esa exportacion.' } else { Say 'No hay conversaciones del dueno fuera de esta carpeta.' }
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
