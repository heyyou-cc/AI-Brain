#!/bin/sh
# Lector común de las alarmas. No se corre solo: cada alarma lo incluye con
#   . "$(dirname "$0")/_leer-evento.sh"; ev_leer
# Entiende lo que mandan los tres asistentes y lo deja en las mismas variables:
#   Claude Code  {"tool_name":"Write","tool_input":{"file_path":...,"content":...}}
#   Codex        igual, con "Bash" para la consola y "apply_patch" (el parche viene en tool_input.command)
#   Copilot      {"toolName":"edit","toolArgs":"{\"path\":...}"}  (toolArgs es un texto con JSON adentro)
#                o, con eventos en PascalCase, el mismo formato que Claude.
# Variables que deja:
#   EV_RAIZ         carpeta del cerebro (CLAUDE_PROJECT_DIR si sirve; si no, donde vive este script)
#   EV_JSON         el evento en una sola línea, con toolArgs ya abierto como tool_input
#   EV_AGENTE       claude, codex o copilot (CEREBRO_AGENTE manda; si no, se adivina)
#   EV_HERRAMIENTA  nombre de la herramienta, tal cual
#   EV_ESCRIBE      "1" si la herramienta escribe archivos
#   EV_RUTAS        rutas que va a escribir, una por renglón
#   EV_COMANDO      comando de consola (vacío en escrituras)
#   EV_PARA_REVISAR el JSON donde se buscan claves y números (para apply_patch, solo las líneas nuevas)
# Funciones: ev_cadena <clave> [<clave>...]  texto JSON (sin desescapar) de la primera clave que exista;
#            ev_pregunta <motivo>            pide permiso al dueño (o frena si el asistente no sabe preguntar).
# Solo POSIX: corre con el sh de Mac (bash 3.2), de Linux y de Git para Windows. Sin jq, sin GNU.

ev_raiz() {
  EV_RAIZ=""
  if [ -n "$CLAUDE_PROJECT_DIR" ] && [ -d "$CLAUDE_PROJECT_DIR/sistema" ]; then
    EV_RAIZ="$CLAUDE_PROJECT_DIR"
  else
    EV_RAIZ=$(cd "$(dirname "$0")/../.." 2>/dev/null && pwd)
  fi
  [ -z "$EV_RAIZ" ] && EV_RAIZ=$(pwd)
}

ev_cadena() {
  for _k in "$@"; do
    _v=$(printf '%s\n' "$EV_JSON" | awk -v k="$_k" '{
      s = $0
      if (match(s, "\"" k "\"[ \t]*:[ \t]*\"")) {
        s = substr(s, RSTART + RLENGTH); i = 1; n = length(s)
        while (i <= n) { c = substr(s, i, 1); if (c == "\\") { i += 2; continue }; if (c == "\"") break; i++ }
        print substr(s, 1, i - 1); found = 1; exit
      }
    } END { if (!found) exit 1 }') && { printf '%s' "$_v"; return 0; }
  done
  return 1
}

ev_leer() {
  ev_raiz
  _crudo=""
  [ -t 0 ] || _crudo=$(cat)
  # Una sola línea, sin la marca BOM que PowerShell 5.1 pone al principio.
  EV_JSON=$(printf '%s' "$_crudo" | tr -d '\r\n' | awk '{ sub(/^\357\273\277/, ""); print }')
  # Copilot: toolArgs viene como texto con JSON adentro; se abre como tool_input.
  EV_JSON=$(printf '%s\n' "$EV_JSON" | awk '{
    s = $0
    if (match(s, /"toolArgs"[ \t]*:[ \t]*"/)) {
      antes = substr(s, 1, RSTART - 1); r = substr(s, RSTART + RLENGTH)
      i = 1; n = length(r)
      while (i <= n) { c = substr(r, i, 1); if (c == "\\") { i += 2; continue }; if (c == "\"") break; i++ }
      args = substr(r, 1, i - 1); resto = substr(r, i + 1)
      out = ""; j = 1; m = length(args)
      while (j <= m) {
        c = substr(args, j, 1)
        if (c == "\\" && j < m) {
          d = substr(args, j + 1, 1)
          if (d == "\"" || d == "\\" || d == "/") { out = out d; j += 2; continue }
        }
        out = out c; j++
      }
      if (out == "") out = "{}"
      print antes "\"tool_input\":" out resto
    } else print s
  }')
  EV_HERRAMIENTA=$(ev_cadena tool_name toolName)
  EV_COMANDO=""
  EV_RUTAS=""
  EV_PARA_REVISAR="$EV_JSON"

  # ¿Quién manda el evento?
  EV_AGENTE="$CEREBRO_AGENTE"
  if [ -z "$EV_AGENTE" ]; then
    case "$EV_JSON" in
      *'"toolName"'*|*'"sessionId"'*) EV_AGENTE=copilot ;;
      *'"turn_id"'*) EV_AGENTE=codex ;;
      *) EV_AGENTE=claude ;;
    esac
  fi

  # ¿Escribe archivos?
  _n=$(printf '%s' "$EV_HERRAMIENTA" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz')
  EV_ESCRIBE=""
  case "$_n" in
    "") ;;
    *write*|*edit*|*patch*|*replace*|create|create_file|insert|str_replace*) EV_ESCRIBE=1 ;;
  esac
  [ -z "$_n" ] && [ -n "$(ev_cadena file_path notebook_path)" ] && EV_ESCRIBE=1

  if [ "$_n" = apply_patch ]; then
    # Codex manda el parche entero en tool_input.command: las rutas salen de las líneas «*** Add File: ruta».
    _parche=$(ev_cadena command)
    EV_RUTAS=$(printf '%s\n' "$_parche" | awk '{
      n = split($0, L, /\\n/)
      for (i = 1; i <= n; i++) if (match(L[i], /^\*\*\* (Add|Update|Delete) File: /)) { print substr(L[i], RSTART + RLENGTH) }
      for (i = 1; i <= n; i++) if (match(L[i], /^\*\*\* Move to: /)) { print substr(L[i], RSTART + RLENGTH) }
    }')
    _nuevas=$(printf '%s\n' "$_parche" | awk '{
      n = split($0, L, /\\n/); out = ""
      for (i = 1; i <= n; i++) if (substr(L[i], 1, 1) == "+" && substr(L[i], 1, 3) != "+++") out = out " " substr(L[i], 2)
      printf "%s", out
    }')
    EV_PARA_REVISAR="{\"tool_input\":{\"content\":\"$_nuevas\"}}"
  else
    _r=$(ev_cadena file_path notebook_path filePath path)
    [ -n "$EV_ESCRIBE" ] && [ -n "$_r" ] && EV_RUTAS="$_r"
    EV_COMANDO=$(ev_cadena command)
  fi
}

# Pide permiso al dueño. Claude y Copilot saben preguntar (permissionDecision "ask"); Codex no
# (su documentación lo marca no soportado), así que ahí se frena con un mensaje para el asistente.
ev_pregunta() {
  if [ "$EV_AGENTE" = codex ]; then
    echo "Alarma del cerebro: $1 Pídele permiso al dueño en el chat; si dice que sí, que él te pegue el contenido o abra el archivo." >&2
    exit 2
  fi
  _m=$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')
  case "$EV_JSON" in
    *'"toolName"'*) printf '{"permissionDecision":"ask","permissionDecisionReason":"%s"}\n' "$_m" ;;
    *) printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$_m" ;;
  esac
  exit 0
}
