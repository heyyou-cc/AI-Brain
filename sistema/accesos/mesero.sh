#!/bin/sh
# Mesero (Mac y Linux): lleva datos de 1Password a donde hacen falta sin que el asistente los vea.
# El asistente solo nombra los datos con referencias op://<cajon>/<elemento>/<campo>; el valor lo pone 1Password.
#
# Uso, desde la carpeta del cerebro:
#   sh sistema/accesos/mesero.sh revisar
#   sh sistema/accesos/mesero.sh correr <archivo-de-referencias> <programa> [argumentos...]
#       (renglones NOMBRE=op://Negocio/Banco del negocio/contrasena; en lo que imprima, 1Password tapa los valores)
#   sh sistema/accesos/mesero.sh llenar <plantilla> <archivo-de-salida>
#       (la plantilla trae {{ op://... }}; el archivo de salida queda con valores: el asistente nunca lo abre)

aqui=$(cd "$(dirname "$0")" && pwd)
. "$aqui/caja.sh"

command -v op >/dev/null 2>&1 || { echo "error: 1Password no está instalado en esta compu"; exit 2; }
carga_llave || { echo "error: falta la llave de servicio de 1Password en esta compu (abrir la ventanita: ventanita.sh llave)"; exit 2; }

accion="$1"; shift 2>/dev/null
case "$accion" in
  revisar)
    op whoami >/dev/null 2>&1 || { echo "error: 1Password no acepta la llave guardada"; exit 2; }
    echo "1Password responde. Cajones que ve la llave:"
    op vault list --format json 2>/dev/null | awk 'BEGIN { RS = "," } /"name"/ { sub(/.*"name"[ \t]*:[ \t]*"/, ""); sub(/".*/, ""); print "- " $0 }'
    exit 0 ;;
  correr)
    [ $# -ge 2 ] || { echo "error: uso: correr <archivo-de-referencias> <programa> [argumentos...]"; exit 2; }
    refs="$1"; shift
    [ -f "$refs" ] || { echo "error: no encuentro $refs"; exit 2; }
    if grep -v '^[[:space:]]*$' "$refs" | grep -v '^[[:space:]]*#' | grep -qv '^[A-Za-z_][A-Za-z0-9_]*=op://'; then
      echo "error: el archivo de referencias solo lleva renglones NOMBRE=op://...; no valores"; exit 2
    fi
    exec op run --env-file "$refs" -- "$@" ;;
  llenar)
    [ $# -ge 2 ] || { echo "error: uso: llenar <plantilla> <archivo-de-salida>"; exit 2; }
    op inject -i "$1" -o "$2" -f >/dev/null 2>&1 || { echo "error: 1Password no pudo llenar la plantilla (revisa que cada referencia exista)"; exit 2; }
    echo "listo: $2 quedó lleno. No lo abras ni lo copies: trae los valores."
    exit 0 ;;
  *)
    echo "uso: mesero.sh revisar | correr <referencias> <programa> [args] | llenar <plantilla> <salida>"; exit 2 ;;
esac
