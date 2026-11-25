#!/bin/sh
# Ayudante de la voz: afina conocimiento/dueno/como-hablarle.md con los mensajes nuevos del dueno.
# Lo lanza solo al-recibir.sh, en segundo plano, cuando junta suficientes mensajes. A mano:
#   sh sistema/alarmas/destilar-voz.sh
# Usa la app de Claude de esta compu (la misma cuenta del dueno), sin herramientas: solo lee y contesta.
# Nunca borra lo que el dueno pidio con palabras (las lineas [confirmado ...]). Si algo sale mal,
# deja la nota como estaba, devuelve los mensajes a la fila y lo apunta en sistema/estilo/destilado.log.
# Corre con sh en Mac, Linux y Windows con Git Bash.

dir="$CLAUDE_PROJECT_DIR"
[ -d "$dir/sistema" ] || dir=$(cd "$(dirname "$0")/../.." && pwd)
estilo="$dir/sistema/estilo"
nota="$dir/conocimiento/dueno/como-hablarle.md"
log="$estilo/destilado.log"
cd "$dir" || exit 1
mkdir -p "$estilo/historial"

apunta() { echo "$(date '+%Y-%m-%d %H:%M') · $1" >> "$log"; }

# Un ayudante a la vez. Si uno se quedo colgado mas de 15 minutos, se suelta.
find "$estilo" -maxdepth 1 -name .destilando -mmin +15 -exec rm -rf {} \; 2>/dev/null
mkdir "$estilo/.destilando" 2>/dev/null || exit 0
trap 'rm -rf "$estilo/.destilando"' EXIT

[ -f "$nota" ] || { apunta "no encontre la nota $nota"; exit 1; }
# Si quedo una tanda a medias de una corrida que se cayo, se junta con lo nuevo.
[ -f "$estilo/muestras.jsonl" ] && cat "$estilo/muestras.jsonl" >> "$estilo/en-proceso.jsonl" && rm -f "$estilo/muestras.jsonl"
[ -s "$estilo/en-proceso.jsonl" ] || { rm -f "$estilo/en-proceso.jsonl"; exit 0; }
nuevas=$(wc -l < "$estilo/en-proceso.jsonl" | tr -d ' ')

devuelve() { # algo salio mal: los mensajes regresan a la fila para la siguiente vuelta
  apunta "$1"
  [ -f "$estilo/muestras.jsonl" ] && cat "$estilo/muestras.jsonl" >> "$estilo/en-proceso.jsonl"
  mv "$estilo/en-proceso.jsonl" "$estilo/muestras.jsonl"
  exit "${2:-1}"
}

{ [ -z "$CEREBRO_SIN_CLAUDE" ] && command -v claude > /dev/null 2>&1; } || devuelve "no encontre la app de Claude en esta compu (comando claude): la voz no se afina aqui, pero nada se rompe" 0

tmp=$(mktemp -d 2>/dev/null || echo "$estilo/.tmp-$$")
mkdir -p "$tmp"
trap 'rm -rf "$estilo/.destilando" "$tmp"' EXIT

# Partes de la nota: cabeza (titulo y para que sirve), cuerpo (lo que se aprende) e historia.
awk '/^## /{exit} {print}' "$nota" > "$tmp/cabeza.md"
awk '/^## Historia/{exit} /^## /{p=1} p' "$nota" > "$tmp/cuerpo.md"
awk '/^## Historia/{p=1} p' "$nota" > "$tmp/historia.md"
[ -s "$tmp/historia.md" ] || printf '## Historia\n\nNada todavía.\n' > "$tmp/historia.md"

{
  cat "$dir/sistema/estilo/instrucciones-destilar.md"
  echo
  echo "<nota_actual>"
  cat "$tmp/cuerpo.md"
  echo "</nota_actual>"
  echo
  echo "<mensajes_ya_vistos>"
  [ -f "$estilo/vistas.jsonl" ] && tail -n 30 "$estilo/vistas.jsonl"
  echo "</mensajes_ya_vistos>"
  echo
  echo "<mensajes_nuevos>"
  cat "$estilo/en-proceso.jsonl"
  echo "</mensajes_nuevos>"
  echo
  echo "Hoy es $(date '+%Y-%m-%d'). Devuelve solo la nota nueva, desde «## Trato» hasta el final de «## Lo que no le gusta que le escriban»."
} > "$tmp/encargo.md"

# Corre fuera de la carpeta del cerebro, sin herramientas y sin guardar la sesion:
# asi no carga las reglas ni las alarmas de aqui y no se escucha a si mismo.
( cd "$tmp" && ESTILO_DESTILANDO=1 claude -p --model "${ESTILO_MODELO:-sonnet}" --tools "" \
    --no-session-persistence < "$tmp/encargo.md" > "$tmp/salida.md" 2> "$tmp/error.txt" )
codigo=$?
[ "$codigo" -eq 0 ] || devuelve "la app de Claude fallo (codigo $codigo): $(head -c 300 "$tmp/error.txt" | tr '\n' ' ')"

# Se queda solo desde «## Trato» (por si antepuso algo) y sin cercos de codigo.
awk '/^## Trato/{p=1} p' "$tmp/salida.md" | grep -v '^```' > "$tmp/nuevo.md"

# Revisiones antes de tocar la nota.
for t in "## Trato" "## Cómo llamarle" "## Cómo escribe él" "## Cómo piensa y explica" "## Qué tan largas quiere las respuestas" "## Muestras cortas de cómo escribe" "## Lo que no le gusta que le escriban"; do
  grep -q "^$t" "$tmp/nuevo.md" || devuelve "la nota nueva no traía la parte «$t»; no la toqué"
done
grep -F '[confirmado' "$tmp/cuerpo.md" > "$tmp/confirmadas.txt"
while IFS= read -r linea; do
  [ -z "$linea" ] && continue
  grep -F -x -q -- "$linea" "$tmp/nuevo.md" || devuelve "la nota nueva quitaba o cambiaba algo que el dueño pidió con palabras; no la toqué"
done < "$tmp/confirmadas.txt"
grep -q '^## Historia' "$tmp/nuevo.md" && devuelve "la nota nueva traía su propia historia; no la toqué"

# Copia de la nota de antes (se guardan las últimas 10) y nota nueva.
cp "$nota" "$estilo/historial/como-hablarle-$(date '+%Y-%m-%d-%H%M%S').md"
ls -1 "$estilo/historial"/como-hablarle-*.md 2>/dev/null | sort -r | tail -n +11 | while IFS= read -r v; do rm -f "$v"; done

{
  cat "$tmp/cabeza.md"
  cat "$tmp/nuevo.md"
  echo
  sed '/^Nada todavía\.$/d' "$tmp/historia.md"
  echo "- $(date '+%Y-%m-%d'): se afinó sola con $nuevas mensajes nuevos suyos."
} | awk 'NF{b=0; print; next} !b{print; b=1}' > "$tmp/nota-final.md"
cp "$tmp/nota-final.md" "$nota"
touch "$estilo/.ultimo-destilado"

# Los mensajes pasan a «ya vistos» (solo los últimos 60).
cat "$estilo/en-proceso.jsonl" >> "$estilo/vistas.jsonl"
rm -f "$estilo/en-proceso.jsonl"
tail -n 60 "$estilo/vistas.jsonl" > "$tmp/vistas.jsonl" && cp "$tmp/vistas.jsonl" "$estilo/vistas.jsonl"
apunta "afiné la voz con $nuevas mensajes nuevos"
exit 0
