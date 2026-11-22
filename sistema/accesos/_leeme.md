# Accesos: ventanita y mesero

Para qué sirve: que las claves del negocio vivan solo en el 1Password del dueño y que el asistente las use sin verlas nunca. El dueño las escribe en la **ventanita** (un cuadro aparte donde lo que escribe no se ve ni le llega al asistente); el asistente las lleva con el **mesero** (las nombra, 1Password pone el valor). En `conocimiento/operacion/accesos.md` solo se apunta cómo se llama cada una en 1Password (su referencia `op://cajón/elemento/campo`), nunca el valor. AGENTS.md, punto 5.

Cómo abre 1Password el asistente: con una **llave de servicio** de 1Password que el dueño crea una vez y escribe en la ventanita. Esa llave queda en la caja de esta compu: en Windows, cifrada para el usuario (`sistema/accesos/.caja`); en Mac, en el Llavero; en Linux, en el llavero del escritorio o, si no hay, en `sistema/accesos/.caja-linux`, que solo puede leer ese usuario. Ninguna de esas se abre a mano: la alarma de la consola lo frena. Si 1Password todavía no está instalado o conectado, sigue `sistema/tareas/conectar-caja-fuerte.md`.

Necesita el ayudante de terminal de 1Password (`op`). Es lo único que el cerebro instala (decisión del 2026-11-20 en `sistema/decisiones.md`).

## Ventanita

- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File sistema/accesos/ventanita.ps1 -Boveda <cajón> -Elemento "<elemento>" -Campo <campo>` (con `-Visible` si no es secreto, como un usuario). Abre una ventana aparte y espera.
- Mac y Linux: `sh sistema/accesos/ventanita.sh dato <cajón> "<elemento>" <campo> [visible]`. En Mac abre un cuadro del sistema; en Linux usa zenity o kdialog si la compu los trae.
- La llave de servicio, la primera vez: `ventanita.ps1 -LlaveDeServicio` o `ventanita.sh llave`. Antes de guardarla comprueba que 1Password la acepta.
- Saber si un dato ya está, sin verlo: `ventanita.ps1 -Existe -Boveda … -Elemento … -Campo …` o `ventanita.sh existe <cajón> "<elemento>" <campo>`. Responde «si existe» o «no existe».
- Al asistente solo le regresa: `guardado`, `cancelado`, `sin cambios` (ya había valor y el dueño no quiso reemplazarlo) o `error: …`. Si ya había valor, la ventanita le pregunta al dueño antes de reemplazarlo. Cada dato es un campo de un elemento; si el elemento no existe, lo crea.
- Antes de abrirla, dile al dueño en una línea qué va a escribir y que se abre un cuadro aparte. **Nunca le pidas el dato por el chat.** Si lo escribe en el chat de todos modos, no lo repitas ni lo guardes: dile que mejor lo cambie en ese servicio, porque ya pasó por la conversación, y abre la ventanita para el nuevo.

## Mesero

- Revisar que 1Password responde y qué cajones ve la llave (solo nombres): `mesero.ps1 revisar` o `sh sistema/accesos/mesero.sh revisar`.
- Correr un programa con datos de 1Password como variables: `mesero.ps1 correr <archivo-de-referencias> <programa> [argumentos]` (o `mesero.sh correr …`). El archivo de referencias lleva solo renglones `NOMBRE=op://cajón/elemento/campo`, nunca valores; va en `entrada/_paso/` y se borra al terminar. En lo que el programa imprima, 1Password tapa los valores con `<concealed by 1Password>`.
- Llenar el archivo de configuración de otro programa: `mesero.ps1 llenar <plantilla> <archivo-de-salida>`. La plantilla trae `{{ op://cajón/elemento/campo }}`. El archivo de salida queda con los valores: nunca lo abras, lo copies ni lo pegues; solo se lo entregas al programa que lo necesita.

## Lo que no se hace

Usar 1Password directo desde la consola (`op read`, `op item get`, `op run` sin el mesero), imprimir la llave de servicio, abrir su caja o los llaveros del sistema, o volcar las variables del sistema. La alarma de la consola (`sistema/alarmas/antes-de-la-consola.sh`) lo frena; cuida de descuidos, no de mala fe.

Probado en Windows el 2026-11-20 contra un cajón de prueba: revisar, existe, correr (tapa el valor), llenar, reemplazar un valor y la caja cifrada; la versión `.sh`, en Git Bash. La ventana para escribir no la ha usado todavía una persona. En Mac y Linux no se ha corrido.
