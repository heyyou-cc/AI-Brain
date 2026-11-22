#!/bin/sh
# Ventanita para que el dueño escriba un dato delicado sin pasarlo por el chat (Mac y Linux).
# Abre un cuadro aparte donde el dueño escribe el dato dos veces (no se ve); al aceptar se guarda en 1Password.
# Al asistente solo le regresa: guardado, cancelado, sin cambios o error.
# Mac: cuadro del sistema (osascript). Linux: zenity o kdialog, si la compu los trae.
#
# Uso, desde la carpeta del cerebro:
#   sh sistema/accesos/ventanita.sh dato <cajon> <elemento> <campo> [visible]
#   sh sistema/accesos/ventanita.sh llave            (guarda la llave de servicio de 1Password en esta compu)
#   sh sistema/accesos/ventanita.sh existe <cajon> <elemento> <campo>

aqui=$(cd "$(dirname "$0")" && pwd)
. "$aqui/caja.sh"

modo="$1"
cajon="$2"; elemento="$3"; campo="$4"; visible="$5"

command -v op >/dev/null 2>&1 || { echo "error: 1Password no está instalado en esta compu"; exit 2; }

pide() { # titulo, texto -> valor por stdout; código 1 si cancela
  if [ "$(uname -s)" = "Darwin" ]; then
    osascript -e "text returned of (display dialog \"$2\" with title \"$1\" default answer \"\" with hidden answer buttons {\"Cancelar\", \"Guardar\"} default button \"Guardar\" cancel button \"Cancelar\")" 2>/dev/null
  elif command -v zenity >/dev/null 2>&1; then
    zenity --password --title="$1 · $2" 2>/dev/null
  elif command -v kdialog >/dev/null 2>&1; then
    kdialog --title "$1" --password "$2" 2>/dev/null
  else
    return 3
  fi
}

pregunta() { # texto -> 0 si dice que sí
  if [ "$(uname -s)" = "Darwin" ]; then
    r=$(osascript -e "button returned of (display dialog \"$1\" with title \"Dato privado del negocio\" buttons {\"No\", \"Sí, reemplazar\"} default button \"No\")" 2>/dev/null)
    [ "$r" = "Sí, reemplazar" ]
  elif command -v zenity >/dev/null 2>&1; then
    zenity --question --title="Dato privado del negocio" --text="$1" 2>/dev/null
  elif command -v kdialog >/dev/null 2>&1; then
    kdialog --title "Dato privado del negocio" --yesno "$1" 2>/dev/null
  else
    return 1
  fi
}

json_texto() { # escapa un texto para JSON
  printf '%s' "$1" | awk 'BEGIN { ORS = "" } {
    gsub(/\\/, "\\\\"); gsub(/"/, "\\\""); gsub(/\t/, "\\t"); gsub(/\r/, "\\r")
    if (NR > 1) printf "\\n"
    printf "%s", $0
  }'
}

tiene_campo() {
  v=$(op item get "$elemento" --vault "$cajon" --fields "label=$campo" 2>/dev/null)
  [ -n "$v" ]
}

case "$modo" in
  existe)
    carga_llave || { echo "error: falta la llave de servicio de 1Password en esta compu"; exit 2; }
    if tiene_campo; then echo "si existe"; else echo "no existe"; fi
    exit 0 ;;

  llave)
    uno=$(pide "Dato privado del negocio" "Pega la llave de servicio de 1Password para tu asistente (empieza con ops_). No se ve ni le llega al asistente.")
    c=$?; [ $c -eq 3 ] && { echo "error: esta compu no tiene cómo abrir la ventanita (falta zenity o kdialog)"; exit 2; }
    [ -z "$uno" ] && { echo "cancelado"; exit 1; }
    dos=$(pide "Dato privado del negocio" "Pégala otra vez para confirmar.")
    [ "$uno" = "$dos" ] || { echo "error: las dos no coinciden; no se guardó nada"; exit 2; }
    OP_SERVICE_ACCOUNT_TOKEN="$uno" op whoami >/dev/null 2>&1 || { echo "error: 1Password no aceptó esa llave; no se guardó nada"; exit 2; }
    guarda_llave "$uno" || { echo "error: no pude guardarla en la caja de esta compu"; exit 2; }
    uno=""; dos=""
    echo "guardado"; exit 0 ;;

  dato)
    [ -n "$cajon" ] && [ -n "$elemento" ] && [ -n "$campo" ] || { echo "error: uso: ventanita.sh dato <cajon> <elemento> <campo> [visible]"; exit 2; }
    carga_llave || { echo "error: falta la llave de servicio de 1Password en esta compu"; exit 2; }
    existe_elemento=no
    op item get "$elemento" --vault "$cajon" >/dev/null 2>&1 && existe_elemento=si
    if [ "$existe_elemento" = si ] && tiene_campo; then
      pregunta "«$campo» de «$elemento» ya tiene un valor guardado. ¿Quieres reemplazarlo?" || { echo "sin cambios: ya tenía valor y el dueño no quiso reemplazarlo"; exit 3; }
    fi
    uno=$(pide "Dato privado del negocio" "Escribe $campo de $elemento. No se ve ni le llega al asistente; se guarda en tu 1Password.")
    c=$?; [ $c -eq 3 ] && { echo "error: esta compu no tiene cómo abrir la ventanita (falta zenity o kdialog)"; exit 2; }
    [ -z "$uno" ] && { echo "cancelado"; exit 1; }
    dos=$(pide "Dato privado del negocio" "Escríbelo otra vez para confirmar.")
    [ "$uno" = "$dos" ] || { echo "error: los dos no coinciden; no se guardó nada"; exit 2; }
    if [ "$visible" = "visible" ]; then tipo=STRING; tipo_op=text; else tipo=CONCEALED; tipo_op=password; fi
    if [ "$existe_elemento" = no ]; then
      printf '{"title":"%s","category":"SECURE_NOTE","fields":[{"id":"notesPlain","type":"STRING","purpose":"NOTES","label":"notesPlain","value":"Guardado por el asistente del negocio con la ventanita."},{"id":"%s","type":"%s","label":"%s","value":"%s"}]}' \
        "$(json_texto "$elemento")" "$(json_texto "$campo")" "$tipo" "$(json_texto "$campo")" "$(json_texto "$uno")" \
        | op item create --vault "$cajon" - >/dev/null 2>&1
    else
      nombre=$(printf '%s' "$campo" | sed 's/\\/\\\\/g; s/\./\\./g; s/=/\\=/g')
      op item edit "$elemento" --vault "$cajon" "$nombre[$tipo_op]=$uno" >/dev/null 2>&1
    fi
    ok=$?
    uno=""; dos=""
    [ $ok -eq 0 ] || { echo "error: 1Password no lo aceptó; revisa que la llave de servicio pueda escribir en el cajón $cajon"; exit 2; }
    echo "guardado"; exit 0 ;;

  *)
    echo "uso: ventanita.sh dato <cajon> <elemento> <campo> [visible] | llave | existe <cajon> <elemento> <campo>"; exit 2 ;;
esac
