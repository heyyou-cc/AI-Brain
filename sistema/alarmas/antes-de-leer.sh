#!/bin/sh
# Alarma antes de leer carpetas privadas (PreToolUse). Cualquier carpeta llamada _privado (sin distinguir
# mayúsculas: _Privado y _PRIVADO cuentan igual), a cualquier nivel del cerebro, es del dueño: el asistente
# no la abre sin su permiso.
# - Herramientas de lectura (Read, Grep, Glob; view y grep de Copilot) con una ruta dentro de _privado.
# - Comandos de consola que leen o copian de _privado: cat, type, Get-Content, grep, head, sed, cut, wc, diff,
#   sort, jq, perl, python, node, awk, cp, mv, una entrada con < ...
# - Comandos que recorren todo el cerebro (grep -r, rg --no-ignore, findstr /s, Get-ChildItem -Recurse con
#   lectura, tar, zip, copias recursivas) cuando existe una carpeta privada con algo más que su _leeme.md.
# Escribir hacia _privado (mover algo ahí, una redirección >) sí se deja: lo pide el dueño.
# El _leeme.md de la carpeta privada queda exento aquí (en Claude Code, su regla "ask" de settings.json igual
# pregunta: un permiso más específico no le gana a un "ask").
# En Claude Code y Copilot pregunta al dueño ("ask"); Codex no sabe preguntar desde un hook, así que ahí
# frena con un mensaje para el asistente. Cuida de descuidos, no de mala fe.
# Corre con sh en Mac, Linux y Windows con Git Bash.

. "$(dirname "$0")/_leer-evento.sh"
ev_leer

motivo="Esa carpeta es privada (_privado)."
motivo_rec="Este comando recorre todo el cerebro y hay una carpeta privada (_privado) con datos del dueño."

# 1. Herramientas de lectura con ruta.
if [ -z "$EV_ESCRIBE" ] && [ -z "$EV_COMANDO" ]; then
  ruta=$(ev_cadena file_path filePath path notebook_path)
  r=$(printf '%s' "$ruta" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz' | sed 's#\\\\#/#g; s#\\#/#g')
  case "/$r/" in
    */_privado/_leeme.md/) exit 0 ;;
    */_privado/*) ev_pregunta "$motivo" ;;
  esac
  exit 0
fi

# 2. Consola.
[ -n "$EV_COMANDO" ] || exit 0
c=$(printf '%s' "$EV_COMANDO" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz' | sed 's#\\\\#/#g; s#\\#/#g')

ini='(^|[[:space:];|&(`"'"'"'])'
fin='([[:space:]]|$)'
lee='(cat|type|get-content|gc|more|less|head|tail|grep|egrep|fgrep|zgrep|rg|findstr|select-string|sls|sed|awk|gawk|strings|xxd|od|hexdump|base64|tar|zip|7z|open|start|code|notepad|python3?|node|sh|bash|source|invoke-item|ii|import-csv|import-clixml|convertfrom-json|get-childitem|gci|ls|dir|find|tree|cut|wc|diff|cmp|sort|uniq|jq|perl|ruby|php|nl|tac|paste|comm|xargs)'
copia='(cp|copy|copy-item|cpi|mv|move|move-item|mi|rsync|robocopy|xcopy)'
lee_net='\[(system\.)?io\.(file|streamreader)\]::(read|open)|new-object[[:space:]]+(system\.)?io\.streamreader'

# 2a. Comandos que recorren todo el cerebro, si hay una carpeta privada con algo más que su _leeme.md.
rec=''
printf '%s' "$c" | grep -Eq "${ini}(grep|egrep|fgrep|zgrep)[[:space:]]+([^|;&]*[[:space:]])?(-[a-z]*r[a-z]*|--recursive|--dereference-recursive)${fin}" && rec=si
printf '%s' "$c" | grep -Eq "${ini}rg[[:space:]]+([^|;&]*[[:space:]])?(--no-ignore[a-z-]*|-uu+|-u${fin})" && rec=si
printf '%s' "$c" | grep -Eq "${ini}findstr[[:space:]]+([^|;&]*[[:space:]])?/[a-z]{0,2}s[a-z]{0,2}${fin}" && rec=si
printf '%s' "$c" | grep -Eq "${ini}(tar|zip|7z|7za|compress-archive)${fin}" && rec=si
printf '%s' "$c" | grep -Eq "${ini}(cp|rsync)[[:space:]]+([^|;&]*[[:space:]])?(-[a-z]*[ra][a-z]*|--recursive|--archive)${fin}" && rec=si
printf '%s' "$c" | grep -Eq "${ini}(copy-item|cpi)[[:space:]]+([^|;&]*[[:space:]])?-rec[a-z]*" && rec=si
printf '%s' "$c" | grep -Eq "${ini}(xcopy|robocopy)${fin}" && rec=si
if printf '%s' "$c" | grep -Eq -- "-rec[a-z]*"; then
  # Get-ChildItem -Recurse solo da nombres; cuenta si además lee (Get-Content, Select-String, ForEach...).
  sn=$(printf '%s' "$c" | sed -E 's/(^|[[:space:];|&(])(ls|dir|find|tree|get-childitem|gci)([[:space:]]|$)/\1 \3/g')
  if printf '%s' "$sn" | grep -Eq "${ini}${lee}${fin}|${ini}(foreach-object|%)${fin}|${lee_net}"; then rec=si; fi
fi
case "$c" in *_privado*) rec='' ;; esac   # si nombra la carpeta privada, lo decide la parte de abajo
if [ -n "$rec" ]; then
  hay=$(find "$EV_RAIZ" \( -name .git -o -name node_modules \) -prune -o -type d -iname '_privado' -print 2>/dev/null | while IFS= read -r d; do
    if [ -n "$(find "$d" -type f ! -iname '_leeme.md' 2>/dev/null | head -n 1)" ]; then echo si; break; fi
  done | head -n 1)
  [ "$hay" = si ] && ev_pregunta "$motivo_rec"
fi

case "$c" in *_privado*) ;; *) exit 0 ;; esac
# Lo que se escribe hacia _privado con > o >> no es una lectura.
c=$(printf '%s' "$c" | sed -E 's/>>?[[:space:]]*[^[:space:];|&]*_privado[^[:space:];|&]*//g')
# El _leeme.md de la carpeta privada se deja pasar.
c=$(printf '%s' "$c" | sed -E 's#[^[:space:];|&<>()"'"'"']*_privado/_leeme\.md##g')
case "$c" in *_privado*) ;; *) exit 0 ;; esac

# Una entrada desde la carpeta privada (< ruta) es una lectura, sea cual sea el comando.
if printf '%s' "$c" | grep -Eq '<[[:space:]]*[^[:space:];|&<>]*_privado'; then
  ev_pregunta "$motivo"
fi
if printf '%s' "$c" | grep -Eq "$lee_net"; then
  ev_pregunta "$motivo"
fi

if printf '%s' "$c" | grep -Eq "${ini}${lee}${fin}"; then
  # ls, dir, find y tree solo muestran nombres: se dejan pasar si no traen otro verbo de lectura.
  sin_nombres=$(printf '%s' "$c" | sed -E 's/(^|[[:space:];|&(])(ls|dir|find|tree|get-childitem|gci)([[:space:]]|$)/\1 \3/g')
  if printf '%s' "$sin_nombres" | grep -Eq "${ini}${lee}${fin}"; then
    ev_pregunta "$motivo"
  fi
fi

if printf '%s' "$c" | grep -Eq "${ini}${copia}${fin}"; then
  # Copiar o mover HACIA _privado (la ruta de _privado es el último argumento) se deja pasar.
  c=$(printf '%s' "$c" | sed 's/[[:space:]]*$//')
  ultimo=${c##*[[:space:]]}
  resto=${c%"$ultimo"}
  case "$resto" in
    *_privado*) ev_pregunta "$motivo" ;;
  esac
  case "$ultimo" in
    *_privado*) ;;
    *) ev_pregunta "$motivo" ;;
  esac
fi

exit 0
