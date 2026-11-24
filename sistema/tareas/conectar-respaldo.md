# Tarea de una vez: dejar el respaldo en línea

Para qué sirve: conectar, una sola vez, esta carpeta con un repositorio privado del dueño en GitHub, para que `sistema/alarmas/sincronizar.sh` guarde, suba y baje sus cambios solo, y el cerebro sea el mismo en todas sus compus. Mientras esto no esté hecho, la sincronización no hace nada. La llama la fase `cierre` del arranque y también cualquier sesión en la que el dueño pregunte por el respaldo o use una segunda compu. Cuando todo sale bien, este archivo se borra. Al dueño se le habla en palabras llanas: «el respaldo en línea, una copia privada de tu cerebro en tu cuenta de GitHub que solo tú ves»; nada de «origin», «repo», «push» ni nombres de archivos.

Tres reglas que no se rompen en ningún paso:

- **El repositorio es privado, siempre.** Si no puedes comprobar que lo es, no subas nada.
- **Nunca pidas una contraseña, un código ni un token por el chat.** Si hace falta entrar a GitHub, el dueño lo hace en la ventana de su navegador o en la que abra git; tú no ves nada de eso. Si los pega en el chat, no los uses, dile que no hacía falta y que lo cambie en GitHub.
- **Crear una cuenta, un repositorio o conectar una cuenta pide su «sí» antes**, en ese turno. Tú no creas cuentas ni pagas nada.

## Antes de todo · ¿ya quedó conectada?

Compara `git remote get-url origin` con el renglón `remoto_permitido=` de `sistema/sincronizar.conf`, sin el usuario que vaya antes de `github.com`, sin `.git` al final y sin distinguir mayúsculas. Si coinciden y `GCM_INTERACTIVE=never GIT_TERMINAL_PROMPT=0 git ls-remote origin` entra sin pedir nada (ni abrir ventanas), la carpeta ya está conectada (por ejemplo, con el comando del wizard de heyyou): haz lo de «Al terminar» y borra este archivo sin preguntarle nada al dueño y sin seguir con las partes de abajo.

## Parte 1 · Preparar la carpeta (sin preguntar)

1. Si `CEREBRO_SINCRONIZAR=0` está puesta en esta compu (en `.claude/settings.local.json` o en las variables del sistema), la sincronización está apagada a propósito: no sigas, apunta en `pendientes` `Respaldo: apagado en esta compu (CEREBRO_SINCRONIZAR=0)` y no borres esta tarea.
2. Revisa `git --version`. Si no hay git, apunta en `pendientes` `Respaldo: falta git en esta compu` y díselo al dueño en una línea.
3. Si la carpeta no tiene `.git`: `git init -b main` (si esa versión de git no acepta `-b`, `git init` y luego `git symbolic-ref HEAD refs/heads/main`).
4. Mira `git remote get-url origin`. Si apunta a la plantilla de heyyou (`heyyou-cc/AI-Brain`, en cualquier forma), quítalo: `git remote remove origin`. Nunca subas nada a la plantilla, ni para probar.
5. Revisa que `.gitignore` siga en la carpeta y que `git status --short` no traiga nada de `entrada/`, de `fuentes/` (salvo `_registro.md`) ni archivos de claves. Si trae algo así, no sigas: díselo al dueño en una línea y apúntalo en `pendientes`.

## Parte 2 · El repositorio del dueño (necesita al dueño, una vez)

Si el dueño ya se fue, déjala para otra sesión; apúntalo en `pendientes`: `Respaldo: falta conectarlo (sistema/tareas/conectar-respaldo.md, parte 2)`.

Primero: **si heyyou le dio un enlace del wizard** (su página del taller), que lo conecte desde ahí. Dile que en el paso «GitHub» de esa página elija o cree su copia privada, apriete «Dame el comando» y lo pegue en la terminal, no en el asistente: ese comando conecta la carpeta y hace la primera subida. No crees otro repositorio. Cuando termine, revisa otra vez «Antes de todo». Solo si no tiene ese enlace, sigue con el paso 1.

1. Pregúntale una sola cosa: si heyyou ya le dio la dirección de su respaldo, o si quiere que lo cree en su cuenta de GitHub. Si no tiene cuenta, dile que la abra en github.com (es gratis) y que te avise.
2. **Si heyyou se lo dio ya creado:** pídele la dirección (por ejemplo `https://github.com/su-cuenta/su-cerebro.git`). Comprueba que es privado: con `gh repo view <cuenta>/<nombre> --json visibility` debe decir `PRIVATE`; si no tienes `gh`, pídele a heyyou que lo confirme. Si es público o no se puede saber, no sigas.
3. **Si lo creas tú:** dile en una línea qué vas a hacer y espera su «sí»: «Voy a crear en tu cuenta de GitHub un lugar privado llamado cerebro-<negocio> para el respaldo; solo tú lo ves. ¿Va?».
   - Si no hay `gh` (`gh --version`), la herramienta de GitHub, pídele que su «sí» cubra también instalarla, y luego: Windows `winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements`; Mac con Homebrew `brew install gh`; Linux, solo desde https://cli.github.com.
   - Si `gh auth status` dice que no hay sesión, conectar su cuenta también pide su «sí». Luego corre `gh auth login --web --git-protocol https` y dile: «Se abre tu navegador: entra a GitHub ahí y aprieta Autorizar. Yo no veo tu clave». Después, `gh auth setup-git`.
   - Créalo: `gh repo create <cuenta>/cerebro-<negocio> --private`. Comprueba con `gh repo view <cuenta>/cerebro-<negocio> --json visibility` que dice `PRIVATE`.
4. Ponlo como origin: `git remote add origin <dirección>` (o `git remote set-url origin <dirección>` si ya hay uno que no es la plantilla).
5. Escribe esa misma dirección en `sistema/sincronizar.conf`, en el renglón `remoto_permitido=`. Sin esto, la sincronización no sube ni baja.
6. Comprueba que git entra sin preguntar: `git ls-remote origin`. Si pide entrar, deja que se abra la ventana de git o del navegador y que el dueño entre ahí; luego córrelo otra vez.

## Parte 3 · Primera subida y prueba

1. Corre `sh sistema/alarmas/sincronizar.sh subir ya`.
2. Comprueba que subió: `git fetch origin` y luego `git log -1 --oneline origin/main`; debe ser el mismo commit que `git log -1 --oneline` (si la rama no es `main`, usa la que diga `git branch --show-current`).
3. Si no subió, mira la última línea de `sistema/alarmas/sincronizar.log` para saber por qué, y no lo rodees (AGENTS.md, punto 12): no uses `push --force`, `reset` ni otra dirección.

## Al terminar

Si subió: borra este archivo, quita de `pendientes` lo del respaldo, dile al dueño en una línea que su cerebro ya tiene respaldo en línea privado y que se pone al día solo, y apunta en `sistema/bitacora.md`: `- AAAA-MM-DD · Respaldo en línea conectado en <Windows, Mac o Linux> · guardé: la dirección en sistema/sincronizar.conf · pendiente: nada`.

Si algo no quedó: deja esta tarea, apunta en `pendientes` del estado `Respaldo: <en qué paso se quedó> · <por qué, con el error copiado si lo hay>` y díselo al dueño en una línea, en sus palabras.
