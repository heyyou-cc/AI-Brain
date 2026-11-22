#!/bin/sh
# Alarma antes de la consola (Claude Code, PreToolUse de Bash y PowerShell).
# Frena los comandos que sacarían a la vista una clave de 1Password o la llave de servicio:
# usar 1Password directo en vez del mesero, leer la caja de la llave, abrir los llaveros del sistema
# o volcar todas las variables del sistema.
# Cuida de descuidos, no de mala fe: un comando armado a propósito para esquivarla puede pasar.
# Corre con sh en Mac, Linux y Windows con Git Bash. Sale con 2 (frena) y explica por qué; con 0 deja pasar.

entrada=$(cat)

frena() {
  echo "Alarma del cerebro: $1 Las claves de 1Password solo se mueven con el mesero (sistema/accesos/mesero) y solo las escribe el dueño en la ventanita (sistema/accesos/ventanita); el asistente nunca ve un valor (AGENTS.md, punto 5)." >&2
  exit 2
}

# El comando que va a correr, en minúsculas y con las diagonales de Windows volteadas.
cmd=$(printf '%s' "$entrada" | awk '{
  s = $0
  if (match(s, /"command"[ \t]*:[ \t]*"/)) {
    s = substr(s, RSTART + RLENGTH); i = 1; n = length(s)
    while (i <= n) { c = substr(s, i, 1); if (c == "\\") { i += 2; continue }; if (c == "\"") break; i++ }
    print substr(s, 1, i - 1)
  }
}' | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ\\' 'abcdefghijklmnopqrstuvwxyz/' | sed 's#//*#/#g')
[ -z "$cmd" ] && exit 0

# Quita las llamadas al mesero y a la ventanita: esas sí pueden usar 1Password por dentro.
resto=$(printf '%s' "$cmd" | sed 's#[^ ;|&"]*accesos/mesero\.ps1##g; s#[^ ;|&"]*accesos/mesero\.sh##g; s#[^ ;|&"]*accesos/ventanita\.ps1##g; s#[^ ;|&"]*accesos/ventanita\.sh##g')

# 1. 1Password directo
if printf ' %s' "$resto" | grep -Eq "(^|[[:space:];|&(\`\"'])op(\.exe)?[[:space:]]+(read|inject|run|item|document|signin|account|connect|service-account|user|plugin|events-api|ssh|vault)"; then
  frena "no se usa 1Password directo desde la consola."
fi

# 2. La llave de servicio y su caja
case "$resto" in
  *op_service_account_token*) frena "la llave de servicio de 1Password no se lee ni se escribe en la consola." ;;
  *accesos/.caja*|*cerebro-1password*) frena "la caja de la llave de 1Password no se abre." ;;
esac

# 3. Llaveros del sistema y descifrar a mano
if printf '%s' "$resto" | grep -Eq 'security[[:space:]]+(find|dump)-|secret-tool[[:space:]]+lookup|convertto-securestring|securestringtobstr|ptrtostringbstr|unprotect'; then
  frena "no se abren los llaveros del sistema ni se descifran claves a mano."
fi

# 4. Volcar todas las variables del sistema (env, printenv o set solos; env: de PowerShell)
if printf ';%s;' "$resto" | grep -Eq '[;|&(][[:space:]]*(env|printenv|set|export -p|declare -x|declare -p)[[:space:]]*[;|&)]|(get-childitem|gci|dir|ls|get-item)[[:space:]]+env:|getenvironmentvariables'; then
  frena "no se vuelcan las variables del sistema: ahí pueden ir claves."
fi

exit 0
