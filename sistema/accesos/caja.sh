#!/bin/sh
# Caja de la llave de servicio de 1Password en esta compu (Mac y Linux). La usan ventanita.sh y mesero.sh.
# Mac: el Llavero del sistema. Linux: el llavero del escritorio (secret-tool) si existe; si no, un archivo
# que solo puede leer este usuario (sistema/accesos/.caja-linux). La llave nunca se imprime.

_caja_dir=$(cd "$(dirname "$0")" && pwd)
_caja_archivo="$_caja_dir/.caja-linux"

guarda_llave() { # valor
  if [ "$(uname -s)" = "Darwin" ]; then
    security add-generic-password -U -a cerebro-del-negocio -s cerebro-1password -w "$1" >/dev/null 2>&1
  elif command -v secret-tool >/dev/null 2>&1; then
    printf '%s' "$1" | secret-tool store --label="Cerebro del negocio: 1Password" servicio cerebro-1password >/dev/null 2>&1
  else
    ( umask 077; printf '%s' "$1" > "$_caja_archivo" ) && chmod 600 "$_caja_archivo"
  fi
}

carga_llave() { # deja OP_SERVICE_ACCOUNT_TOKEN listo solo para este proceso
  _v=""
  if [ "$(uname -s)" = "Darwin" ]; then
    _v=$(security find-generic-password -a cerebro-del-negocio -s cerebro-1password -w 2>/dev/null)
  elif command -v secret-tool >/dev/null 2>&1; then
    _v=$(secret-tool lookup servicio cerebro-1password 2>/dev/null)
  fi
  if [ -z "$_v" ] && [ -f "$_caja_archivo" ]; then _v=$(cat "$_caja_archivo"); fi
  if [ -n "$_v" ]; then OP_SERVICE_ACCOUNT_TOKEN="$_v"; export OP_SERVICE_ACCOUNT_TOKEN; fi
  _v=""
  [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]
}
