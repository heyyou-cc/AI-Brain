# Tarea de una vez: instalar y conectar 1Password en esta compu

Para qué sirve: dejar listo, una sola vez por compu, el 1Password donde viven las claves del negocio, para que el dueño las escriba en la ventanita y el asistente las use con el mesero (`sistema/accesos/_leeme.md`). La llama la fase `cierre` del arranque y también cualquier sesión en la que haga falta una clave y esto no esté hecho. Cuando todo sale bien, este archivo se borra. Al dueño se le habla en palabras llanas: «1Password, la caja fuerte donde viven tus claves»; nada de «ayudante de terminal», «llave de servicio» sin explicar ni nombres de archivos. (El nombre del archivo no dice «1Password» a propósito: los candados de la app no dejan abrir archivos con «password» en el nombre.)

## Parte 1 · Instalar (sin preguntar, solo avisando)

El cerebro viene armado para instalar 1Password (versión 1.9.5 en `sistema/version.md`). Antes de instalar dile en una línea: «Voy a instalar 1Password en tu compu: ahí vivirán tus claves, y yo las usaré sin verlas».

1. Revisa si ya está: `op --version`. Si responde, salta a la parte 2.
2. Windows: `winget install --id AgileBits.1Password.CLI -e --accept-source-agreements --accept-package-agreements`. Luego, en una consola nueva, `op --version`. Si `op` no aparece, búscalo en `<carpeta_personal>/AppData/Local/Microsoft/WinGet/Links/op.exe`.
3. Mac: si tiene Homebrew (`brew --version`), `brew install 1password-cli`. Si no, sigue las instrucciones oficiales de https://developer.1password.com/docs/cli/get-started/ (solo de ese sitio).
4. Linux: sigue las instrucciones oficiales de https://developer.1password.com/docs/cli/get-started/ para su distribución.
5. Si no se pudo instalar, no lo rodees (AGENTS.md, punto 12): apunta en `pendientes` del estado `1Password: no se pudo instalar · <el error, copiado>` y díselo al dueño en una línea. No borres esta tarea.

## Parte 2 · Conectar (necesita al dueño, una vez)

Si el dueño ya se fue, déjala para la siguiente vez que haga falta una clave; apúntalo en `pendientes`: `1Password: falta conectarlo (sistema/tareas/conectar-caja-fuerte.md, parte 2)`.

1. Pregúntale una sola cosa: si ya tiene cuenta de 1Password. Si no tiene, dile que la abra en 1password.com (es de paga; el plan lo elige él) y que te avise. Tú no creas cuentas ni pagas nada.
2. Pídele que en su 1Password haga un cajón llamado **Negocio** (o el nombre que él quiera) para las claves del negocio.
3. Guíalo, paso por paso y en palabras llanas, para crear la llave de servicio en 1password.com: «Developer» → «Service Accounts» (o «Integraciones» → «Cuentas de servicio») → crear una con acceso de **leer y escribir** solo a ese cajón. 1Password le muestra la llave una sola vez: que no la pegue en el chat.
4. Abre la ventanita para que la pegue ahí: Windows `powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/ventanita.ps1 -LlaveDeServicio`; Mac o Linux `sh sistema/accesos/ventanita.sh llave`. Antes de abrirla dile: «Se abre un cuadro aparte; pega ahí la llave dos veces. Yo no la veo».
5. Comprueba: `mesero.ps1 revisar` (o `mesero.sh revisar`). Debe responder y nombrar su cajón.
6. Apunta en `conocimiento/operacion/accesos.md`, en el renglón «Cajón de 1Password del negocio», el nombre del cajón con `[confirmado AAAA-MM-DD]`.

## Al terminar

Si las dos partes salieron bien: borra este archivo, quita de `pendientes` lo de 1Password y apunta en `sistema/bitacora.md`: `- AAAA-MM-DD · 1Password instalado y conectado en <Windows, Mac o Linux> · guardé: el cajón en conocimiento/operacion/accesos.md · pendiente: nada`.
