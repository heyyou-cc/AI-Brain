#!/bin/sh
# Alarma de sincronizar (SessionStart, UserPromptSubmit, PostToolUse y Stop en Claude Code y Codex; los mismos eventos en Copilot).
# Mantiene esta carpeta igual que su copia en línea (git), aunque otro asistente la cambie a la vez.
#   bajar        guarda lo de esta compu en un commit y junta lo que haya en línea (merge, nunca rebase).
#   subir        guarda, junta y sube. Si la última subida fue hace menos de 20 s, solo marca pendiente.
#   subir ya     igual, sin esperar (el Stop siempre sube así).
# Choques: las libretas donde solo se agregan renglones (bitácora, golpes, decisiones...) juntan las
# líneas de los dos lados (.gitattributes, merge=union). En lo demás, notas incluidas, deja la versión
# de esta compu y, al lado, la de la otra como <nombre>.remoto.<ext>, cierra el merge y le pide al
# asistente juntarlas a mano. Nunca reset --hard, push --force ni checkout --.
# Solo sube y baja si origin es el repositorio que dice sistema/sincronizar.conf (remoto_permitido=).
# Si origin es la plantilla de HeyYou (o no hay origin ni dirección), no toca nada: ni commit.
# Archivos de más de ~100 MB no entran al respaldo (GitHub no los acepta): quedan en .git/info/exclude.
# Nada de una carpeta _privado (con cualquier mayúscula) sube, salvo su _leeme.md: antes de cada commit se saca
# del índice lo que ya estuviera seguido o llegara con git mv (git rm --cached; el archivo sigue en el disco).
# Si el arranque ya empezó y pregunta_privado (sistema/estado.md) está vacío o «pendiente», no hace nada (ni commit).
# Sin red o sin acceso, sale callada y lo apunta en sincronizar.log.
# Para apagarla en una compu: variable CEREBRO_SINCRONIZAR=0.
# Corre con sh en Mac, Linux y Windows con Git Bash. No necesita instalar nada.

modo="${1:-subir}"
ya="$2"
entrada=""
bloquea=""
[ -t 0 ] || entrada=$(cat)
[ "$CEREBRO_SINCRONIZAR" = "0" ] && exit 0

dir="$CLAUDE_PROJECT_DIR"
[ -d "$dir/sistema" ] || dir=$(cd "$(dirname "$0")/../.." 2>/dev/null && pwd)
cd "$dir" 2>/dev/null || exit 0
mkdir -p "$dir/sistema/alarmas" 2>/dev/null
command -v git > /dev/null 2>&1 || exit 0
log="$dir/sistema/alarmas/sincronizar.log"
apunta() { echo "$(date '+%Y-%m-%d %H:%M:%S') · $modo · $1" >> "$log" 2>/dev/null; }

# Solo si esta carpeta es la raíz de su propio repositorio (no una subcarpeta de otro).
top=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
[ "$(cd "$top" 2>/dev/null && pwd -P)" = "$(pwd -P)" ] || exit 0
gd=$(git rev-parse --absolute-git-dir 2>/dev/null) || exit 0

campo() { printf '%s' "$entrada" | tr -d '\r\n' | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p" | head -n 1; }
evento=$(campo hook_event_name)
# Copilot con eventos en camelCase (sessionStart, postToolUse, agentStop...) no manda hook_event_name:
# se deduce de cómo lo llama .github/hooks/cerebro.json. Por su documentación, solo sessionStart y postToolUse
# toman "additionalContext", agentStop acepta "block" con "reason", y lo que sale de userPromptSubmitted se descarta.
copilot=""
if [ -z "$evento" ]; then
  case "$CEREBRO_AGENTE$entrada" in
    copilot*|*'"toolName"'*|*'"sessionId"'*|*'"toolArgs"'*)
      copilot=si
      case "$modo$ya" in
        subirya) evento=Stop ;;
        subir) evento=PostToolUse ;;
        *) case "$entrada" in *'"prompt"'*) evento=PromptCopilot ;; *) evento=SessionStart ;; esac ;;
      esac ;;
  esac
fi
sesion=$( { campo session_id; campo sessionId; } | head -n 1 | tr -cd 'A-Za-z0-9-' | cut -c1-60)
[ -z "$sesion" ] && sesion=sin-sesion
# Copilot avisa después de CADA herramienta (no tiene filtro por nombre): las que solo leen no cambian nada.
if [ "$modo" = subir ] && [ -z "$ya" ]; then
  herr=$(campo toolName | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz')
  case "$herr" in view|grep|glob|rg|task|web_fetch|ask_user) exit 0 ;; esac
fi
repetido=no
case "$entrada" in *'"stop_hook_active":true'*|*'"stop_hook_active": true'*) repetido=si ;; esac

# Sin ventanas ni preguntas: si git pide usuario o clave, falla y ya.
export GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never GIT_EDITOR=true GIT_MERGE_AUTOEDIT=no
if [ -z "$GIT_SSH_COMMAND" ] && [ -z "$(git config core.sshCommand)" ]; then
  export GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=10"
fi
idn=""
[ -z "$(git config user.email)" ] && idn="-c user.name=Cerebro -c user.email=cerebro@esta-compu"
g() { git -c core.quotepath=false -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 $idn "$@"; }

avisos="$gd/sincronizar-avisos"   # choques por juntar a mano; se entregan en el siguiente evento
err="$gd/sincronizar.err"
traidos="$dir/sistema/alarmas/.traidos"   # lo que llegó de la otra compu en este turno (al-terminar no lo cuenta)

# --- Entregar los avisos al asistente, por el canal de cada evento ---
json() { printf '%s' "$1" | tr -d '\r' | awk 'BEGIN{ORS=""} {gsub(/\\/,"\\\\"); gsub(/"/,"\\\""); gsub(/\t/," "); if (NR>1) print "\\n"; print}'; }
voz_copilot="$dir/sistema/estilo/.tmp-copilot"   # lo que al-recibir.sh no pudo entregar en Copilot (descarta lo de userPromptSubmitted)
entrega() {
  texto="$1"
  # Copilot descarta la salida de userPromptSubmitted: ahí no se entrega ni se gasta nada; los avisos esperan al siguiente evento.
  [ "$evento" = PromptCopilot ] && return 0
  if [ "$copilot" = si ] && [ "$evento" != Stop ] && [ -s "$voz_copilot" ]; then
    texto="${texto:+$texto
}$(cat "$voz_copilot")"
    rm -f "$voz_copilot"
  fi
  if [ -s "$avisos" ]; then
    if [ "$evento" = Stop ] && [ "$repetido" = si ]; then
      :   # ya lo frenó una vez: el aviso espera al siguiente mensaje
    else
      texto="$(cat "$avisos")${texto:+
$texto}"
      rm -f "$avisos"
      bloquea=si
    fi
  fi
  [ -z "$texto" ] && return 0
  case "$evento" in
    PostToolUse)
      if [ "$copilot" = si ]; then printf '{"additionalContext":"%s"}\n' "$(json "$texto")"
      else printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$(json "$texto")"; fi ;;
    Stop) [ "$bloquea" = si ] && printf '{"decision":"block","reason":"%s"}\n' "$(json "$texto")" ;;
    SessionStart) if [ "$copilot" = si ]; then printf '{"additionalContext":"%s"}\n' "$(json "$texto")"; else printf '%s\n' "$texto"; fi ;;
    *) printf '%s\n' "$texto" ;;
  esac
}
sal() { entrega "$1"; exit 0; }

# --- ¿Se puede sincronizar con este origin? ---
limpia() { printf '%s' "$1" | tr -d '\r' | sed 's#://[^/@]*@#://#; s#/*$##; s#\.git$##' | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'; }
url=$(git remote get-url origin 2>/dev/null)
permitido=$(sed -n 's/^[[:space:]]*remoto_permitido[[:space:]]*=[[:space:]]*//p' "$dir/sistema/sincronizar.conf" 2>/dev/null | tr -d '\r' | sed 's/[[:space:]]*$//' | head -n 1)
puede=no
if [ -n "$url" ] && [ -n "$permitido" ] && [ "$(limpia "$url")" = "$(limpia "$permitido")" ]; then puede=si; fi
# La plantilla nunca recibe datos de un dueño, ni siquiera en un commit que otro push subiría después.
plantilla=no
case "$(limpia "$url")" in *[/:]heyyou-cc/ai-brain|heyyou-cc/ai-brain) puede=no; plantilla=si ;; esac
[ -z "$url" ] && [ -z "$permitido" ] && plantilla=si

aviso_remoto() {
  [ "$puede" = si ] && return 0
  marca="$gd/sincronizar-avisado-$sesion"
  find "$gd" -maxdepth 1 -name 'sincronizar-avisado-*' -mtime +7 -exec rm -f {} \; 2>/dev/null
  [ -f "$marca" ] && return 0
  touch "$marca"
  if [ "$plantilla" = si ]; then
    que="la sincronización no hace nada (ni guarda en git, ni sube, ni baja), porque esta carpeta sigue unida a la plantilla de HeyYou o a ningún repositorio"
  else
    que="los cambios se guardan en esta compu (commit local), pero no se suben ni se bajan de internet, porque origin no coincide con remoto_permitido de sistema/sincronizar.conf"
  fi
  echo "Sincronización del cerebro: $que. Aún falta conectar el repositorio propio del dueño: se hace con sistema/tareas/conectar-respaldo.md (en el cierre del arranque, o cuando el dueño lo pida). No subas nada a mano al repositorio de la plantilla. Si el dueño pregunta por el respaldo en línea, dile en sus palabras que aún no está conectado; no le pases la decisión técnica."
}

if [ "$plantilla" = si ]; then   # sin repositorio propio: no se toca nada, solo se avisa una vez por sesión
  [ "$modo" = bajar ] && entrega "$(aviso_remoto)"
  exit 0
fi

# --- Primero la pregunta de privacidad ---
# Mientras el arranque va en curso o ya cerró, y el dueño no ha contestado qué va a la carpeta privada
# (pregunta_privado vacío o «pendiente» en sistema/estado.md), no se guarda en git, ni se sube, ni se baja:
# un commit con lo sensible subiría después con todo y su historia. Con sin-empezar o sin estado, sigue normal.
estado_f="$dir/sistema/estado.md"
if [ "$puede" = si ] && [ -f "$estado_f" ]; then
  fase_a=$(sed -n 's/^-[[:space:]]*fase_arranque:[[:space:]]*//p' "$estado_f" | tr -d '\r' | sed 's/[[:space:]]*$//' | head -n 1)
  priv_a=$(sed -n 's/^-[[:space:]]*pregunta_privado:[[:space:]]*//p' "$estado_f" | tr -d '\r' | sed 's/[[:space:]]*$//' | head -n 1)
  case "$fase_a" in
    ''|sin-empezar) ;;
    *) case "$priv_a" in
         hecha*) ;;
         *)
           if [ "$modo" = bajar ]; then
             marca="$gd/sincronizar-avisado-priv-$sesion"
             if [ ! -f "$marca" ]; then
               touch "$marca"
               apunta "en pausa: falta la pregunta de privacidad (pregunta_privado)"
               entrega "Sincronización del cerebro: está en pausa (no guarda, no sube ni baja) hasta que el dueño conteste la pregunta de privacidad del cierre del arranque (pregunta_privado en sistema/estado.md; AGENTS.md, punto 1). No la rodees ni subas nada a mano."
             fi
           fi
           exit 0 ;;
       esac ;;
  esac
fi

# --- Candado: una sincronización a la vez en esta compu ---
candado="$gd/sincronizar.lock"
toma() {
  i=0
  while ! mkdir "$candado" 2>/dev/null; do
    find "$gd" -maxdepth 1 -name sincronizar.lock -mmin +2 -exec rm -rf {} \; 2>/dev/null   # huérfano
    i=$((i + 1))
    [ "$i" -ge "${SINCRONIZAR_ESPERA:-8}" ] && return 1
    sleep 1
  done
  trap 'rm -rf "$candado" "$err"' EXIT
  return 0
}

ocupado() { # git a media operación que no es nuestra: no se toca
  [ -d "$gd/rebase-merge" ] || [ -d "$gd/rebase-apply" ] || [ -f "$gd/CHERRY_PICK_HEAD" ] || [ -f "$gd/REVERT_HEAD" ] || [ -f "$gd/BISECT_LOG" ]
}

grandes() { # archivos de más de ~100 MB que git add metería (GitHub rechaza la subida entera por uno)
  find . -path ./.git -prune -o -type f -size +"${SINCRONIZAR_GRANDE:-100000}"k -print 2>/dev/null | sed 's#^\./##' | while IFS= read -r f; do
    [ -z "$f" ] && continue
    if g ls-files --error-unmatch -- ":(literal)$f" > /dev/null 2>&1; then echo "$f"
    elif ! g check-ignore -q -- "$f" 2>/dev/null; then echo "$f"; fi
  done
}

prepara() { # git add -A, sin los archivos grandes; a esos los avisa una vez
  lista=$(grandes)
  set --
  if [ -n "$lista" ]; then
    vistos="$gd/sincronizar-grandes"
    nuevos=""
    mkdir -p "$gd/info" 2>/dev/null
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      if g ls-files --error-unmatch -- ":(literal)$f" > /dev/null 2>&1; then
        set -- "$@" ":(exclude,literal)$f"   # ya estaba en git: no se vuelve a preparar
      else   # nuevo: git lo ignora desde ya (excluirlo por pathspec haría fallar git add)
        grep -qxF "/$f" "$gd/info/exclude" 2>/dev/null || printf '/%s\n' "$f" >> "$gd/info/exclude"
      fi
      if ! grep -qxF "$f" "$vistos" 2>/dev/null; then
        printf '%s\n' "$f" >> "$vistos"
        nuevos="$nuevos
- $f"
      fi
    done <<EOF
$lista
EOF
    if [ -n "$nuevos" ]; then
      {
        echo "Sincronización del cerebro: estos archivos pesan más de 100 MB y no van al respaldo en línea (el servicio no acepta archivos tan grandes); se quedan solo en esta compu:$nuevos"
        echo "Díselo al dueño en una línea, en sus palabras, y no intentes subirlos de otra forma."
      } >> "$avisos"
      apunta "archivos grandes fuera del respaldo:$(printf '%s' "$nuevos" | tr '\n' ' ')"
    fi
  fi
  quita_privadas
  g add -A -- . "$@" > /dev/null 2> "$err"
}

quita_privadas() { # nada de una carpeta privada va a git (salvo su _leeme.md), aunque ya estuviera seguido o llegara con git mv
  mkdir -p "$gd/info" 2>/dev/null
  # Por si el .gitignore de esta compu es de una versión vieja: la misma regla, sin distinguir mayúsculas, en .git/info/exclude.
  for regla in '**/_[Pp][Rr][Ii][Vv][Aa][Dd][Oo]/*' '!**/_[Pp][Rr][Ii][Vv][Aa][Dd][Oo]/_leeme.md'; do
    grep -qxF "$regla" "$gd/info/exclude" 2>/dev/null || printf '%s\n' "$regla" >> "$gd/info/exclude"
  done
  g ls-files 2>/dev/null | awk '{
    n = split(tolower($0), a, "/"); k = 0
    for (i = 1; i < n; i++) if (a[i] == "_privado") k = i
    if (k && !(k == n - 1 && a[n] == "_leeme.md")) print $0
  }' | while IFS= read -r f; do
    [ -z "$f" ] && continue
    g rm --cached -q --ignore-unmatch -- ":(literal)$f" > /dev/null 2>&1 && apunta "dejé de seguir un archivo de una carpeta privada (sigue en esta compu): $f"
  done
  return 0
}

guarda() {
  prepara || { apunta "no pude preparar los cambios: $(head -c 200 "$err" | tr '\n' ' ')"; return 1; }
  if g diff --cached --quiet 2>/dev/null; then return 0; fi
  g commit -q -m "cerebro: guardado automático $(date '+%Y-%m-%d %H:%M')" > /dev/null 2> "$err" \
    || { apunta "no pude guardar el commit: $(head -c 200 "$err" | tr '\n' ' ')"; return 1; }
}

nombre_remoto() { # ruta -> ruta de la copia de la otra compu
  d=$(dirname "$1"); b=$(basename "$1")
  case "$b" in
    ?*.*) n="${b%.*}"; e=".${b##*.}" ;;
    *) n="$b"; e="" ;;
  esac
  c="$n.remoto$e"
  [ -e "$d/$c" ] && c="$n.remoto-$(date '+%Y%m%d%H%M%S')$e"
  if [ "$d" = . ]; then echo "$c"; else echo "$d/$c"; fi
}

resuelve() { # cierra un merge en choque sin perder ninguno de los dos lados
  lista=$(g diff --name-only --diff-filter=U 2>/dev/null)
  hechos=""
  if [ -n "$lista" ]; then
    hechos=$(printf '%s\n' "$lista" | while IFS= read -r f; do
      [ -z "$f" ] && continue
      mkdir -p "$(dirname "$f")"
      if g cat-file -e ":3:$f" 2>/dev/null && g cat-file -e ":2:$f" 2>/dev/null; then
        c=$(nombre_remoto "$f")
        g cat-file blob ":3:$f" > "$c"
        g cat-file blob ":2:$f" > "$f"
        g add -- "$f" "$c" > /dev/null 2>&1
        echo "$f|$c"
      elif g cat-file -e ":3:$f" 2>/dev/null; then   # aquí se borró y allá cambió: vuelve el de allá
        g cat-file blob ":3:$f" > "$f"; g add -- "$f" > /dev/null 2>&1
      elif g cat-file -e ":2:$f" 2>/dev/null; then   # allá se borró y aquí cambió: se queda el de aquí
        g cat-file blob ":2:$f" > "$f"; g add -- "$f" > /dev/null 2>&1
      else
        g rm -q --cached -- "$f" > /dev/null 2>&1
      fi
    done)
  fi
  prepara
  g commit -q --no-edit -m "cerebro: junté cambios de otra compu $(date '+%Y-%m-%d %H:%M')${hechos:+ (por juntar a mano: $(printf '%s\n' "$hechos" | cut -d'|' -f1 | tr '\n' ' '))}" > /dev/null 2> "$err" \
    || { apunta "no pude cerrar el merge: $(head -c 200 "$err" | tr '\n' ' ')"; return 1; }
  if [ -n "$hechos" ]; then
    pares=$(printf '%s\n' "$hechos" | awk -F'|' 'NF==2 {printf "%s- %s (la versión de la otra compu quedó en %s)", (NR>1?"\n":""), $1, $2}')
    {
      echo "Sincronización del cerebro: al juntar los cambios de otra compu, estos archivos chocaron y no se pudieron juntar solos:"
      echo "$pares"
      echo "En cada uno quedó la versión de esta compu. Júntalos a mano ahora: abre los dos, deja en el archivo original la información de los dos lados sin perder nada de ninguno y sin repetir renglones, guarda, y luego borra la copia .remoto."
      case "$(printf '%s\n' "$hechos" | cut -d'|' -f1)" in
        *.md*) echo "En una nota, cada dato queda una sola vez: si los dos lados lo dicen distinto, gana el de marca más alta y, con la misma marca, el más reciente (sistema/clasificacion.md), y el otro baja a «Historia» con su línea. La «Historia» de los dos lados se conserva entera. Un campo de una sola verdad (como fase_arranque en sistema/estado.md) queda una sola vez." ;;
      esac
      echo "No uses git reset, git checkout ni push --force."
    } >> "$avisos"
    printf '%s\n' "$hechos" | cut -d'|' -f2 >> "$traidos"
    apunta "choque en: $(printf '%s\n' "$hechos" | cut -d'|' -f1 | tr '\n' ' ')"
  fi
  return 0
}

mezcla() { # trae lo de internet y lo junta con lo de aquí
  g fetch -q origin 2> "$err" || { apunta "sin red o sin acceso al remoto: $(head -c 200 "$err" | tr '\n' ' ')"; return 1; }
  g rev-parse -q --verify "refs/remotes/origin/$rama" > /dev/null || return 0   # el remoto aún no tiene la rama
  g merge-base --is-ancestor "origin/$rama" HEAD 2>/dev/null && return 0         # nada nuevo
  antes=$(g rev-parse HEAD)
  if ! g merge -q --no-edit -m "cerebro: junté cambios de otra compu $(date '+%Y-%m-%d %H:%M')" "origin/$rama" > /dev/null 2> "$err"; then
    if [ -f "$gd/MERGE_HEAD" ]; then
      resuelve || return 1
    else
      apunta "no pude juntar: $(head -c 300 "$err" | tr '\n' ' ')"
      return 1
    fi
  fi
  # Lo que llegó de la otra compu no lo cambió el asistente en este turno.
  [ -f "$traidos" ] && [ "$dir/sistema/alarmas/.ultima-orden" -nt "$traidos" ] && : > "$traidos"
  g diff --name-only "$antes" HEAD >> "$traidos" 2>/dev/null
  return 0
}

empuja() {
  n=0
  while [ "$n" -lt 3 ]; do
    n=$((n + 1))
    if g rev-parse -q --verify "refs/remotes/origin/$rama" > /dev/null && [ "$(g rev-list --count "origin/$rama..HEAD")" = 0 ]; then return 0; fi
    if g push -q -u origin "$rama" > /dev/null 2> "$err"; then return 0; fi
    case "$(cat "$err" 2>/dev/null)" in *rejected*|*non-fast-forward*|*'fetch first'*|*rechaz*) rechazo=si ;; *) rechazo=no ;; esac
    if [ "$rechazo" = si ]; then
      mezcla || return 1
      continue
    fi
    apunta "no pude subir: $(head -c 200 "$err" | tr '\n' ' ')"
    return 1
  done
  apunta "no pude subir: el remoto siguió cambiando en 3 intentos"
  return 1
}

# --- Debounce: en ediciones seguidas solo marca pendiente ---
ahora=$(date +%s)
if [ "$modo" = subir ] && [ "$ya" != ya ] && [ "$evento" != Stop ]; then
  ultimo=$(cat "$gd/sincronizar.ultimo" 2>/dev/null)
  case "$ultimo" in ''|*[!0-9]*) ultimo=0 ;; esac
  if [ $((ahora - ultimo)) -lt "${SINCRONIZAR_PAUSA:-20}" ]; then
    touch "$gd/sincronizar.pendiente"
    sal ""
  fi
fi

nota=""
[ "$modo" = bajar ] && nota=$(aviso_remoto)
toma || sal "$nota"   # otra sincronización está corriendo: la siguiente lo hará
if ocupado; then apunta "git está a media operación (rebase, cherry-pick...); no toqué nada"; sal "$nota"; fi
rama=$(g symbolic-ref -q --short HEAD) || { apunta "no hay rama (HEAD suelto); no toqué nada"; sal "$nota"; }

if [ -f "$gd/MERGE_HEAD" ]; then resuelve; else guarda; fi
echo "$ahora" > "$gd/sincronizar.ultimo"
rm -f "$gd/sincronizar.pendiente"

if [ "$puede" = si ]; then
  if mezcla && [ "$modo" = subir ]; then empuja; fi
fi
sal "$nota"
