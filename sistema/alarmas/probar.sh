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
cp "$base/conocimiento/dueno/como-hablarle.md" "$v/conocimiento/dueno/como-hablarle.md"
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
rmdir "$base/entrada/_paso" 2>/dev/null

echo
if [ "$mal" -eq 0 ]; then echo "TODAS BIEN ($bien pruebas) · $(uname -s 2>/dev/null)"; exit 0
else echo "FALLARON $mal de $((bien + mal)) · $(uname -s 2>/dev/null)"; exit 1; fi
