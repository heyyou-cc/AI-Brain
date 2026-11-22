#!/bin/bash
# leer-documento.sh
# Lee un .docx, .xlsx o .pptx y escribe su texto en la salida estandar (UTF-8).
# Uso: bash leer-documento.sh "ruta" [limite]      (limite por defecto: 2000)
#      bash leer-documento.sh "ruta.xlsx" --csv carpeta   (cada hoja a un .csv UTF-8 con BOM, sin tope de filas)
# Si corta, el aviso sale arriba (antes del texto, con el total de renglones y, en Excel, las filas de cada hoja) y otra vez abajo.
# Solo usa lo que trae el sistema: unzip, awk, sed, mktemp. Compatible con bash 3.2 de Mac.

RUTA=""
LIMITE=2000
CSV=""
while [ $# -gt 0 ]; do
  case "$1" in
    -Limite|--limite|-limite) LIMITE="$2"; shift 2 ;;
    -Csv|--csv|-csv) CSV="$2"; shift 2 ;;
    *) if [ -z "$RUTA" ]; then RUTA="$1"; else LIMITE="$1"; fi; shift ;;
  esac
done
case "$LIMITE" in ''|*[!0-9]*) LIMITE=2000 ;; esac

if [ -z "$RUTA" ]; then echo 'Falta la ruta. Uso: bash leer-documento.sh "ruta/archivo.docx" [limite] [--csv carpeta]'; exit 1; fi
if [ ! -f "$RUTA" ]; then echo "No existe el archivo: $RUTA"; exit 1; fi

EXT=$(printf '%s' "${RUTA##*.}" | tr 'A-Z' 'a-z')
case "$EXT" in
  docx|xlsx|pptx) ;;
  *) echo 'usa la lectura de tu app para este tipo'; exit 0 ;;
esac
if [ -n "$CSV" ] && [ "$EXT" != "xlsx" ]; then echo '--csv solo sirve con archivos .xlsx'; exit 1; fi
if ! command -v unzip >/dev/null 2>&1; then echo 'No encuentro unzip en este equipo.'; exit 1; fi

T=$(mktemp -d 2>/dev/null || mktemp -d -t leerdoc)
trap 'rm -rf "$T"' EXIT

RESTO=$LIMITE
CORTADO=0
AVISO_FECHAS=0
TOTAL=0
HOJAS=""

# ---- biblioteca de awk: cada registro es lo que sigue a un "<" ----
read -r -d '' LIB <<'EOF'
function decod(s) {
  gsub(/[\r\n\t]/, " ", s)
  if (index(s, "&") == 0) return s
  gsub(/&lt;/, "<", s); gsub(/&gt;/, ">", s); gsub(/&quot;/, "\"", s); gsub(/&apos;/, "'", s)
  gsub(/&#(10|13|9|x[aAdD9]);/, " ", s)
  gsub(/&amp;/, "\\&", s)
  return s
}
function attr(tag, name,   re, m) {
  re = "[ \t\r\n]" name "=\"[^\"]*\""
  if (match(tag, re)) { m = substr(tag, RSTART, RLENGTH); sub(/^[^=]*="/, "", m); sub(/"$/, "", m); return m }
  return ""
}
function emit(s) {
  tot++
  if (n >= lim) { cut = 1; return }
  if (csv) printf("%s\r\n", s); else print s
  n++
}
function parse(   rec, gt) {
  rec = $0
  gt = index(rec, ">")
  isend = 0; selfc = 0; nm = ""; tag = ""; txt = ""
  if (gt == 0) return 0
  tag = substr(rec, 1, gt - 1); txt = substr(rec, gt + 1)
  if (substr(tag, 1, 1) == "?" || substr(tag, 1, 1) == "!") return 0
  if (substr(tag, 1, 1) == "/") { isend = 1; nm = substr(tag, 2) } else nm = tag
  sub(/[ \t\r\n\/].*/, "", nm)
  if (substr(tag, length(tag), 1) == "/") selfc = 1
  return 1
}
END { printf("%d\n%d\n%d\n", n, cut, tot) > cntf }
EOF

# lanza un programa awk sobre un XML; actualiza RESTO, CORTADO y TOTAL
# (pasado el limite ya no escribe, pero sigue contando para decir cuanto falta)
correr() { # $1 = programa; $2 = archivo; resto = -v extra
  local prog="$1" archivo="$2"; shift 2
  local rest=$RESTO
  [ "$rest" -lt 0 ] && rest=0
  awk -v lim="$rest" -v cntf="$T/cnt" "$@" "$LIB
$prog" "$archivo"
  local N C TT
  N=$(sed -n 1p "$T/cnt" 2>/dev/null); C=$(sed -n 2p "$T/cnt" 2>/dev/null); TT=$(sed -n 3p "$T/cnt" 2>/dev/null)
  [ -z "$N" ] && N=0
  [ -z "$TT" ] && TT=0
  RESTO=$((RESTO - N))
  TOTAL=$((TOTAL + TT))
  [ "$C" = "1" ] && CORTADO=1
  return 0
}

emitir_shell() {
  TOTAL=$((TOTAL + 1))
  if [ "$RESTO" -le 0 ]; then CORTADO=1; return 1; fi
  printf '%s\n' "$1"; RESTO=$((RESTO - 1)); return 0
}

sacar() { unzip -p "$RUTA" "$1" > "$2" 2>/dev/null; [ -s "$2" ]; }

# ------------------------------------------------------------ Word
read -r -d '' PROG_WORD <<'EOF'
BEGIN { RS = "<"; n = 0; cut = 0; tbl = 0; inppr = 0; par = "" }
{
  if (!parse()) next
  if (nm == "w:pPr") { inppr = !isend; next }
  if (isend == 0 && selfc == 0 && nm == "w:t") { par = par decod(txt); next }
  if (isend == 0 && nm == "w:tab" && !inppr) { par = par "\t"; next }
  if (isend == 0 && (nm == "w:br" || nm == "w:cr") && !inppr) { par = par " "; next }
  if (nm == "w:p") {
    if (!isend) { par = ""; next }
    if (tbl > 0) {
      gsub(/\t/, " ", par); sub(/^ +/, "", par); sub(/ +$/, "", par)
      if (par != "") cell = (cell == "" ? par : cell " " par)
    } else {
      sub(/[ \t]+$/, "", par)
      if (par ~ /[^ \t]/) emit(par)
    }
    par = ""; next
  }
  if (nm == "w:tbl") { if (!isend) { tbl++; if (tbl == 1) row = "" } else tbl--; next }
  if (nm == "w:tr" && tbl == 1) { if (!isend) { row = ""; ncell = 0 } else emit(row); next }
  if (nm == "w:tc" && tbl == 1) {
    if (!isend) cell = ""
    else { row = (ncell > 0 ? row "\t" : "") cell; ncell++ }
    next
  }
}
EOF

leer_word() {
  sacar word/document.xml "$T/doc.xml" || { echo 'No encontre word/document.xml: el archivo no parece un .docx valido.'; return; }
  correr "$PROG_WORD" "$T/doc.xml"
}

# ------------------------------------------------------------ PowerPoint
read -r -d '' PROG_SLIDE <<'EOF'
BEGIN { RS = "<"; n = 0; cut = 0; par = "" }
{
  if (!parse()) next
  if (isend == 0 && selfc == 0 && nm == "a:t") { par = par decod(txt); next }
  if (isend == 0 && nm == "a:br") { par = par " "; next }
  if (nm == "a:p") {
    if (!isend) { par = ""; next }
    sub(/^ +/, "", par); sub(/ +$/, "", par)
    if (par != "") emit(par)
    par = ""
  }
}
EOF

read -r -d '' PROG_RIDS <<'EOF'
BEGIN { RS = "<" }
{ if (!parse()) next
  if (!isend && nm == "p:sldId") print attr(tag, "r:id") }
EOF

read -r -d '' PROG_RELS <<'EOF'
BEGIN { RS = "<" }
{ if (!parse()) next
  if (!isend && nm == "Relationship") print attr(tag, "Id") "\t" attr(tag, "Target") }
EOF

limpia_lib() { awk "$LIB
BEGIN{RS=\"<\"} $1" "$2"; }

leer_ppt() {
  : > "$T/slides.txt"
  if sacar ppt/presentation.xml "$T/pres.xml" && sacar ppt/_rels/presentation.xml.rels "$T/prels.xml"; then
    awk -v cntf="$T/x" "$LIB
$PROG_RELS" "$T/prels.xml" > "$T/rels.tsv"
    awk -v cntf="$T/x" "$LIB
$PROG_RIDS" "$T/pres.xml" | while read -r rid; do
      [ -z "$rid" ] && continue
      tgt=$(awk -F'\t' -v id="$rid" '$1 == id { print $2; exit }' "$T/rels.tsv")
      case "$tgt" in /*) tgt="${tgt#/}" ;; *) tgt="ppt/$tgt" ;; esac
      [ -n "$tgt" ] && echo "$tgt"
    done > "$T/slides.txt"
  fi
  if [ ! -s "$T/slides.txt" ]; then
    unzip -Z1 "$RUTA" 2>/dev/null | grep -E '^ppt/slides/slide[0-9]+\.xml$' \
      | sed 's/.*slide\([0-9]*\)\.xml$/\1 &/' | sort -n | cut -d' ' -f2- > "$T/slides.txt"
  fi
  local i=0 ruta
  while IFS= read -r ruta; do
    [ -z "$ruta" ] && continue
    i=$((i + 1))
    emitir_shell "Diapositiva $i"
    if sacar "$ruta" "$T/slide.xml"; then
      correr "$PROG_SLIDE" "$T/slide.xml"
    fi
  done < "$T/slides.txt"
}

# ------------------------------------------------------------ Excel
read -r -d '' PROG_SST <<'EOF'
BEGIN { RS = "<"; cur = ""; rph = 0 }
{
  if (!parse()) next
  if (nm == "si") { if (!isend) { cur = ""; if (selfc) print "" } else print cur; next }
  if (nm == "rPh") { rph = !isend; next }
  if (nm == "t" && !isend && !selfc && !rph) cur = cur decod(txt)
}
END { }
EOF

read -r -d '' PROG_STYLES <<'EOF'
function esfecha(id,   c) {
  id = id + 0
  if ((id >= 14 && id <= 22) || (id >= 27 && id <= 36) || (id >= 45 && id <= 47) || (id >= 50 && id <= 58)) return 1
  if (!(id in custom)) return 0
  c = tolower(custom[id])
  gsub(/"[^"]*"/, "", c); gsub(/\[[^]]*\]/, "", c); gsub(/\\./, "", c); gsub(/[_*]./, "", c)
  return (c ~ /[dmyhs]/) ? 1 : 0
}
BEGIN { RS = "<"; incx = 0 }
{
  if (!parse()) next
  if (nm == "numFmt" && !isend) { custom[attr(tag, "numFmtId") + 0] = decod(attr(tag, "formatCode")); next }
  if (nm == "cellXfs") { incx = !isend; next }
  if (nm == "xf" && incx && !isend) print esfecha(attr(tag, "numFmtId"))
}
EOF

read -r -d '' PROG_WB <<'EOF'
BEGIN { RS = "<" }
{
  if (!parse()) next
  if (isend) next
  if (nm == "sheet") print "S\t" decod(attr(tag, "name")) "\t" attr(tag, "r:id")
  if (nm == "workbookPr") { v = attr(tag, "date1904"); if (v == "1" || v == "true") print "D" }
}
EOF

read -r -d '' PROG_HOJA <<'EOF'
function colidx(ref,   i, c, k, v) {
  v = 0
  for (i = 1; i <= length(ref); i++) {
    c = substr(ref, i, 1); k = index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", c)
    if (k == 0) break
    v = v * 26 + k
  }
  return v - 1
}
function fechatxt(v,   secs, days, tod, u, z, era, doe, yoe, y, doy, mp, d, m, s) {
  if (v < 0) return v
  secs = int(v * 86400 + 0.5); days = int(secs / 86400); tod = secs - days * 86400
  if (v < 1) return sprintf("%02d:%02d", int(tod / 3600), int((tod % 3600) / 60))
  u = days - epoch
  z = u + 719468; era = int(z / 146097); doe = z - era * 146097
  yoe = int((doe - int(doe / 1460) + int(doe / 36524) - int(doe / 146096)) / 365)
  y = yoe + era * 400; doy = doe - (365 * yoe + int(yoe / 4) - int(yoe / 100))
  mp = int((5 * doy + 2) / 153); d = doy - int((153 * mp + 2) / 5) + 1
  m = (mp < 10) ? mp + 3 : mp - 9
  if (m <= 2) y++
  s = sprintf("%04d-%02d-%02d", y, m, d)
  if (tod > 0) s = s sprintf(" %02d:%02d", int(tod / 3600), int((tod % 3600) / 60))
  return s
}
BEGIN {
  RS = "\n"; i = 0
  while ((getline l < ssf) > 0) { ss[i++] = l }
  close(ssf)
  j = 0
  while ((getline l < ff) > 0) { fech[j++] = l }
  close(ff)
  RS = "<"; n = 0; cut = 0
  epoch = (d1904 == 1) ? 24107 : 25569
  incell = 0
}
{
  if (!parse()) next
  if (n >= lim && !csv) {
    # pasado el limite: ya no se convierte nada, solo se cuentan las filas con algun dato
    if (nm == "c") {
      if (!isend) { ct = attr(tag, "t"); val = ""; inl = ""; incell = selfc ? 0 : 1 }
      else if (incell) {
        if (ct == "b" || (ct == "s" && ss[val + 0] != "") || (ct != "s" && (val != "" || inl != ""))) hd = 1
        incell = 0
      }
      next
    }
    if (incell && !isend && !selfc && nm == "v") { val = txt; next }
    if (incell && !isend && !selfc && nm == "t") { inl = inl txt; next }
    if (nm == "row" && isend) { if (hd) { tot++; cut = 1 }; hd = 0 }
    next
  }
  if (nm == "row" && !isend) { split("", cells); maxc = -1; nxt = 0; next }
  if (nm == "c" && !isend) {
    r = attr(tag, "r"); ct = attr(tag, "t"); cs = attr(tag, "s")
    val = ""; hasval = 0; inl = ""
    col = (r == "") ? nxt : colidx(r)
    nxt = col + 1
    incell = selfc ? 0 : 1
    next
  }
  if (nm == "v" && !isend && incell) { val = decod(txt); hasval = 1; next }
  if (nm == "t" && !isend && incell) { inl = inl decod(txt); next }
  if (nm == "c" && isend && incell) {
    if (ct == "s") out = ss[val + 0]
    else if (ct == "str" || ct == "e" || ct == "d") out = val
    else if (ct == "inlineStr") out = inl
    else if (ct == "b") out = (val == "1") ? "VERDADERO" : "FALSO"
    else if (hasval) { if (cs != "" && fech[cs + 0] == 1) out = fechatxt(val + 0); else out = val }
    else out = ""
    cells[col] = out
    if (col > maxc) maxc = col
    incell = 0
    next
  }
  if (nm == "row" && isend) {
    if (csv) {
      line = ""; ne = 0
      for (k = 0; k <= maxc; k++) {
        v = (k in cells) ? cells[k] : ""
        if (v != "") ne++
        if (v ~ /[",]/) { gsub(/"/, "\"\"", v); v = "\"" v "\"" }
        line = line (k > 0 ? "," : "") v
      }
      if (ne > 0) emit(line)
    } else {
      line = ""
      for (k = 0; k <= maxc; k++) line = line (k > 0 ? "\t" : "") ((k in cells) ? cells[k] : "")
      sub(/\t+$/, "", line)
      if (line != "") emit(line)
    }
  }
}
EOF

leer_excel() {
  sacar xl/workbook.xml "$T/wb.xml" || { echo 'No encontre xl/workbook.xml: el archivo no parece un .xlsx valido.'; return; }
  sacar xl/_rels/workbook.xml.rels "$T/wbrels.xml" || : > "$T/wbrels.xml"
  : > "$T/ss.xml"; sacar xl/sharedStrings.xml "$T/ss.xml"
  : > "$T/st.xml"; sacar xl/styles.xml "$T/st.xml"
  awk -v cntf="$T/x" "$LIB
$PROG_SST" "$T/ss.xml" > "$T/ss.tsv"
  awk -v cntf="$T/x" "$LIB
$PROG_STYLES" "$T/st.xml" > "$T/fechas.txt"
  [ -s "$T/st.xml" ] || AVISO_FECHAS=1
  awk -v cntf="$T/x" "$LIB
$PROG_RELS" "$T/wbrels.xml" > "$T/rels.tsv"
  awk -v cntf="$T/x" "$LIB
$PROG_WB" "$T/wb.xml" > "$T/hojas.tsv"
  local D1904=0
  grep -q '^D$' "$T/hojas.tsv" && D1904=1
  local tab
  tab=$(printf '\t')
  grep '^S' "$T/hojas.tsv" > "$T/hojas2.tsv"
  if [ -n "$CSV" ]; then mkdir -p "$CSV" || { echo "No pude crear la carpeta: $CSV"; return; }; fi
  while IFS="$tab" read -r _ nombre rid; do
    if [ -z "$CSV" ]; then emitir_shell "Hoja: $nombre"; fi
    tgt=$(awk -F'\t' -v id="$rid" '$1 == id { print $2; exit }' "$T/rels.tsv")
    if [ -z "$tgt" ]; then
      if [ -n "$CSV" ]; then echo "Hoja \"$nombre\": sin ruta, no se escribio"; else emitir_shell '(hoja sin ruta)'; fi
      continue
    fi
    case "$tgt" in /*) tgt="${tgt#/}" ;; *) tgt="xl/$tgt" ;; esac
    if [ -n "$CSV" ]; then
      limpio=$(printf '%s' "$nombre" | sed 's/[\\/:*?"<>|]/_/g')
      [ -z "$limpio" ] && limpio="hoja"
      destino="$CSV/$limpio.csv"; k=2
      while [ -e "$destino" ]; do destino="$CSV/$limpio-$k.csv"; k=$((k + 1)); done
      printf '\357\273\277' > "$destino"
      if sacar "$tgt" "$T/hoja.xml"; then
        RESTO=999999999
        correr "$PROG_HOJA" "$T/hoja.xml" -v ssf="$T/ss.tsv" -v ff="$T/fechas.txt" -v d1904="$D1904" -v csv=1 >> "$destino"
        echo "Hoja \"$nombre\": $(sed -n 1p "$T/cnt") filas -> $destino"
      else
        echo "Hoja \"$nombre\": no encontre $tgt"
      fi
      continue
    fi
    if sacar "$tgt" "$T/hoja.xml"; then
      local t0=$TOTAL r0=$RESTO filas vistas txt
      correr "$PROG_HOJA" "$T/hoja.xml" -v ssf="$T/ss.tsv" -v ff="$T/fechas.txt" -v d1904="$D1904"
      filas=$((TOTAL - t0)); vistas=$((r0 - RESTO))
      [ "$r0" -lt 0 ] && vistas=0
      txt="$nombre: $filas filas"
      [ "$vistas" -lt "$filas" ] && txt="$txt (aqui solo salen $vistas)"
      if [ -z "$HOJAS" ]; then HOJAS="$txt"; else HOJAS="$HOJAS | $txt"; fi
    else
      emitir_shell "(no encontre $tgt)"
    fi
  done < "$T/hojas2.tsv"
}

# lo leido se guarda primero en un archivo de paso: si corto, el aviso sale arriba
{
  case "$EXT" in
    docx) leer_word ;;
    pptx) leer_ppt ;;
    xlsx) leer_excel ;;
  esac
} > "$T/salida.txt"

MOSTRADOS=$((LIMITE - RESTO))
[ "$RESTO" -lt 0 ] && MOSTRADOS=$LIMITE
FALTAN=$((TOTAL - MOSTRADOS))
COMO="corre otra vez con -Limite $TOTAL"
[ "$EXT" = "xlsx" ] && COMO="$COMO o pasa el Excel a CSV con -Csv entrada/_paso y lee el CSV entero"
if [ "$CORTADO" = "1" ]; then
  echo "[aviso] LECTURA INCOMPLETA: el documento tiene $TOTAL renglones y aqui solo salen los primeros $MOSTRADOS; faltan $FALTAN. No saques conclusiones de este archivo hasta leer el resto: $COMO."
  [ -n "$HOJAS" ] && echo "[aviso] Hojas: $HOJAS"
  echo ""
fi
cat "$T/salida.txt"
if [ "$CORTADO" = "1" ]; then
  echo "[aviso] corte en $LIMITE renglones de $TOTAL; faltan $FALTAN. Para ver todo, $COMO."
fi
if [ "$AVISO_FECHAS" = "1" ]; then
  echo '[aviso] no pude leer los estilos del archivo; las fechas guardadas como numero salen como numero (dias desde 1899-12-30).'
fi
exit 0
