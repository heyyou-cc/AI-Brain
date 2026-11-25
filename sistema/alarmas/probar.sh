#!/bin/sh
# Prueba las alarmas en esta compu, sin tocar nada del dueño.
# Uso, desde la carpeta del cerebro:  sh sistema/alarmas/probar.sh
# Escribe una prueba de paso en entrada/_paso/prueba-alarmas/ y la borra al final.
# Al final dice «TODAS BIEN» o cuántas fallaron. Los números de prueba son de ejemplo, no reales.

cd "$(dirname "$0")/../.." || exit 1
base=$(pwd)
a="$base/sistema/alarmas"
bien=0
mal=0

espera() { # nombre, salida esperada, salida real
  if [ "$2" = "$3" ]; then bien=$((bien + 1)); echo "ok    · $1"
  else mal=$((mal + 1)); echo "FALLA · $1 (esperaba $2, salió $3)"; fi
}

escribe() { # ruta, contenido -> código de salida de la alarma
  printf '{"tool_name":"Write","tool_input":{"file_path":"%s","content":"%s"}}' "$1" "$2" | CLAUDE_PROJECT_DIR="$base" sh "$a/antes-de-escribir.sh" 2>/dev/null
  echo $?
}

edita() { # ruta, texto viejo, texto nuevo
  printf '{"tool_name":"Edit","tool_input":{"file_path":"%s","old_string":"%s","new_string":"%s"}}' "$1" "$2" "$3" | CLAUDE_PROJECT_DIR="$base" sh "$a/antes-de-escribir.sh" 2>/dev/null
  echo $?
}

# Números de ejemplo armados por partes, para que la alarma no frene este mismo archivo.
tarjeta="4111 1111 ""1111 1111"
tarjeta_junta="41111111""11111111"
clabe="0020100777""77777771"
curp="GOMA800101""HDFRRN09"
rfc="GOMA800101""AB1"
clave="contrase""ña: Hola2024x"
llave="sk-""abcdefghijklmnopqrstuvwx"

echo "Alarma antes de escribir:"
espera "nota normal dentro del cerebro" 0 "$(escribe "trabajo/nota.md" "Pedido del 2026-11-19, entrega 2026-11-20, folio 1234567890123")"
espera "ruta corta dentro del cerebro" 0 "$(escribe "conocimiento/oferta/precios.md" "Precio: 350 pesos")"
espera "tarjeta con espacios" 2 "$(escribe "trabajo/nota.md" "Pago con $tarjeta")"
espera "tarjeta junta" 2 "$(escribe "trabajo/nota.md" "Pago con $tarjeta_junta")"
espera "CLABE" 2 "$(escribe "trabajo/nota.md" "Deposita a $clabe")"
espera "CURP" 2 "$(escribe "trabajo/nota.md" "CURP $curp")"
espera "RFC de persona" 2 "$(escribe "trabajo/nota.md" "RFC $rfc del cliente")"
espera "RFC de empresa (se permite)" 0 "$(escribe "trabajo/nota.md" "RFC ABC010101AB1 de la empresa")"
espera "contraseña" 2 "$(escribe "trabajo/nota.md" "$clave")"
espera "frase con la palabra clave (se permite)" 0 "$(escribe "trabajo/nota.md" "Clave: en el cajon de la oficina")"
espera "llave de programa" 2 "$(escribe "trabajo/nota.md" "token $llave")"
espera "quitar una tarjeta de una nota (se permite)" 0 "$(edita "trabajo/nota.md" "Pago con $tarjeta" "Pago con tarjeta (sin numero)")"
espera "poner una tarjeta al editar" 2 "$(edita "trabajo/nota.md" "Pago" "Pago con $tarjeta")"
espera "fuera del cerebro, carpeta temporal de Mac o Linux" 2 "$(escribe "/tmp/nota.md" "hola")"
espera "fuera del cerebro, carpeta de Windows" 2 "$(escribe 'C:\\\\Windows\\\\Temp\\\\nota.md' "hola")"
espera "subir de carpeta" 2 "$(escribe "trabajo/../../nota.md" "hola")"
dentro=$(printf '%s' "$base/trabajo/nota.md" | sed 's#\\#\\\\\\\\#g')
espera "ruta completa dentro del cerebro" 0 "$(escribe "$dentro" "hola")"

llave_op="ops_""eyJhbGciOiJFUzI1NiIsImtpZCI6"
espera "referencia de 1Password (se permite)" 0 "$(escribe "conocimiento/operacion/accesos.md" "clave: op://Negocio/Banco del negocio/contrasena")"
espera "llave de servicio de 1Password" 2 "$(escribe "trabajo/nota.md" "llave $llave_op")"

echo "Alarma antes de la consola:"
consola() { # comando -> código de salida
  printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1" | CLAUDE_PROJECT_DIR="$base" sh "$a/antes-de-la-consola.sh" 2>/dev/null
  echo $?
}
espera "comando normal" 0 "$(consola "ls conocimiento")"
espera "env con una variable (se permite)" 0 "$(consola "env LANG=C sort archivo.txt")"
espera "set -e (se permite)" 0 "$(consola "set -e; echo hola")"
espera "usar el mesero (se permite)" 0 "$(consola "sh sistema/accesos/mesero.sh correr refs.env programa")"
espera "usar el mesero en Windows (se permite)" 0 "$(consola "powershell -File sistema\\\\accesos\\\\mesero.ps1 revisar")"
espera "usar la ventanita (se permite)" 0 "$(consola "sh sistema/accesos/ventanita.sh existe Negocio Banco contrasena")"
espera "leer de 1Password directo" 2 "$(consola "op read op://Negocio/Banco/contrasena")"
espera "ver un elemento de 1Password" 2 "$(consola "op.exe item get Banco --reveal")"
espera "1Password directo después del mesero" 2 "$(consola "sh sistema/accesos/mesero.sh revisar; op read op://x/y/z")"
espera "imprimir la llave de servicio" 2 "$(consola "echo \$OP_SERVICE_ACCOUNT_TOKEN")"
espera "abrir la caja de la llave" 2 "$(consola "cat sistema/accesos/.caja")"
espera "abrir el llavero de Mac" 2 "$(consola "security find-generic-password -s cerebro-1password -w")"
espera "volcar variables" 2 "$(consola "printenv")"
espera "volcar variables en PowerShell" 2 "$(consola "Get-ChildItem env:")"
espera "descifrar a mano" 2 "$(consola "ConvertTo-SecureString x")"

echo "Alarma al terminar:"
p="$base/entrada/_paso/prueba-alarmas"
rm -rf "$p"
mkdir -p "$p/sistema/alarmas" "$p/conocimiento" "$p/entrada"
CLAUDE_PROJECT_DIR="$p" sh "$a/al-recibir.sh" < /dev/null
espera "la alarma de al recibir deja su marca" si "$([ -f "$p/sistema/alarmas/.ultima-orden" ] && echo si || echo no)"
sleep 1
termina() { printf '%s' "$1" | CLAUDE_PROJECT_DIR="$p" sh "$a/al-terminar.sh" 2>/dev/null; echo $?; }
espera "sin cambios, se deja ir" 0 "$(termina '{"stop_hook_active":false,"last_assistant_message":"Listo."}')"
echo "dato" > "$p/conocimiento/nota.md"
espera "cambió algo y no dijo Guardé" 2 "$(termina '{"stop_hook_active":false,"last_assistant_message":"Listo, ya quedó."}')"
espera "cambió algo y sí dijo Guardé" 0 "$(termina '{"stop_hook_active":false,"last_assistant_message":"Listo.\n\nGuardé: el dato → conocimiento/nota.md"}')"
espera "segunda vez, se deja ir" 0 "$(termina '{"stop_hook_active":true,"last_assistant_message":"Listo."}')"
mkdir -p "$p/entrada/_paso"; echo x > "$p/entrada/_paso/sobra.csv"
espera "quedaron archivos de paso" 2 "$(termina '{"stop_hook_active":false,"last_assistant_message":"Guardé: x → y"}')"
rm -rf "$p"

echo "Voz del dueño:"
v="$base/entrada/_paso/prueba-voz"
rm -rf "$v"
mkdir -p "$v/sistema/alarmas" "$v/sistema/estilo" "$v/conocimiento/dueno"
# Una nota de voz de ejemplo, con trato y largo ya llenos (la de la plantilla dice «pendiente»).
printf '# Cómo hablarle\n\n## Trato\n\nde tú, sin formalidad\n\n## Qué tan largas quiere las respuestas\n\ncortas\n\n## Cómo escribe él\n\nchido, o sea\n\n## Historia\n\nNada todavía.\n' > "$v/conocimiento/dueno/como-hablarle.md"
printf -- '- estilo_aprende_hasta: 2999-01-01\n' > "$v/sistema/estado.md"
export ESTILO_SIN_DESTILAR=1
recibe() { printf '%s' "$1" | CLAUDE_PROJECT_DIR="$v" sh "$a/al-recibir.sh" 2>/dev/null; }
cuenta() { wc -l < "$v/sistema/estilo/muestras.jsonl" 2>/dev/null | tr -d ' '; }
s1=$(recibe '{"session_id":"s1","prompt":"oye pues está chido, o sea me late"}')
espera "mensaje normal: se guarda 1 muestra" 1 "$(cuenta)"
espera "la muestra contiene lo escrito" si "$(grep -q 'me late' "$v/sistema/estilo/muestras.jsonl" && echo si || echo no)"
espera "primer mensaje: pasa la voz vigente" si "$(printf '%s' "$s1" | grep -q 'Voz del dueno para esta sesion' && echo si || echo no)"
s2=$(recibe '{"session_id":"s1","prompt":"otra cosa nomas"}')
espera "segundo mensaje: no repite la voz entera" no "$(case "$s2" in *"Voz del dueno"*) echo si;; *) echo no;; esac)"
espera "segundo mensaje: recuerda trato y largo" si "$(case "$s2" in *"cumple: trato:"*"largo:"*) echo si;; *) echo no;; esac)"
sleep 1
touch "$v/conocimiento/dueno/como-hablarle.md"
s3=$(recibe '{"session_id":"s1","prompt":"y una mas"}')
espera "nota nueva: avisa que se afinó" si "$(printf '%s' "$s3" | grep -q 'se afino' && echo si || echo no)"
recibe '{"session_id":"s1","prompt":"mi tarjeta '"$tarjeta"'"}' > /dev/null
ultima=$(tail -n 1 "$v/sistema/estilo/muestras.jsonl")
espera "número largo: queda tapado" si "$(printf '%s' "$ultima" | grep -q '\[numero tapado\]' && echo si || echo no)"
espera "número largo: no queda el número" no "$(printf '%s' "$ultima" | grep -q '1111 1111' && echo si || echo no)"
antes=$(cuenta)
recibe '{"session_id":"s1","prompt":"/arranque"}' > /dev/null
espera "comando con diagonal: no se guarda" "$antes" "$(cuenta)"
antes=$(cuenta)
sd=$(printf '%s' '{"session_id":"s2","prompt":"hola soy el ayudante"}' | ESTILO_DESTILANDO=1 CLAUDE_PROJECT_DIR="$v" sh "$a/al-recibir.sh" 2>/dev/null)
espera "ayudante destilando: no guarda" "$antes" "$(cuenta)"
espera "ayudante destilando: no imprime" "" "$sd"
recibe '{"session_id":"s1","prompt":"dijo \"chido\" y ya"}' > /dev/null
espera "comillas escapadas: se guarda" si "$(tail -n 1 "$v/sistema/estilo/muestras.jsonl" | grep -q 'chido' && echo si || echo no)"
unset ESTILO_SIN_DESTILAR

# al-terminar con la nota afinada por el ayudante de la voz
termina_v() { printf '%s' "$1" | CLAUDE_PROJECT_DIR="$v" sh "$a/al-terminar.sh" 2>/dev/null; echo $?; }
rm -f "$v/sistema/alarmas/.ultima-orden" "$v/sistema/estilo/.ultimo-destilado"
touch "$v/sistema/alarmas/.ultima-orden"
sleep 1
touch "$v/conocimiento/dueno/como-hablarle.md"
sleep 1
touch "$v/sistema/estilo/.ultimo-destilado"
espera "nota afinada por el ayudante, sin Guardé: se deja ir" 0 "$(termina_v '{"stop_hook_active":false,"last_assistant_message":"Listo."}')"
sleep 1
touch "$v/conocimiento/dueno/como-hablarle.md"
espera "nota cambiada por el asistente, sin Guardé: frena" 2 "$(termina_v '{"stop_hook_active":false,"last_assistant_message":"Listo."}')"
rm -rf "$v"

echo "Lo que manda Codex:"
envia() { # alarma, json -> código de salida
  printf '%s' "$2" | CLAUDE_PROJECT_DIR="$base" sh "$a/$1" 2>/dev/null
  echo $?
}
parche() { # ruta, línea del parche -> json de apply_patch como lo manda Codex
  printf '{"session_id":"s1","turn_id":"t1","cwd":"%s","hook_event_name":"PreToolUse","model":"gpt","tool_name":"apply_patch","tool_input":{"command":"*** Begin Patch\\n*** Add File: %s\\n%s\\n*** End Patch"}}' "$base" "$1" "$2"
}
espera "apply_patch dentro del cerebro" 0 "$(envia antes-de-escribir.sh "$(parche trabajo/n.md '+hola')")"
espera "apply_patch fuera del cerebro" 2 "$(envia antes-de-escribir.sh "$(parche /tmp/n.md '+hola')")"
espera "apply_patch que sube de carpeta" 2 "$(envia antes-de-escribir.sh "$(parche ../n.md '+hola')")"
espera "apply_patch con una tarjeta en una línea nueva" 2 "$(envia antes-de-escribir.sh "$(parche trabajo/n.md "+Pago con $tarjeta")")"
espera "apply_patch que quita una tarjeta (se permite)" 0 "$(envia antes-de-escribir.sh "$(parche trabajo/n.md "-Pago con $tarjeta")")"
espera "consola de Codex: 1Password directo" 2 "$(envia antes-de-la-consola.sh '{"session_id":"s1","turn_id":"t1","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"op read op://a/b/c"}}')"
espera "consola de Codex: comando normal" 0 "$(envia antes-de-la-consola.sh '{"session_id":"s1","turn_id":"t1","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"ls conocimiento"}}')"

echo "Lo que manda Copilot:"
cop() { # herramienta, argumentos ya escapados como texto -> json camelCase
  printf '{"sessionId":"c1","timestamp":1700000000000,"cwd":"%s","toolName":"%s","toolArgs":"%s"}' "$base" "$1" "$2"
}
espera "create dentro del cerebro" 0 "$(envia antes-de-escribir.sh "$(cop create '{\"path\":\"trabajo/n.md\",\"file_text\":\"hola\"}')")"
espera "create fuera del cerebro" 2 "$(envia antes-de-escribir.sh "$(cop create '{\"path\":\"/tmp/n.md\",\"file_text\":\"hola\"}')")"
espera "edit con una tarjeta" 2 "$(envia antes-de-escribir.sh "$(cop edit '{\"path\":\"trabajo/n.md\",\"old_str\":\"a\",\"new_str\":\"Pago con '"$tarjeta"'\"}')")"
espera "view fuera del cerebro (leer se permite)" 0 "$(envia antes-de-escribir.sh "$(cop view '{\"path\":\"/tmp/n.md\"}')")"
espera "bash: 1Password directo" 2 "$(envia antes-de-la-consola.sh "$(cop bash '{\"command\":\"op read op://a/b/c\"}')")"
espera "bash: comando normal" 0 "$(envia antes-de-la-consola.sh "$(cop bash '{\"command\":\"ls conocimiento\"}')")"
espera "powershell: volcar variables" 2 "$(envia antes-de-la-consola.sh "$(cop powershell '{\"command\":\"Get-ChildItem env:\"}')")"
espera "eventos en PascalCase (formato de Claude)" 2 "$(envia antes-de-la-consola.sh '{"hook_event_name":"PreToolUse","session_id":"c1","tool_name":"bash","tool_input":{"command":"printenv"}}')"
espera "con la marca BOM al principio" 2 "$(envia antes-de-la-consola.sh "$(printf '\357\273\277')"'{"tool_name":"Bash","tool_input":{"command":"printenv"}}')"
w2="$base/entrada/_paso/prueba-copilot"
rm -rf "$w2"
mkdir -p "$w2/sistema/alarmas" "$w2/sistema/estilo" "$w2/conocimiento/dueno"
printf -- '- estilo_aprende_hasta: 2999-01-01\n' > "$w2/sistema/estado.md"
export ESTILO_SIN_DESTILAR=1
recibe2() { printf '%s' "$1" | CLAUDE_PROJECT_DIR="$w2" sh "$a/al-recibir.sh" 2>/dev/null; }
recibe2 '{"sessionId":"c1","timestamp":1,"cwd":"/x","prompt":"oye me late el color"}' > /dev/null
espera "Copilot: se guarda el mensaje" 1 "$(wc -l < "$w2/sistema/estilo/muestras.jsonl" | tr -d ' ')"
recibe2 '{"sessionId":"c1","timestamp":2,"cwd":"/x","prompt":"oye me late el color"}' > /dev/null
espera "Copilot: el mismo aviso dos veces no se repite" 1 "$(wc -l < "$w2/sistema/estilo/muestras.jsonl" | tr -d ' ')"
espera "Copilot: lo que userPromptSubmitted descarta se aparta para entregarlo después" si "$(grep -q 'Recordatorio del cerebro' "$w2/sistema/estilo/.tmp-copilot" 2>/dev/null && echo si || echo no)"
espera "Copilot: el recordatorio fijo no se apila" 1 "$(grep -c 'Recordatorio del cerebro' "$w2/sistema/estilo/.tmp-copilot" 2>/dev/null)"
espera "Copilot: al-recibir no imprime nada (se descartaría)" "" "$(printf '%s' '{"sessionId":"c1","timestamp":3,"cwd":"/x","prompt":"otra vez"}' | CLAUDE_PROJECT_DIR="$w2" sh "$a/al-recibir.sh" 2>/dev/null)"
unset ESTILO_SIN_DESTILAR
rm -rf "$w2"

echo "Carpetas privadas:"
# Devuelve: ask (pregunta al dueño), frena (sale con 2) o pasa.
priv() { # alarma, json, [agente]
  s=$(printf '%s' "$2" | CEREBRO_AGENTE="$3" CLAUDE_PROJECT_DIR="$base" sh "$a/$1" 2>/dev/null); c=$?
  if [ "$c" -eq 2 ]; then echo frena
  elif printf '%s' "$s" | grep -q '"permissionDecision":"ask"'; then echo ask
  else echo pasa; fi
}
leer() { priv antes-de-leer.sh "$1" "$2"; }
cons() { leer '{"tool_name":"Bash","tool_input":{"command":"'"$1"'"}}' "$2"; }
espera "Read de un archivo privado: pregunta" ask "$(leer '{"tool_name":"Read","tool_input":{"file_path":"C:\\Users\\a\\cerebro\\finanzas\\_privado\\banco.md"}}')"
espera "Read de un archivo normal: pasa" pasa "$(leer '{"tool_name":"Read","tool_input":{"file_path":"conocimiento/nota.md"}}')"
espera "Grep dentro de la carpeta privada: pregunta" ask "$(leer '{"tool_name":"Grep","tool_input":{"pattern":"x","path":"/c/cerebro/_privado"}}')"
espera "Write a la carpeta privada: pasa" pasa "$(leer '{"tool_name":"Write","tool_input":{"file_path":"_privado/n.md","content":"hola"}}')"
espera "cat de un archivo privado: pregunta" ask "$(cons 'cat conocimiento/_privado/a.md')"
espera "Get-Content con diagonales de Windows: pregunta" ask "$(cons 'Get-Content .\\_privado\\a.md')"
espera "grep en la carpeta privada: pregunta" ask "$(cons 'grep -r tarjeta _privado')"
espera "sed -n sobre un archivo privado: pregunta" ask "$(cons "sed -n 1,5p _privado/a.md")"
espera "copiar DESDE la carpeta privada: pregunta" ask "$(cons 'cp _privado/datos.csv .')"
espera "mover DESDE la carpeta privada: pregunta" ask "$(cons 'mv _privado/x.md y.md')"
espera "copiar HACIA la carpeta privada: pasa" pasa "$(cons 'cp datos.csv _privado/')"
espera "redirigir HACIA la carpeta privada: pasa" pasa "$(cons 'echo hola > _privado/n.md')"
espera "listar nombres de la carpeta privada: pasa" pasa "$(cons 'ls _privado')"
espera "comando sin la carpeta privada: pasa" pasa "$(cons 'cat conocimiento/nota.md')"
espera "Codex no sabe preguntar: frena" frena "$(priv antes-de-leer.sh '{"turn_id":"t","tool_name":"Bash","tool_input":{"command":"cat _privado/a.md"}}' codex)"
espera "Codex: el mensaje le dice qué hacer" si "$(printf '%s' '{"turn_id":"t","tool_name":"Bash","tool_input":{"command":"cat _privado/a.md"}}' | CEREBRO_AGENTE=codex CLAUDE_PROJECT_DIR="$base" sh "$a/antes-de-leer.sh" 2>&1 >/dev/null | grep -q 'permiso al dueño en el chat' && echo si || echo no)"
espera "Copilot: view de un archivo privado, pregunta" ask "$(priv antes-de-leer.sh "$(cop view '{\"path\":\"/c/cerebro/_privado/a.md\"}')")"
espera "Copilot: la pregunta va en el formato de Copilot" si "$(printf '%s' "$(cop view '{\"path\":\"_privado/a.md\"}')" | CLAUDE_PROJECT_DIR="$base" sh "$a/antes-de-leer.sh" 2>/dev/null | grep -q '^{"permissionDecision":"ask"' && echo si || echo no)"
espera "Copilot: bash con cat de un archivo privado, pregunta" ask "$(priv antes-de-leer.sh "$(cop bash '{\"command\":\"cat _privado/a.md\"}')")"

echo "Carpetas privadas: mayúsculas, más verbos, entrada con < y el _leeme.md:"
espera "mayúscula inicial en la consola (_Privado): pregunta" ask "$(cons 'cat conocimiento/_Privado/a.md')"
espera "todo en mayúsculas en la consola (_PRIVADO): pregunta" ask "$(cons 'cat _PRIVADO/a.md')"
espera "Read en _Privado: pregunta" ask "$(leer '{"tool_name":"Read","tool_input":{"file_path":"C:\\Users\\a\\cerebro\\_Privado\\banco.md"}}')"
espera "entrada con < desde la carpeta privada: pregunta" ask "$(cons 'micomando < _privado/a.md')"
espera "wc sobre un archivo privado: pregunta" ask "$(cons 'wc -l _privado/a.md')"
espera "cut sobre un archivo privado: pregunta" ask "$(cons 'cut -d, -f1 _privado/a.csv')"
espera "diff sobre un archivo privado: pregunta" ask "$(cons 'diff _privado/a.md b.md')"
espera "sort sobre un archivo privado: pregunta" ask "$(cons 'sort _privado/a.md')"
espera "uniq sobre un archivo privado: pregunta" ask "$(cons 'uniq _privado/a.md')"
espera "jq sobre un archivo privado: pregunta" ask "$(cons 'jq . _privado/a.json')"
espera "perl sobre un archivo privado: pregunta" ask "$(cons 'perl -ne print _privado/a.md')"
espera "awk sobre un archivo privado: pregunta" ask "$(cons 'awk 1 _privado/a.md')"
espera "node sobre un archivo privado: pregunta" ask "$(cons 'node leer.js _privado/a.md')"
espera "[IO.File]::ReadAllText en la carpeta privada: pregunta" ask "$(cons "[IO.File]::ReadAllText('_privado/a.md')")"
espera "Import-Csv de la carpeta privada: pregunta" ask "$(cons 'Import-Csv _privado/a.csv')"
espera "Read del _leeme.md de la carpeta privada: pasa" pasa "$(leer '{"tool_name":"Read","tool_input":{"file_path":"_privado/_leeme.md"}}')"
espera "cat del _leeme.md de la carpeta privada: pasa" pasa "$(cons 'cat _privado/_leeme.md')"
espera "cat del _leeme.md y de otro archivo privado: pregunta" ask "$(cons 'cat _privado/_leeme.md _privado/a.md')"

pv="$base/entrada/_paso/prueba-privada"      # un cerebro de prueba con datos en una carpeta privada
pv0="$base/entrada/_paso/prueba-sin-privada" # otro donde la carpeta privada solo tiene su _leeme.md
rm -rf "$pv" "$pv0"
mkdir -p "$pv/sistema" "$pv/conocimiento/_Privado" "$pv0/sistema" "$pv0/_privado"
printf 'secreto\n' > "$pv/conocimiento/_Privado/a.md"
printf 'explicacion\n' > "$pv0/_privado/_leeme.md"
privr() { # raíz, json, [agente]
  s=$(printf '%s' "$2" | CEREBRO_AGENTE="$3" CLAUDE_PROJECT_DIR="$1" sh "$a/antes-de-leer.sh" 2>/dev/null); c=$?
  if [ "$c" -eq 2 ]; then echo frena
  elif printf '%s' "$s" | grep -q '"permissionDecision":"ask"'; then echo ask
  else echo pasa; fi
}
rec() { privr "$1" '{"tool_name":"Bash","tool_input":{"command":"'"$2"'"}}' "$3"; }
echo "Comandos que recorren todo el cerebro (con datos en una carpeta privada):"
espera "grep -rn de la raíz: pregunta" ask "$(rec "$pv" 'grep -rn nombre .')"
espera "grep -R de la raíz: pregunta" ask "$(rec "$pv" 'grep -R nombre .')"
espera "grep --recursive: pregunta" ask "$(rec "$pv" 'grep --recursive nombre .')"
espera "rg --no-ignore: pregunta" ask "$(rec "$pv" 'rg --no-ignore nombre')"
espera "rg -uu: pregunta" ask "$(rec "$pv" 'rg -uu nombre')"
espera "findstr /s: pregunta" ask "$(rec "$pv" 'findstr /s /i nombre *.md')"
espera "Get-ChildItem -Recurse con Select-String: pregunta" ask "$(rec "$pv" 'Get-ChildItem -Recurse | Select-String nombre')"
espera "Get-ChildItem -Recurse con Get-Content: pregunta" ask "$(rec "$pv" 'Get-ChildItem -Recurse -File | ForEach-Object { Get-Content $_ }')"
espera "tar de la raíz: pregunta" ask "$(rec "$pv" 'tar czf copia.tgz .')"
espera "zip -r de la raíz: pregunta" ask "$(rec "$pv" 'zip -r copia.zip .')"
espera "Compress-Archive: pregunta" ask "$(rec "$pv" 'Compress-Archive -Path . -DestinationPath copia.zip')"
espera "cp -r de la raíz: pregunta" ask "$(rec "$pv" 'cp -r . ../copia')"
espera "Copy-Item -Recurse de la raíz: pregunta" ask "$(rec "$pv" 'Copy-Item . ../copia -Recurse')"
espera "Codex: grep -r de la raíz frena" frena "$(rec "$pv" 'grep -r nombre .' codex)"
espera "Get-ChildItem -Recurse solo con nombres: pasa" pasa "$(rec "$pv" 'Get-ChildItem -Recurse')"
espera "grep sin -r sobre un archivo normal: pasa" pasa "$(rec "$pv" 'grep nombre conocimiento/nota.md')"
espera "rg normal (respeta .ignore): pasa" pasa "$(rec "$pv" 'rg nombre')"
espera "grep -r si la carpeta privada solo tiene su _leeme.md: pasa" pasa "$(rec "$pv0" 'grep -rn nombre .')"
espera "zip -r si la carpeta privada solo tiene su _leeme.md: pasa" pasa "$(rec "$pv0" 'zip -r copia.zip .')"
rm -rf "$pv" "$pv0"

echo "Sin la app de Claude (la voz no se afina, nada se rompe):"
d="$base/entrada/_paso/prueba-destilar"
rm -rf "$d"
mkdir -p "$d/sistema/alarmas" "$d/sistema/estilo" "$d/conocimiento/dueno"
printf '# Nota\n\n## Trato\n\nx\n' > "$d/conocimiento/dueno/como-hablarle.md"
printf '{"texto":"hola"}\n' > "$d/sistema/estilo/muestras.jsonl"
CEREBRO_SIN_CLAUDE=1 CLAUDE_PROJECT_DIR="$d" sh "$a/destilar-voz.sh" > /dev/null 2>&1
espera "destilar-voz sin claude sale 0" 0 "$?"
espera "los mensajes vuelven a la fila" 1 "$(wc -l < "$d/sistema/estilo/muestras.jsonl" | tr -d ' ')"
rm -rf "$d"

echo "Lanzador de Windows (correr.ps1):"
ps=$(command -v powershell.exe || command -v powershell || command -v pwsh)
if [ -z "$ps" ]; then
  echo "omitido · aquí no hay PowerShell (en Mac sin pwsh es lo normal)"
else
  lanza=$(cygpath -w "$a/correr.ps1" 2>/dev/null || echo "$a/correr.ps1")
  corre() { # json, alarma, [-Agente x]  (variable SIN_SH=1 simula una compu sin Git Bash)
    printf '%s' "$1" | CEREBRO_SIN_SH="$SIN_SH" "$ps" -NoProfile -ExecutionPolicy Bypass -File "$lanza" $3 $4 "$2" 2>/dev/null
    echo $?
  }
  mal_e='{"tool_name":"Write","tool_input":{"file_path":"/tmp/nota.md","content":"hola"}}'
  bien_e='{"tool_name":"Write","tool_input":{"file_path":"trabajo/nota.md","content":"hola"}}'
  espera "lanzador: escritura fuera del cerebro, frena (2)" 2 "$(corre "$mal_e" antes-de-escribir.sh)"
  espera "lanzador: escritura normal, pasa (0)" 0 "$(corre "$bien_e" antes-de-escribir.sh)"
  espera "lanzador: tarjeta, frena (2)" 2 "$(corre '{"tool_name":"Write","tool_input":{"file_path":"trabajo/n.md","content":"Pago con '"$tarjeta"'"}}' antes-de-escribir.sh)"
  espera "lanzador: formato de Copilot, frena (2)" 2 "$(corre "$(cop create '{\"path\":\"/tmp/n.md\",\"file_text\":\"hola\"}')" antes-de-escribir.sh -Agente copilot)"
  espera "lanzador: con -Agente codex, carpeta privada frena (2)" 2 "$(corre '{"turn_id":"t","tool_name":"Bash","tool_input":{"command":"cat _privado/a.md"}}' antes-de-leer.sh -Agente codex)"
  espera "lanzador: alarma que no existe, pasa (0)" 0 "$(corre '{}' no-existe.sh)"
  SIN_SH=1
  espera "sin Git Bash: escritura fuera, frena igual (2)" 2 "$(corre "$mal_e" antes-de-escribir.sh)"
  espera "sin Git Bash: escritura normal, pasa (0)" 0 "$(corre "$bien_e" antes-de-escribir.sh)"
  espera "sin Git Bash: carpeta privada, frena (2)" 2 "$(corre '{"tool_name":"Bash","tool_input":{"command":"cat _privado/a.md"}}' antes-de-leer.sh)"
  espera "sin Git Bash: otra alarma, pasa en silencio (0)" 0 "$(corre '{"tool_name":"Bash","tool_input":{"command":"printenv"}}' antes-de-la-consola.sh)"
  SIN_SH=""
fi
rmdir "$base/entrada/_paso" 2>/dev/null

echo
if [ "$mal" -eq 0 ]; then echo "TODAS BIEN ($bien pruebas) · $(uname -s 2>/dev/null)"; exit 0
else echo "FALLARON $mal de $((bien + mal)) · $(uname -s 2>/dev/null)"; exit 1; fi
