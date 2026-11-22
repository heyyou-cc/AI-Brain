#!/bin/sh
# Alarma al terminar (Claude Code, Stop). Antes de que el asistente dé su turno por terminado revisa:
# 1. que no queden archivos de paso en entrada/_paso/ (AGENTS.md, punto 5);
# 2. que, si cambió algo del cerebro en este turno, su respuesta traiga la línea «Guardé:» (AGENTS.md, punto 3).
# Si algo falta, lo frena una sola vez y le dice qué arreglar; la segunda vez lo deja ir.
# Corre con sh en Mac, Linux y Windows con Git Bash. No necesita instalar nada.

entrada=$(cat)

case "$entrada" in
  *'"stop_hook_active":true'*|*'"stop_hook_active": true'*) exit 0 ;;
esac

dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$dir" 2>/dev/null || exit 0

quejas=""

# 1. Archivos de paso
if [ -d entrada/_paso ] && [ -n "$(ls -A entrada/_paso 2>/dev/null)" ]; then
  quejas="$quejas Quedaron archivos en entrada/_paso/: bórralos o pasa lo que sirve a fuentes/ (AGENTS.md, punto 5); si todavía los usas en lo que sigue, dilo en una línea y déjalos."
fi

# 2. La línea «Guardé:»
marca=sistema/alarmas/.ultima-orden
if [ -f "$marca" ]; then
  # Lo que afina solo el ayudante de la voz (destilar-voz.sh) no cuenta: el asistente no lo tocó.
  cambiados=$(find conocimiento sistema empleados trabajo fuentes -type f -newer "$marca" 2>/dev/null | grep -v -e '^sistema/alarmas/' -e '^sistema/estilo/')
  if [ -f sistema/estilo/.ultimo-destilado ] && [ ! conocimiento/dueno/como-hablarle.md -nt sistema/estilo/.ultimo-destilado ]; then
    cambiados=$(printf '%s\n' "$cambiados" | grep -v '^conocimiento/dueno/como-hablarle.md$')
  fi
  cambiados=$(printf '%s\n' "$cambiados" | grep -v '^$' | head -n 3)
  if [ -n "$cambiados" ]; then
    ultimo=$(printf '%s\n' "$entrada" | awk '{
      s = $0
      if (match(s, /"last_assistant_message"[ \t]*:[ \t]*"/)) {
        s = substr(s, RSTART + RLENGTH); i = 1; n = length(s)
        while (i <= n) { c = substr(s, i, 1); if (c == "\\") { i += 2; continue }; if (c == "\"") break; i++ }
        print substr(s, 1, i - 1)
      }
    }')
    if [ -z "$ultimo" ]; then
      transcrito=$(printf '%s' "$entrada" | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1 | sed 's#\\\\#/#g')
      if [ -n "$transcrito" ] && [ -f "$transcrito" ]; then
        ultimo=$(tail -n 400 "$transcrito" | grep '"role":"assistant"' | grep '"type":"text"' | tail -n 1)
      fi
    fi
    if [ -n "$ultimo" ]; then
      case "$ultimo" in
        *Guard*) ;;
        *)
          lista=$(printf '%s' "$cambiados" | tr '\n' ' ')
          quejas="$quejas En este turno cambiaste $lista y tu respuesta no termina con la línea «Guardé: <qué> → <ruta>» (AGENTS.md, punto 3). Agrégala, en palabras del negocio."
          ;;
      esac
    fi
  fi
fi

if [ -n "$quejas" ]; then
  echo "Alarma del cerebro:$quejas" >&2
  exit 2
fi
exit 0
