#!/bin/sh
# Alarma antes de escribir (Claude Code, PreToolUse de Write, Edit, MultiEdit y NotebookEdit).
# Frena dos cosas: escribir fuera de la carpeta del cerebro y escribir claves o numeros sensibles
# (tarjetas, CLABE, CURP, RFC de persona, contrasenas, llaves de programas). AGENTS.md, punto 5.
# Corre con sh en Mac, Linux y Windows con Git Bash. No necesita instalar nada.
# Sale con 2 (frena) y explica por que; con 0 deja pasar.

entrada=$(cat)

normaliza() {
  printf '%s' "$1" | sed 's#\\\\#/#g; s#\\#/#g; s#//*#/#g' | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz' | sed 's#^/\([a-z]\)/#\1:/#; s#/$##'
}

frena() {
  echo "Alarma del cerebro: $1" >&2
  exit 2
}

# 1. Que no escriba fuera del cerebro.
dir=$(normaliza "${CLAUDE_PROJECT_DIR:-$(pwd)}")
ruta=$(printf '%s' "$entrada" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
if [ -z "$ruta" ]; then
  ruta=$(printf '%s' "$entrada" | sed -n 's/.*"notebook_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
fi
if [ -n "$ruta" ]; then
  r=$(normaliza "$ruta")
  case "$r" in
    */../*|../*|*/..) frena "la ruta $ruta sube de carpeta. Escribe solo dentro del cerebro; lo de paso va en entrada/_paso/ (AGENTS.md, punto 5)." ;;
  esac
  case "$r" in
    /*|[a-z]:/*)
      case "$r" in
        "$dir"|"$dir"/*) ;;
        */.claude/plans/*) ;;
        *) frena "no se escribe fuera de la carpeta del cerebro ($ruta). Lo de paso va en entrada/_paso/ y se borra al terminar; lo que sirve, a fuentes/ (AGENTS.md, punto 5). No uses la carpeta temporal del sistema." ;;
      esac ;;
  esac
fi

# 2. Que no escriba claves ni numeros sensibles. Solo revisa el texto nuevo, no el que se quita.
hallazgo=$(printf '%s\n' "$entrada" | awk '
function luhn(n,   i, d, s, par) {
  s = 0; par = 0
  for (i = length(n); i >= 1; i--) {
    d = substr(n, i, 1) + 0
    if (par) { d = d * 2; if (d > 9) d = d - 9 }
    s += d; par = !par
  }
  return (s % 10 == 0)
}
function clabe(n,   i, w, s, c) {
  s = 0
  for (i = 1; i <= 17; i++) {
    w = (i % 3 == 1) ? 3 : ((i % 3 == 2) ? 7 : 1)
    s += (substr(n, i, 1) * w) % 10
  }
  c = (10 - (s % 10)) % 10
  return (c == substr(n, 18, 1) + 0)
}
function revisa(t,   s, m, n, v, low) {
  # tarjetas en grupos de cuatro: 1234 5678 9012 3456
  s = t
  while (match(s, /[0-9][0-9][0-9][0-9][ -][0-9][0-9][0-9][0-9][ -][0-9][0-9][0-9][0-9][ -][0-9][0-9][0-9][0-9]/)) {
    m = substr(s, RSTART, RLENGTH); gsub(/[ -]/, "", m)
    if (luhn(m)) return "un numero de tarjeta"
    s = substr(s, RSTART + RLENGTH)
  }
  # numeros seguidos: tarjeta de 15 o 16 digitos, o CLABE de 18
  s = t
  while (match(s, /[0-9]+/)) {
    m = substr(s, RSTART, RLENGTH); n = length(m)
    if ((n == 15 || n == 16) && substr(m, 1, 1) ~ /[3456]/ && luhn(m)) return "un numero de tarjeta"
    if (n == 18 && clabe(m)) return "una CLABE"
    s = substr(s, RSTART + RLENGTH)
  }
  # CURP
  if (match(t, /[A-Z][AEIOUX][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HMX][A-Z][A-Z][A-Z][A-Z][A-Z][0-9A-Z][0-9]/)) return "una CURP"
  # RFC de persona (cuatro letras); el de empresa (tres letras) si se puede escribir
  s = " " t " "
  if (match(s, /[^A-Za-z0-9&][A-Z&][A-Z&][A-Z&][A-Z&][0-9][0-9][0-9][0-9][0-9][0-9][A-Z0-9][A-Z0-9][A-Z0-9][^A-Za-z0-9]/)) return "un RFC de persona"
  # llaves de programas
  if (match(t, /(ops_|sk-|sk_live_|rk_live_|ghp_|gho_|github_pat_|AKIA|AIza|xoxb-|xoxp-)[A-Za-z0-9_-]+/) && RLENGTH >= 20) return "una llave de programa"
  # contrasena: valor de seis o mas, con algun numero
  low = tolower(t)
  s = low
  while (match(s, /(contrase[^ :=]*|password|passwd|clave|nip|pin|token)[ ]*[:=][ ]*[^ ]+/)) {
    m = substr(s, RSTART, RLENGTH)
    v = m; sub(/^[^:=]*[:=][ ]*/, "", v)
    if (substr(v, 1, 5) != "op://" && length(v) >= 6 && v ~ /[0-9]/) return "una contrasena o clave"
    s = substr(s, RSTART + RLENGTH)
  }
  return ""
}
{
  s = $0
  while (match(s, /"(content|new_string|new_source)"[ \t]*:[ \t]*"/)) {
    s = substr(s, RSTART + RLENGTH)
    i = 1; n = length(s)
    while (i <= n) {
      c = substr(s, i, 1)
      if (c == "\\") { i += 2; continue }
      if (c == "\"") break
      i++
    }
    t = substr(s, 1, i - 1)
    gsub(/\\[nrt]/, " ", t)
    r = revisa(t)
    if (r != "") { print r; exit }
    s = substr(s, i + 1)
  }
}')

if [ -n "$hallazgo" ]; then
  frena "lo que ibas a escribir trae $hallazgo. Claves, tarjetas, cuentas e identificaciones no se copian a ningun archivo (AGENTS.md, punto 5). Quita el numero y apunta solo que existe y donde vive, en conocimiento/operacion/accesos.md si es una clave."
fi

exit 0
