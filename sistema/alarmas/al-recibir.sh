#!/bin/sh
# Alarma al recibir un mensaje del dueno (Claude Code, UserPromptSubmit).
# 1. Deja una marca con la hora, para que la alarma de al terminar sepa que cambio en este turno.
# 2. Guarda el mensaje tal cual lo escribio (tapando numeros y llaves) en sistema/estilo/muestras.jsonl.
# 3. Cuando junta suficientes mensajes nuevos, lanza en segundo plano destilar-voz.sh, que afina
#    conocimiento/dueno/como-hablarle.md sin que el asistente tenga que acordarse.
# 4. Si es el primer mensaje de la sesion, o la voz se afino desde el ultimo aviso, le pasa al
#    asistente la voz vigente para que conteste ya asi.
# Corre con sh en Mac, Linux y Windows con Git Bash. No necesita instalar nada.

entrada=$(cat)
dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
touch "$dir/sistema/alarmas/.ultima-orden" 2>/dev/null

# El ayudante que destila corre su propia sesion: no se escucha a si mismo.
[ -n "$ESTILO_DESTILANDO" ] && exit 0

estilo="$dir/sistema/estilo"
nota="$dir/conocimiento/dueno/como-hablarle.md"
mkdir -p "$estilo" 2>/dev/null || exit 0

# --- 2. Guardar la muestra ---
texto=$(printf '%s' "$entrada" | tr -d '\r\n' | sed -n -E 's/.*"prompt"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p')
case "$texto" in
  ""|/*|"<"*) ;;  # vacio, comandos con diagonal y avisos de la app: no son su forma de hablar
  *)
    tapado=$(printf '%s' "$texto" | sed -E \
      -e 's/[0-9][0-9 -]{11,}[0-9]/[numero tapado]/g' \
      -e 's/(sk|pk|ghp|gho|xox[abp])[-_][A-Za-z0-9_-]{8,}/[llave tapada]/g' \
      -e 's/[A-Za-z0-9_+=-]{28,}/[llave tapada]/g')
    printf '{"fecha":"%s","texto":"%s"}\n' "$(date '+%Y-%m-%d %H:%M')" "$tapado" >> "$estilo/muestras.jsonl"
    ;;
esac

# --- 3. Destilar cuando toca ---
# Hasta estilo_aprende_hasta (sistema/estado.md) afina cada 6 mensajes; despues, cada 25.
cada=6
hasta=$(sed -n 's/^- estilo_aprende_hasta:[[:space:]]*\([0-9-]*\).*/\1/p' "$dir/sistema/estado.md" 2>/dev/null | head -n 1)
hoy=$(date '+%Y-%m-%d')
if [ -n "$hasta" ] && [ "$hoy" \> "$hasta" ]; then cada=25; fi
[ -n "$ESTILO_CADA" ] && cada="$ESTILO_CADA"
juntas=$(cat "$estilo/muestras.jsonl" 2>/dev/null | wc -l | tr -d ' ')
[ -z "$juntas" ] && juntas=0
if [ "$juntas" -ge "$cada" ] && [ ! -d "$estilo/.destilando" ] && [ -z "$ESTILO_SIN_DESTILAR" ]; then
  ( CLAUDE_PROJECT_DIR="$dir" nohup sh "$dir/sistema/alarmas/destilar-voz.sh" > /dev/null 2>&1 < /dev/null & ) > /dev/null 2>&1
fi

# --- 4. Pasarle la voz vigente al asistente ---
[ -f "$nota" ] || exit 0
sesion=$(printf '%s' "$entrada" | tr -d '\r\n' | sed -n -E 's/.*"session_id"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p' | tr -cd 'A-Za-z0-9-' | cut -c1-60)
[ -z "$sesion" ] && sesion=sin-sesion
aviso="$estilo/.avisada-$sesion"
find "$estilo" -name '.avisada-*' -mtime +7 -exec rm -f {} \; 2>/dev/null
if [ ! -f "$aviso" ] || [ "$nota" -nt "$aviso" ]; then
  if [ -f "$aviso" ]; then
    echo "La voz del dueno se afino mientras platicaban. Desde este mensaje contestale asi (conocimiento/dueno/como-hablarle.md, vigente):"
  else
    echo "Voz del dueno para esta sesion. Contestale asi desde el primer mensaje (conocimiento/dueno/como-hablarle.md, vigente):"
  fi
  # Solo lo que sirve para hablarle; la historia y las instrucciones de arriba no.
  awk '/^## (Trato|Cómo llamarle|Cómo escribe él|Cómo piensa y explica|Qué tan largas quiere las respuestas|Muestras cortas de cómo escribe|Lo que no le gusta que le escriban)/{p=1; print; next} /^## /{p=0} p' "$nota"
  echo "Copia su forma (palabras, largo, como une las ideas, como explica), no sus faltas de ortografia. En codigo, notas y mensajes a sus clientes no aplica. A sub-agentes, normal y tecnico."
  touch "$aviso"
else
  # En los demas mensajes, solo el largo y el trato: es lo que primero se le olvida al asistente.
  largo=$(awk '/^## Qué tan largas quiere las respuestas/{p=1; next} /^## /{p=0} p && NF' "$nota" | head -n 1)
  trato=$(awk '/^## Trato/{p=1; next} /^## /{p=0} p && NF' "$nota" | head -n 1)
  case "$largo" in ""|pendiente*) largo="" ;; esac
  case "$trato" in ""|pendiente*) trato="" ;; esac
  if [ -n "$largo$trato" ]; then
    echo "Al contestarle al dueno, cumple:${trato:+ trato: $trato}${largo:+ largo: $largo}"
  fi
fi
exit 0
