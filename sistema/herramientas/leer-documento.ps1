# leer-documento.ps1
# Lee un .docx, .xlsx o .pptx y escribe su texto en la salida estandar (UTF-8).
# Uso: powershell.exe -NoProfile -ExecutionPolicy Bypass -File leer-documento.ps1 "ruta" [-Limite 2000]
# Con -Csv carpeta (solo .xlsx): escribe cada hoja como un .csv UTF-8 con BOM, sin tope de filas.
# Si corta, el aviso sale arriba (antes del texto, con el total de renglones y, en Excel, las filas de cada hoja) y otra vez abajo.
# Compatible con PowerShell 5.1. Codigo fuente solo ASCII (sin acentos) a proposito.

param(
    [Parameter(Position = 0)][string]$Ruta,
    [int]$Limite = 2000,
    [string]$Csv = ''
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$utf8 = New-Object System.Text.UTF8Encoding($false)
$script:out = New-Object System.IO.StreamWriter([Console]::OpenStandardOutput(), $utf8)
$script:out.NewLine = "`n"
$script:n = 0
$script:total = 0
$script:cortado = $false
$script:avisoFechas = $false
$script:tmpZip = $null
$script:csvW = $null
$script:csvFilas = 0
$script:lineas = New-Object System.Collections.Generic.List[string]
$script:hojas = New-Object System.Collections.Generic.List[string]
$inv = [System.Globalization.CultureInfo]::InvariantCulture

# Guarda hasta $Limite renglones y sigue contando los demas, para decir arriba cuanto falta.
function Emitir([string]$linea) {
    $script:total++
    if ($script:n -ge $Limite) { $script:cortado = $true; return }
    $script:lineas.Add($linea)
    $script:n++
}

function Terminar([int]$codigo) {
    $script:out.Flush()
    if ($script:tmpZip -and (Test-Path -LiteralPath $script:tmpZip)) {
        Remove-Item -LiteralPath $script:tmpZip -Force -ErrorAction SilentlyContinue
    }
    exit $codigo
}

if (-not $Ruta) {
    $script:out.WriteLine('Falta la ruta. Uso: leer-documento.ps1 "ruta/archivo.docx" [-Limite 2000] [-Csv carpeta]')
    Terminar 1
}
if (-not (Test-Path -LiteralPath $Ruta -PathType Leaf)) {
    $script:out.WriteLine("No existe el archivo: $Ruta")
    Terminar 1
}

$ext = [System.IO.Path]::GetExtension($Ruta).ToLowerInvariant()
if (@('.docx', '.xlsx', '.pptx') -notcontains $ext) {
    $script:out.WriteLine('usa la lectura de tu app para este tipo')
    Terminar 0
}

$rutaCompleta = (Resolve-Path -LiteralPath $Ruta).ProviderPath

if ($Csv -and $ext -ne '.xlsx') {
    $script:out.WriteLine('-Csv solo sirve con archivos .xlsx')
    Terminar 1
}
$carpetaCsv = ''
if ($Csv) {
    $carpetaCsv = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Csv)
    if (-not (Test-Path -LiteralPath $carpetaCsv)) { New-Item -ItemType Directory -Path $carpetaCsv -Force | Out-Null }
}

function CampoCsv([string]$v) {
    if ($v.IndexOfAny([char[]]@(',', '"', "`n", "`r")) -ge 0) { return ('"' + $v.Replace('"', '""') + '"') }
    return $v
}

function AbrirZip([string]$p) {
    try {
        return [System.IO.Compression.ZipFile]::OpenRead($p)
    } catch {
        # el archivo puede estar abierto en Word/Excel: leer una copia
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
        Copy-Item -LiteralPath $p -Destination $tmp -ErrorAction Stop
        $script:tmpZip = $tmp
        return [System.IO.Compression.ZipFile]::OpenRead($tmp)
    }
}

function CargarXml($zip, [string]$nombre) {
    $e = $zip.GetEntry($nombre)
    if ($null -eq $e) { return $null }
    $s = $e.Open()
    try {
        $d = New-Object System.Xml.XmlDocument
        $d.XmlResolver = $null
        $d.Load($s)
        return , $d
    } finally {
        $s.Dispose()
    }
}

function NuevoLector($zip, [string]$nombre) {
    $e = $zip.GetEntry($nombre)
    if ($null -eq $e) { return $null }
    $cfg = New-Object System.Xml.XmlReaderSettings
    $cfg.XmlResolver = $null
    $cfg.DtdProcessing = [System.Xml.DtdProcessing]::Ignore
    $s = $e.Open()
    $xr = [System.Xml.XmlReader]::Create($s, $cfg)
    return , $xr
}

function ResolverRuta([string]$base, [string]$destino) {
    if ($destino.StartsWith('/')) { return $destino.TrimStart('/') }
    $partes = New-Object System.Collections.Generic.List[string]
    foreach ($p in (($base + $destino) -split '/')) {
        if ($p -eq '..') { if ($partes.Count -gt 0) { $partes.RemoveAt($partes.Count - 1) } }
        elseif ($p -ne '.' -and $p -ne '') { $partes.Add($p) }
    }
    return ($partes -join '/')
}

function Limpio([string]$t) {
    return ($t -replace "[`t`r`n]+", ' ').Trim()
}

# ---------------------------------------------------------------- Word
function LeerWord($zip) {
    $doc = CargarXml $zip 'word/document.xml'
    if ($null -eq $doc) { Emitir 'No encontre word/document.xml: el archivo no parece un .docx valido.'; return }
    $script:wns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
    $script:wns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
    $body = $doc.SelectSingleNode('//w:body', $script:wns)
    if ($null -eq $body) { return }
    ProcesarHijosWord $body
}

function TextoParrafo($p) {
    $sb = New-Object System.Text.StringBuilder
    foreach ($n in $p.SelectNodes('.//w:t | .//w:r/w:tab | .//w:r/w:br | .//w:r/w:cr', $script:wns)) {
        $ln = $n.LocalName
        if ($ln -eq 't') { [void]$sb.Append($n.InnerText) }
        elseif ($ln -eq 'tab') { [void]$sb.Append("`t") }
        else { [void]$sb.Append(' ') }
    }
    return $sb.ToString()
}

function ProcesarHijosWord($contenedor) {
    foreach ($h in $contenedor.ChildNodes) {
        $ln = $h.LocalName
        if ($ln -eq 'p') {
            $t = (TextoParrafo $h).TrimEnd()
            if ($t.Trim() -ne '') { Emitir $t }
        } elseif ($ln -eq 'tbl') {
            foreach ($tr in $h.SelectNodes('w:tr', $script:wns)) {
                $celdas = New-Object System.Collections.Generic.List[string]
                foreach ($tc in $tr.SelectNodes('w:tc', $script:wns)) {
                    $partes = New-Object System.Collections.Generic.List[string]
                    foreach ($p in $tc.SelectNodes('.//w:p', $script:wns)) {
                        $pt = Limpio (TextoParrafo $p)
                        if ($pt -ne '') { $partes.Add($pt) }
                    }
                    $celdas.Add(($partes -join ' '))
                }
                Emitir ($celdas -join "`t")
            }
        } elseif ($ln -eq 'sdt') {
            $c = $h.SelectSingleNode('w:sdtContent', $script:wns)
            if ($null -ne $c) { ProcesarHijosWord $c }
        }
    }
}

# ---------------------------------------------------------------- PowerPoint
function LeerPpt($zip) {
    $ans = 'http://schemas.openxmlformats.org/drawingml/2006/main'
    $rns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
    $lista = New-Object System.Collections.Generic.List[string]
    $pres = CargarXml $zip 'ppt/presentation.xml'
    $rels = CargarXml $zip 'ppt/_rels/presentation.xml.rels'
    if ($null -ne $pres -and $null -ne $rels) {
        $mapa = @{}
        foreach ($r in $rels.SelectNodes("//*[local-name()='Relationship']")) {
            $mapa[$r.GetAttribute('Id')] = $r.GetAttribute('Target')
        }
        foreach ($s in $pres.SelectNodes("//*[local-name()='sldId']")) {
            $rid = $s.GetAttribute('id', $rns)
            if ($rid -and $mapa.ContainsKey($rid)) { $lista.Add((ResolverRuta 'ppt/' $mapa[$rid])) }
        }
    }
    if ($lista.Count -eq 0) {
        $tmp = @()
        foreach ($e in $zip.Entries) {
            if ($e.FullName -match '^ppt/slides/slide(\d+)\.xml$') {
                $tmp += , @([int]$Matches[1], $e.FullName)
            }
        }
        foreach ($x in ($tmp | Sort-Object { $_[0] })) { $lista.Add($x[1]) }
    }
    $i = 0
    foreach ($ruta in $lista) {
        $i++
        Emitir "Diapositiva $i"
        $d = CargarXml $zip $ruta
        if ($null -eq $d) { continue }
        $ns = New-Object System.Xml.XmlNamespaceManager($d.NameTable)
        $ns.AddNamespace('a', $ans)
        foreach ($p in $d.SelectNodes('//a:p', $ns)) {
            $sb = New-Object System.Text.StringBuilder
            foreach ($n in $p.SelectNodes('.//a:t | .//a:br', $ns)) {
                if ($n.LocalName -eq 't') { [void]$sb.Append($n.InnerText) } else { [void]$sb.Append(' ') }
            }
            $t = Limpio $sb.ToString()
            if ($t -ne '') { Emitir $t }
        }
    }
}

# ---------------------------------------------------------------- Excel
function EsFormatoFecha([int]$id, $custom) {
    if (($id -ge 14 -and $id -le 22) -or ($id -ge 27 -and $id -le 36) -or ($id -ge 45 -and $id -le 47) -or ($id -ge 50 -and $id -le 58)) { return $true }
    if (-not $custom.ContainsKey($id)) { return $false }
    $c = ([string]$custom[$id]).ToLowerInvariant()
    $c = [regex]::Replace($c, '"[^"]*"', '')
    $c = [regex]::Replace($c, '\[[^\]]*\]', '')
    $c = [regex]::Replace($c, '\\.', '')
    $c = [regex]::Replace($c, '[_*].', '')
    return ($c -match '[dmyhs]')
}

function LeerEstilos($zip) {
    $d = CargarXml $zip 'xl/styles.xml'
    if ($null -eq $d) { $script:avisoFechas = $true; return , @() }
    $ns = New-Object System.Xml.XmlNamespaceManager($d.NameTable)
    $ns.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
    $custom = @{}
    foreach ($f in $d.SelectNodes('//x:numFmts/x:numFmt', $ns)) {
        $custom[[int]$f.GetAttribute('numFmtId')] = $f.GetAttribute('formatCode')
    }
    $res = New-Object System.Collections.Generic.List[bool]
    foreach ($xf in $d.SelectNodes('//x:cellXfs/x:xf', $ns)) {
        $a = $xf.GetAttribute('numFmtId')
        $id = 0
        if ($a) { $id = [int]$a }
        $res.Add((EsFormatoFecha $id $custom))
    }
    return , $res
}

function LeerSst($zip) {
    $lista = New-Object System.Collections.Generic.List[string]
    $xr = NuevoLector $zip 'xl/sharedStrings.xml'
    if ($null -eq $xr) { return , $lista }
    $sb = New-Object System.Text.StringBuilder
    $inRph = $false
    $avanzar = $true
    while ($true) {
        if ($avanzar) { if (-not $xr.Read()) { break } }
        $avanzar = $true
        if ($xr.NodeType -eq [System.Xml.XmlNodeType]::Element) {
            $ln = $xr.LocalName
            if ($ln -eq 'si') {
                [void]$sb.Clear()
                if ($xr.IsEmptyElement) { $lista.Add('') }
            } elseif ($ln -eq 'rPh') {
                $inRph = $true
            } elseif ($ln -eq 't') {
                $txt = $xr.ReadElementContentAsString()
                $avanzar = $false
                if (-not $inRph) { [void]$sb.Append($txt) }
            }
        } elseif ($xr.NodeType -eq [System.Xml.XmlNodeType]::EndElement) {
            $ln = $xr.LocalName
            if ($ln -eq 'rPh') { $inRph = $false }
            elseif ($ln -eq 'si') { $lista.Add($sb.ToString()) }
        }
    }
    $xr.Close()
    return , $lista
}

function IndiceCol([string]$ref) {
    $n = 0
    foreach ($ch in $ref.ToCharArray()) {
        $c = [int]$ch
        if ($c -ge 65 -and $c -le 90) { $n = $n * 26 + ($c - 64) } else { break }
    }
    return ($n - 1)
}

function TextoFecha([string]$val, $base, [bool]$esDia) {
    $d = [double]::Parse($val, $inv)
    if ($d -lt 0) { return $val }
    $dt = $base.AddSeconds([math]::Round($d * 86400))
    if ($d -lt 1) { return $dt.ToString('HH:mm', $inv) }
    if ($dt.TimeOfDay.TotalSeconds -eq 0) { return $dt.ToString('yyyy-MM-dd', $inv) }
    return $dt.ToString('yyyy-MM-dd HH:mm', $inv)
}

function ConvertirCelda($t, $val, $inline, $s, $sst, $fechas, $base) {
    if ($t -ceq 's') {
        $i = -1
        if ([int]::TryParse([string]$val, [ref]$i) -and $i -ge 0 -and $i -lt $sst.Count) { return $sst[$i] }
        return ''
    }
    if ($t -ceq 'str' -or $t -ceq 'e' -or $t -ceq 'd') { return [string]$val }
    if ($t -ceq 'inlineStr') { return [string]$inline }
    if ($t -ceq 'b') { if ($val -eq '1') { return 'VERDADERO' } else { return 'FALSO' } }
    if ($null -eq $val -or $val -eq '') { return '' }
    $idx = -1
    if ($s -and [int]::TryParse($s, [ref]$idx) -and $idx -ge 0 -and $idx -lt $fechas.Count -and $fechas[$idx]) {
        try { return (TextoFecha $val $base $true) } catch { return [string]$val }
    }
    return [string]$val
}

function LeerHoja($zip, [string]$ruta, $sst, $fechas, $base) {
    $xr = NuevoLector $zip $ruta
    if ($null -eq $xr) { Emitir "(no encontre $ruta)"; return }
    $celdas = @{}
    $maxCol = -1
    $sig = 0
    $enCelda = $false
    $ref = ''; $t = ''; $s = ''; $val = $null; $inline = ''; $col = 0
    $hayDato = $false
    $avanzar = $true
    while ($true) {
        if ($avanzar) { if (-not $xr.Read()) { break } }
        $avanzar = $true
        $nt = $xr.NodeType
        if ($script:cortado -and -not $script:csvW) {
            # pasado el limite: ya no se convierte nada, solo se cuentan las filas con algun dato
            if ($nt -eq [System.Xml.XmlNodeType]::Element) {
                $ln = $xr.LocalName
                if ($ln -eq 'row') { $hayDato = $false }
                elseif ($ln -eq 'c') { $t = $xr.GetAttribute('t'); $enCelda = (-not $xr.IsEmptyElement) }
                elseif (($ln -eq 'v' -or $ln -eq 't') -and $enCelda) {
                    $x = $xr.ReadElementContentAsString()
                    $avanzar = $false
                    if ($ln -eq 'v' -and $t -ceq 's') {
                        $i = -1
                        if ([int]::TryParse($x, [ref]$i) -and $i -ge 0 -and $i -lt $sst.Count) { $x = $sst[$i] } else { $x = '' }
                    }
                    if ($x.Trim() -ne '') { $hayDato = $true }
                }
            } elseif ($nt -eq [System.Xml.XmlNodeType]::EndElement) {
                $ln = $xr.LocalName
                if ($ln -eq 'c' -and $enCelda) { if ($t -ceq 'b') { $hayDato = $true }; $enCelda = $false }
                elseif ($ln -eq 'row' -and $hayDato) { $script:total++ }
            }
            continue
        }
        if ($nt -eq [System.Xml.XmlNodeType]::Element) {
            $ln = $xr.LocalName
            if ($ln -eq 'row') {
                $celdas = @{}; $maxCol = -1; $sig = 0
            } elseif ($ln -eq 'c') {
                $ref = $xr.GetAttribute('r')
                $t = $xr.GetAttribute('t')
                $s = $xr.GetAttribute('s')
                $val = $null; $inline = ''
                if ($ref) { $col = IndiceCol $ref } else { $col = $sig }
                $sig = $col + 1
                $enCelda = (-not $xr.IsEmptyElement)
            } elseif ($ln -eq 'v' -and $enCelda) {
                $val = $xr.ReadElementContentAsString()
                $avanzar = $false
            } elseif ($ln -eq 't' -and $enCelda) {
                $inline += $xr.ReadElementContentAsString()
                $avanzar = $false
            }
        } elseif ($nt -eq [System.Xml.XmlNodeType]::EndElement) {
            $ln = $xr.LocalName
            if ($ln -eq 'c' -and $enCelda) {
                $celdas[$col] = Limpio (ConvertirCelda $t $val $inline $s $sst $fechas $base)
                if ($col -gt $maxCol) { $maxCol = $col }
                $enCelda = $false
            } elseif ($ln -eq 'row') {
                if ($maxCol -ge 0) {
                    $partes = New-Object string[] ($maxCol + 1)
                    for ($k = 0; $k -le $maxCol; $k++) {
                        if ($celdas.ContainsKey($k)) { $partes[$k] = $celdas[$k] } else { $partes[$k] = '' }
                    }
                    $linea = ($partes -join "`t").TrimEnd("`t")
                    if ($script:csvW) {
                        if ($linea -ne '') {
                            $script:csvW.WriteLine((($partes | ForEach-Object { CampoCsv $_ }) -join ','))
                            $script:csvFilas++
                        }
                    } elseif ($linea -ne '') { Emitir $linea }
                }
            }
        }
    }
    $xr.Close()
}

function LeerExcel($zip) {
    $mns = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'
    $rns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
    $wb = CargarXml $zip 'xl/workbook.xml'
    $rels = CargarXml $zip 'xl/_rels/workbook.xml.rels'
    if ($null -eq $wb -or $null -eq $rels) { Emitir 'No encontre xl/workbook.xml: el archivo no parece un .xlsx valido.'; return }
    $ns = New-Object System.Xml.XmlNamespaceManager($wb.NameTable)
    $ns.AddNamespace('x', $mns)
    $base = New-Object DateTime 1899, 12, 30
    $wp = $wb.SelectSingleNode('//x:workbookPr', $ns)
    if ($null -ne $wp) {
        $a = $wp.GetAttribute('date1904')
        if ($a -eq '1' -or $a -eq 'true') { $base = New-Object DateTime 1904, 1, 1 }
    }
    $mapa = @{}
    foreach ($r in $rels.SelectNodes("//*[local-name()='Relationship']")) {
        $mapa[$r.GetAttribute('Id')] = $r.GetAttribute('Target')
    }
    $sst = LeerSst $zip
    $fechas = LeerEstilos $zip
    $usados = @{}
    foreach ($sh in $wb.SelectNodes('//x:sheets/x:sheet', $ns)) {
        $nombre = $sh.GetAttribute('name')
        $rid = $sh.GetAttribute('id', $rns)
        if ($carpetaCsv) {
            if (-not $rid -or -not $mapa.ContainsKey($rid)) { $script:out.WriteLine("Hoja `"$nombre`": sin ruta, no se escribio"); continue }
            $limpio = [regex]::Replace($nombre, '[\\/:*?"<>|]', '_').Trim()
            if ($limpio -eq '') { $limpio = 'hoja' }
            $destino = Join-Path $carpetaCsv ($limpio + '.csv')
            $k = 2
            while ($usados.ContainsKey($destino.ToLowerInvariant())) { $destino = Join-Path $carpetaCsv ($limpio + '-' + $k + '.csv'); $k++ }
            $usados[$destino.ToLowerInvariant()] = $true
            $script:csvW = New-Object System.IO.StreamWriter($destino, $false, (New-Object System.Text.UTF8Encoding($true)))
            $script:csvW.NewLine = "`r`n"
            $script:csvFilas = 0
            try { LeerHoja $zip (ResolverRuta 'xl/' $mapa[$rid]) $sst $fechas $base }
            finally { $script:csvW.Dispose(); $script:csvW = $null }
            $script:out.WriteLine("Hoja `"$nombre`": $($script:csvFilas) filas -> $destino")
            continue
        }
        Emitir "Hoja: $nombre"
        if (-not $rid -or -not $mapa.ContainsKey($rid)) { Emitir '(hoja sin ruta)'; continue }
        $rutaHoja = ResolverRuta 'xl/' $mapa[$rid]
        if ($null -eq $zip.GetEntry($rutaHoja)) { Emitir "(no encontre $rutaHoja)"; continue }
        $t0 = $script:total
        $n0 = $script:n
        LeerHoja $zip $rutaHoja $sst $fechas $base
        $filas = $script:total - $t0
        $vistas = $script:n - $n0
        $txt = "$nombre`: $filas filas"
        if ($vistas -lt $filas) { $txt += " (aqui solo salen $vistas)" }
        $script:hojas.Add($txt)
    }
}

# ---------------------------------------------------------------- Salida
# Escribe lo guardado: si corto, el aviso va arriba y abajo, con cuanto falta.
function Volcar {
    $faltan = $script:total - $script:n
    $comoVerTodo = "corre otra vez con -Limite $($script:total)"
    if ($ext -eq '.xlsx') { $comoVerTodo += ' o pasa el Excel a CSV con -Csv entrada/_paso y lee el CSV entero' }
    if ($script:cortado) {
        $script:out.WriteLine("[aviso] LECTURA INCOMPLETA: el documento tiene $($script:total) renglones y aqui solo salen los primeros $($script:n); faltan $faltan. No saques conclusiones de este archivo hasta leer el resto: $comoVerTodo.")
        if ($script:hojas.Count -gt 0) { $script:out.WriteLine('[aviso] Hojas: ' + ($script:hojas -join ' | ')) }
        $script:out.WriteLine('')
    }
    foreach ($l in $script:lineas) { $script:out.WriteLine($l) }
    $script:lineas.Clear()
    if ($script:cortado) {
        $script:out.WriteLine("[aviso] corte en $Limite renglones de $($script:total); faltan $faltan. Para ver todo, $comoVerTodo.")
    }
    if ($script:avisoFechas) {
        $script:out.WriteLine('[aviso] no pude leer los estilos del archivo; las fechas guardadas como numero salen como numero (dias desde 1899-12-30).')
    }
}

# ---------------------------------------------------------------- Principal
$zip = $null
try {
    try {
        $zip = AbrirZip $rutaCompleta
    } catch {
        $script:out.WriteLine('No pude abrir el archivo (puede estar danado o con contrasena).')
        Terminar 1
    }
    if ($ext -eq '.docx') { LeerWord $zip }
    elseif ($ext -eq '.pptx') { LeerPpt $zip }
    else { LeerExcel $zip }
} finally {
    if ($null -ne $zip) { $zip.Dispose() }
    Volcar
}
Terminar 0
