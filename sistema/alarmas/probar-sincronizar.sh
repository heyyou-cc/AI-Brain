#!/bin/sh
# Prueba la alarma de sincronizar sin tocar nada del dueño ni de internet.
# Uso, desde la carpeta del cerebro:  sh sistema/alarmas/probar-sincronizar.sh
# Arma en la carpeta temporal del sistema (fuera del cerebro) un repositorio de prueba con dos copias,
# como dos compus, y lo borra al final. Debe decir «TODAS BIEN».

cd "$(dirname "$0")/../.." || exit 1
base=$(pwd)
s="$base/sistema/alarmas/sincronizar.sh"
bien=0
mal=0
espera() { # nombre, esperado, real
  if [ "$2" = "$3" ]; then bien=$((bien + 1)); echo "ok    · $1"
  else mal=$((mal + 1)); echo "FALLA · $1 (esperaba $2, salió $3)"; fi
}
si() { if "$@" > /dev/null 2>&1; then echo si; else echo no; fi; }

t=$(mktemp -d 2>/dev/null || echo "/tmp/probar-sincronizar-$$")
mkdir -p "$t"
trap 'rm -rf "$t"' EXIT
unset CEREBRO_SINCRONIZAR
export SINCRONIZAR_ESPERA=2
# Así escribe git la ruta del remoto (en Windows, C:/...); la guarda compara contra eso.
w=$( (cd "$t" && pwd -W) 2>/dev/null || echo "$t")
quien="-c user.name=Prueba -c user.email=prueba@ejemplo"

# Un remoto y la primera versión del cerebro
git init -q --bare "$t/remoto.git"
git --git-dir="$t/remoto.git" symbolic-ref HEAD refs/heads/main
git -c init.defaultBranch=main init -q "$t/semilla"
cd "$t/semilla" || exit 1
mkdir -p sistema/alarmas conocimiento
cp "$base/.gitattributes" .
printf 'sistema/alarmas/sincronizar.log\nsistema/alarmas/.traidos\n' > .gitignore
printf '# comentario\nremoto_permitido=%s\n' "$w/remoto.git" > sistema/sincronizar.conf
printf '# Precios\n\n- Corte: 150\n\n## Historia\n\n' > conocimiento/precios.md
printf '# Estado\n\n- fase_arranque: aviso\n' > sistema/estado.md
printf '# Bitácora\n\n## Líneas\n\n' > sistema/bitacora.md
printf 'producto,precio\ncorte,150\n' > conocimiento/lista.csv
git add -A && git $quien commit -q -m inicio && git branch -M main && git push -q "$t/remoto.git" main
cd "$t" || exit 1
git clone -q "$t/remoto.git" a
git clone -q "$t/remoto.git" b
for c in a b; do git -C "$t/$c" config user.name "Prueba $c"; git -C "$t/$c" config user.email "$c@ejemplo"; done
sincroniza() { # copia, modo, [ya], [json de entrada]
  e="$4"; [ -z "$e" ] && e='{}'
  printf '%s' "$e" | CLAUDE_PROJECT_DIR="$t/$1" sh "$s" "$2" $3
}

echo "Libreta de solo agregar (bitácora) editada en las dos compus:"
printf -- '- 2026-11-23 · Tinte: 400\n' >> "$t/a/sistema/bitacora.md"
printf -- '- 2026-11-23 · Peinado: 250\n' >> "$t/b/sistema/bitacora.md"
mkdir -p "$t/a/sistema/alarmas"; touch "$t/a/sistema/alarmas/.ultima-orden"; sleep 1
sincroniza a subir ya > /dev/null
sl=$(sincroniza b subir ya '{"hook_event_name":"Stop","stop_hook_active":false}')
sincroniza a bajar > /dev/null
for c in a b; do
  espera "$c tiene la línea de a" si "$(si grep -q 'Tinte: 400' "$t/$c/sistema/bitacora.md")"
  espera "$c tiene la línea de b" si "$(si grep -q 'Peinado: 250' "$t/$c/sistema/bitacora.md")"
  espera "$c sin marcas de choque" no "$(si grep -q '^<<<<<<<' "$t/$c/sistema/bitacora.md")"
  espera "$c sin nada pendiente" "" "$(git -C "$t/$c" status --porcelain)"
done
espera "la libreta no deja copia .remoto ni aviso" "" "$sl$(ls "$t/b/sistema" | grep remoto)"
espera "las dos compus quedaron iguales" "$(git -C "$t/a" rev-parse HEAD)" "$(git -C "$t/b" rev-parse HEAD)"
espera "lo que llegó de la otra compu queda apuntado para al-terminar" si "$(si grep -qx 'sistema/bitacora.md' "$t/a/sistema/alarmas/.traidos")"
fin=$(printf %s '{"stop_hook_active":false,"last_assistant_message":"Listo."}' | CLAUDE_PROJECT_DIR="$t/a" sh "$base/sistema/alarmas/al-terminar.sh" 2>&1; echo " $?")
espera "al-terminar no pide «Guardé:» por lo que llegó de la otra compu" " 0" "$fin"

echo "Nota normal y estado, en choque (no se juntan renglones a ciegas):"
sed 's/Corte: 150/Corte: 180/' "$t/a/conocimiento/precios.md" > "$t/x" && mv "$t/x" "$t/a/conocimiento/precios.md"
sed 's/Corte: 150/Corte: 200/' "$t/b/conocimiento/precios.md" > "$t/x" && mv "$t/x" "$t/b/conocimiento/precios.md"
sed 's/fase_arranque: aviso/fase_arranque: inventario/' "$t/a/sistema/estado.md" > "$t/x" && mv "$t/x" "$t/a/sistema/estado.md"
sed 's/fase_arranque: aviso/fase_arranque: lectura/' "$t/b/sistema/estado.md" > "$t/x" && mv "$t/x" "$t/b/sistema/estado.md"
sincroniza a subir ya > /dev/null
sn=$(sincroniza b subir ya '{"hook_event_name":"Stop","stop_hook_active":false}')
espera "b se queda con su nota" si "$(si grep -q 'Corte: 200' "$t/b/conocimiento/precios.md")"
espera "la nota no trae el dato dos veces" 1 "$(grep -c 'Corte:' "$t/b/conocimiento/precios.md")"
espera "la de a queda al lado como precios.remoto.md" si "$(si grep -q 'Corte: 180' "$t/b/conocimiento/precios.remoto.md")"
espera "el estado tiene una sola fase_arranque" 1 "$(grep -c 'fase_arranque:' "$t/b/sistema/estado.md")"
espera "b sin nada pendiente" "" "$(git -C "$t/b" status --porcelain)"
espera "al terminar, frena y le pide juntarlas" si "$(case "$sn" in *'"decision":"block"'*precios.remoto.md*estado.remoto.md*) echo si;; *) echo no;; esac)"
espera "el aviso pide conservar los dos lados y la «Historia»" si "$(case "$sn" in *"sin perder nada de ninguno"*"Historia"*) echo si;; *) echo no;; esac)"
echo "  Aviso que recibe el asistente en el Stop:"; echo "  $sn"
sincroniza a bajar > /dev/null
espera "a recibe la copia .remoto de la nota" si "$([ -f "$t/a/conocimiento/precios.remoto.md" ] && echo si || echo no)"

echo "Archivo que no es nota, en choque:"
sed 's/corte,150/corte,180/' "$t/a/conocimiento/lista.csv" > "$t/x" && mv "$t/x" "$t/a/conocimiento/lista.csv"
sed 's/corte,150/corte,200/' "$t/b/conocimiento/lista.csv" > "$t/x" && mv "$t/x" "$t/b/conocimiento/lista.csv"
sincroniza a subir ya > /dev/null
salida=$(sincroniza b subir ya '{"hook_event_name":"Stop","stop_hook_active":false}')
espera "b se queda con su versión" si "$(si grep -q 'corte,200' "$t/b/conocimiento/lista.csv")"
espera "la de a queda al lado como lista.remoto.csv" si "$(si grep -q 'corte,180' "$t/b/conocimiento/lista.remoto.csv")"
espera "b sin merge a medias" no "$([ -f "$t/b/.git/MERGE_HEAD" ] && echo si || echo no)"
espera "b sin nada pendiente" "" "$(git -C "$t/b" status --porcelain)"
espera "b subió el merge" "$(git -C "$t/b" rev-parse HEAD)" "$(git -C "$t/remoto.git" rev-parse main)"
espera "al terminar, frena y le pide juntarlos" si "$(case "$salida" in *'"decision":"block"'*lista.remoto.csv*) echo si;; *) echo no;; esac)"
echo "  Aviso que recibe el asistente en el Stop:"; echo "  $salida"
sincroniza a bajar > /dev/null
espera "a recibe la copia .remoto" si "$([ -f "$t/a/conocimiento/lista.remoto.csv" ] && echo si || echo no)"
espera "el aviso no se repite" "" "$(sincroniza b bajar)"

echo "Choque visto en una edición (PostToolUse) y en un mensaje (UserPromptSubmit):"
printf 'x,1\n' > "$t/a/conocimiento/otra.csv"; printf 'x,2\n' > "$t/b/conocimiento/otra.csv"
sincroniza a subir ya > /dev/null
sp=$(sincroniza b subir ya '{"hook_event_name":"PostToolUse"}')
espera "PostToolUse: aviso como additionalContext" si "$(case "$sp" in *additionalContext*otra.remoto.csv*) echo si;; *) echo no;; esac)"
sincroniza a bajar > /dev/null
printf 'y,1\n' > "$t/a/conocimiento/tres.csv"; printf 'y,2\n' > "$t/b/conocimiento/tres.csv"
sincroniza a subir ya > /dev/null
su=$(sincroniza b bajar '' '{"hook_event_name":"UserPromptSubmit","session_id":"s1"}')
espera "UserPromptSubmit: aviso en texto" si "$(case "$su" in "Sincronización del cerebro: al juntar"*tres.remoto.csv*) echo si;; *) echo no;; esac)"
echo "  Aviso que recibe el asistente en un mensaje:"; printf '%s\n' "$su" | sed 's/^/  /'
espera "bajar no sube (el remoto no tiene el merge de b)" no "$([ "$(git -C "$t/b" rev-parse HEAD)" = "$(git -C "$t/remoto.git" rev-parse main)" ] && echo si || echo no)"
sincroniza b subir ya > /dev/null
espera "el siguiente subir lo sube" si "$([ "$(git -C "$t/b" rev-parse HEAD)" = "$(git -C "$t/remoto.git" rev-parse main)" ] && echo si || echo no)"

echo "Subida rechazada una vez (el remoto la frena como cuando avanzó):"
printf -- '- Cejas: 90\n' >> "$t/a/sistema/bitacora.md"; sincroniza a subir ya > /dev/null
printf -- '- Uñas: 300\n' >> "$t/b/sistema/bitacora.md"
touch "$t/rechaza-una"
printf '#!/bin/sh\nif [ -f "%s" ]; then rm -f "%s"; echo rejected >&2; exit 1; fi\nexit 0\n' "$t/rechaza-una" "$t/rechaza-una" > "$t/remoto.git/hooks/pre-receive"
chmod +x "$t/remoto.git/hooks/pre-receive"
sincroniza b subir ya > /dev/null
espera "el remoto sí la rechazó la primera vez" no "$([ -f "$t/rechaza-una" ] && echo si || echo no)"
espera "b reintenta y sube" "$(git -C "$t/b" rev-parse HEAD)" "$(git -C "$t/remoto.git" rev-parse main)"
espera "y conserva lo de los dos" si "$(grep -q "Cejas: 90" "$t/b/sistema/bitacora.md" && grep -q "Uñas: 300" "$t/b/sistema/bitacora.md" && echo si || echo no)"
rm -f "$t/remoto.git/hooks/pre-receive"

echo "Ediciones seguidas (debounce):"
rm -f "$t/b/.git/sincronizar.ultimo"
printf 'a\n' > "$t/b/conocimiento/n1.md"; sincroniza b subir '' '{"hook_event_name":"PostToolUse"}' > /dev/null
antes=$(git -C "$t/b" rev-parse HEAD)
printf 'b\n' > "$t/b/conocimiento/n2.md"; sincroniza b subir '' '{"hook_event_name":"PostToolUse"}' > /dev/null
espera "segunda edición seguida: no hace commit" "$antes" "$(git -C "$t/b" rev-parse HEAD)"
espera "pero queda pendiente" si "$([ -f "$t/b/.git/sincronizar.pendiente" ] && echo si || echo no)"
sincroniza b subir '' '{"hook_event_name":"Stop","stop_hook_active":false}' > /dev/null
espera "el Stop sube lo pendiente" "" "$(git -C "$t/b" status --porcelain)"
espera "y ya no queda pendiente" no "$([ -f "$t/b/.git/sincronizar.pendiente" ] && echo si || echo no)"

echo "Candado:"
mkdir "$t/b/.git/sincronizar.lock"
printf 'c\n' > "$t/b/conocimiento/n3.md"
sincroniza b subir ya > /dev/null
espera "candado tomado: sale sin tocar" si "$(git -C "$t/b" status --porcelain | grep -q n3 && echo si || echo no)"
touch -t 202001010000 "$t/b/.git/sincronizar.lock"
sincroniza b subir ya > /dev/null
espera "candado huérfano: lo suelta y sincroniza" "" "$(git -C "$t/b" status --porcelain)"
espera "y no deja el candado" no "$([ -d "$t/b/.git/sincronizar.lock" ] && echo si || echo no)"

echo "Archivo demasiado grande (la prueba baja el tope a 10 KB):"
awk 'BEGIN { for (i = 0; i < 400; i++) print "renglón de relleno para pasar del tope de la prueba" }' > "$t/b/conocimiento/video grande.bin"
printf 'chico\n' > "$t/b/conocimiento/chico.md"
sg=$(SINCRONIZAR_GRANDE=10 sincroniza b subir ya '{"hook_event_name":"PostToolUse"}')
espera "el grande no entra a git" no "$(si git -C "$t/b" ls-files --error-unmatch "conocimiento/video grande.bin")"
espera "queda en .git/info/exclude" si "$(si grep -qx '/conocimiento/video grande.bin' "$t/b/.git/info/exclude")"
espera "lo demás sí sube" si "$(si git -C "$t/remoto.git" cat-file -e main:conocimiento/chico.md)"
espera "b sin nada pendiente" "" "$(git -C "$t/b" status --porcelain)"
espera "avisa al asistente que no va al respaldo" si "$(case "$sg" in *additionalContext*"100 MB"*"video grande.bin"*) echo si;; *) echo no;; esac)"
printf 'otra\n' >> "$t/b/conocimiento/chico.md"
espera "el aviso va una sola vez" "" "$(SINCRONIZAR_GRANDE=10 sincroniza b subir ya '{"hook_event_name":"PostToolUse"}')"
rm -f "$t/b/conocimiento/video grande.bin"
cp "$t/b/conocimiento/chico.md" "$t/b/conocimiento/crece.bin"; sincroniza b subir ya > /dev/null
awk 'BEGIN { for (i = 0; i < 400; i++) print "renglón de relleno para pasar del tope de la prueba" }' > "$t/b/conocimiento/crece.bin"
sc=$(SINCRONIZAR_GRANDE=10 sincroniza b subir ya '{"hook_event_name":"PostToolUse"}')
espera "un archivo que ya estaba y creció no se vuelve a subir" si "$(git -C "$t/remoto.git" show main:conocimiento/crece.bin | grep -q relleno && echo no || echo si)"
espera "y también se avisa" si "$(case "$sc" in *"100 MB"*crece.bin*) echo si;; *) echo no;; esac)"
cp "$t/b/conocimiento/chico.md" "$t/b/conocimiento/crece.bin"; sincroniza b subir ya > /dev/null

echo "Sin red:"
git -C "$t/b" remote set-url origin "$t/no-existe.git"
printf 'remoto_permitido=%s\n' "$w/no-existe.git" > "$t/b/sistema/sincronizar.conf"
sincroniza b subir ya > /dev/null; codigo=$?
espera "sale con 0" 0 "$codigo"
espera "guarda en esta compu igual" "" "$(git -C "$t/b" status --porcelain)"
espera "lo apunta en sincronizar.log" si "$(si grep -q 'sin red o sin acceso' "$t/b/sistema/alarmas/sincronizar.log")"

echo "Remoto de la plantilla de HeyYou:"
# El push va a una ruta que no existe: si la guarda fallara, nada sale a internet.
git -C "$t/a" remote set-url origin https://github.com/heyyou-cc/AI-Brain.git
git -C "$t/a" remote set-url --push origin "$t/no-existe.git"
printf 'remoto_permitido=https://github.com/heyyou-cc/AI-Brain.git\n' > "$t/a/sistema/sincronizar.conf"
remoto_antes=$(git -C "$t/remoto.git" rev-parse main)
head_antes=$(git -C "$t/a" rev-parse HEAD)
printf 'dato del dueño\n' > "$t/a/conocimiento/privado.md"
sp1=$(sincroniza a bajar '' '{"hook_event_name":"SessionStart","session_id":"s9"}')
espera "no hace commit (nada queda listo para un push a la plantilla)" "$head_antes" "$(git -C "$t/a" rev-parse HEAD)"
espera "ni prepara el cambio" si "$(git -C "$t/a" diff --cached --quiet && git -C "$t/a" status --porcelain | grep -qx '?? conocimiento/privado.md' && echo si || echo no)"
espera "avisa que falta el remoto propio" si "$(case "$sp1" in *"falta conectar el repositorio propio"*conectar-respaldo.md*) echo si;; *) echo no;; esac)"
echo "  Aviso que recibe el asistente al empezar:"; echo "  $sp1"
espera "el aviso va una vez por sesión" "" "$(sincroniza a bajar '' '{"hook_event_name":"UserPromptSubmit","session_id":"s9"}')"
sincroniza a subir ya '{"hook_event_name":"Stop","stop_hook_active":false}' > /dev/null
espera "subir tampoco hace commit" "$head_antes" "$(git -C "$t/a" rev-parse HEAD)"
espera "no intentó subir ni bajar" no "$(si grep -q 'no-existe' "$t/a/sistema/alarmas/sincronizar.log")"
espera "el remoto no cambió" "$remoto_antes" "$(git -C "$t/remoto.git" rev-parse main)"
git -C "$t/a" remote set-url origin git@github.com:heyyou-cc/AI-Brain.git
git -C "$t/a" remote set-url --push origin "$t/no-existe.git"
sincroniza a subir ya > /dev/null
espera "con la dirección ssh de la plantilla, tampoco" "$head_antes" "$(git -C "$t/a" rev-parse HEAD)"
git -C "$t/a" remote remove origin
printf 'remoto_permitido=\n' > "$t/a/sistema/sincronizar.conf"
sincroniza a subir ya > /dev/null
espera "sin origin ni dirección escrita, tampoco" "$head_antes" "$(git -C "$t/a" rev-parse HEAD)"

echo "Apagada con CEREBRO_SINCRONIZAR=0:"
printf 'z\n' > "$t/a/conocimiento/apagada.md"
printf '{}' | CEREBRO_SINCRONIZAR=0 CLAUDE_PROJECT_DIR="$t/a" sh "$s" subir ya
espera "no hace nada" si "$(git -C "$t/a" status --porcelain | grep -q apagada && echo si || echo no)"

cd "$base" || exit 1
echo
if [ "$mal" -eq 0 ]; then echo "TODAS BIEN ($bien pruebas) · $(uname -s 2>/dev/null)"; exit 0
else echo "FALLARON $mal de $((bien + mal)) · $(uname -s 2>/dev/null)"; exit 1; fi
