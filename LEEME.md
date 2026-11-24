# Tu cerebro de negocio

Esta carpeta es la memoria de tu negocio para tu asistente de IA. La abres en Claude Code, en Codex o en GitHub Copilot y el asistente te conoce solo, sin preguntarte antes: revisa tus documentos, tus conversaciones anteriores con la IA, tus conectores (correo, calendario, juntas) y lo que hay de tu negocio en internet; guarda lo que aprende ordenado por temas; te pregunta solo lo que falta, y mejora cada vez que lo corriges. Todo queda aquí, en archivos de texto que puedes abrir.

## Antes de abrirla: solo en la compu del dueño

El arranque revisa la compu donde se abre la carpeta: sus documentos, su escritorio, sus descargas, sus carpetas de nube y sus conversaciones con la IA. **No la abras en una compu ajena** (la de un empleado, una prestada, una compartida o la de quien te la instaló): revisaría las cosas de esa persona y las mezclaría con tu negocio. Ábrela en tu compu, con tu cuenta.

Déjala en un lugar fijo, por ejemplo dentro de Documentos, y no la metas dentro de otra carpeta de trabajo que use Git.

El cerebro necesita el modelo mediano o uno mayor (en Claude, Sonnet u Opus); con el modelo chico (Haiku) no alcanza para armar skills a tu medida.

## Antes de correrlo: aparta lo que no quieras que se vea

El arranque **no te pide permiso**: en cuanto escribes `/arranque` empieza a leer, así que lo que no quieras que lea se aparta antes. Cuatro pautas:

1. **Muévelo fuera de donde busca.** Lo muy privado (papeles de la familia, de tu salud, de tu banco personal, de la escuela, fotos personales) sácalo de Documentos, Escritorio, Descargas y de tus carpetas de nube, por ejemplo a una memoria USB o a una carpeta que no sea de ellas. Si prefieres dejarlo donde está, ponlo en una carpeta con un nombre que lo diga: `Familia`, `Salud`, `Personal`. Las carpetas con nombre personal ni se abren.
2. **Desconecta lo que no quieras que lea.** El asistente usa los conectores que tengas encendidos en tu app (correo, calendario, juntas, notas, almacenamiento). Antes de correrlo, entra a la configuración de la app y apaga los que no quieras que revise. Los usa solo para leer.
3. **Las contraseñas no se abren.** Los archivos de contraseñas o claves (`.env`, `.pem`, `.key`, nombres con «contraseña», «claves» o «credenciales») el arranque no los abre. Aun así, no los dejes sueltos en tus carpetas del negocio: guárdalos en un administrador de contraseñas.
4. **Lo que lee pasa por Anthropic u OpenAI.** Para entenderlo, lo que el asistente lee viaja a Anthropic (si usas Claude Code) o a OpenAI (si usas Codex), igual que cualquier mensaje que le escribes, según las condiciones de tu plan. Lo que aprende se queda en esta carpeta.

Si algo se te pasó, no pasa nada: en cualquier momento dile «eso no» (una carpeta, un archivo, un correo, una persona, un tema) y lo saca de lo que guardó y no lo vuelve a abrir. Queda apuntado en `sistema/exclusiones.md`. Con una honestidad: si ya tienes respaldo en línea (abajo, «Se respalda sola»), el historial del respaldo puede guardar lo que ya se había apuntado antes de que lo sacaras; heyyou puede borrarlo de ahí si se lo pides.

## Cómo abrirla en Claude Code

1. Si te llegó en un ZIP, descomprímelo (en Windows, clic derecho y «Extraer todo»; en Mac, doble clic). No trabajes dentro del ZIP.
2. Abre la app de escritorio de Claude, entra a la pestaña **Code** y elige esta carpeta como carpeta de trabajo. También sirve la terminal: entra a la carpeta y escribe `claude`. La versión web (claude.ai en el navegador) no puede tocar archivos de tu compu.
3. Escribe `/arranque`, «conóceme» o solo «hola». Arranca solo y te va avisando.
4. La app de Claude Code puede pedirte permiso para abrir carpetas, entrar a una fuera de esta o correr algo: es un aviso de la app, no del cerebro. Lee qué pide y apruébalo si estás de acuerdo.

## Cómo abrirla en Codex

Codex quedó configurado según su documentación, pero **todavía no se ha probado** con este cerebro.

1. Abre esta carpeta en Codex (la app, la extensión de VS Code o la terminal, con `codex` dentro de la carpeta).
2. Cuando Codex pregunte si confías en la carpeta, di que sí. Si la marcas como no confiable, Codex no lee `AGENTS.md` ni `.codex/config.toml`, y el cerebro no funciona.
3. Escribe «conóceme», `/arranque` o `$arranque`. Con `/skills` ves las rutinas.

Lo que dice la documentación de Codex y cómo lo usamos:

- Codex lee `AGENTS.md` por su cuenta, desde la raíz del proyecto hasta la carpeta donde lo abres, y corta lo que pase de 32 KiB en total. Este `AGENTS.md` mide unos 22 KiB. Si la carpeta está dentro de otra que usa Git, Codex también leería el `AGENTS.md` de esa otra: por eso conviene dejarla suelta.
- Encuentra las rutinas en `.agents/skills/<rutina>/SKILL.md`. Cada ficha solo apunta a la rutina de `sistema/rutinas/`.
- Usa `.codex/config.toml` solo si confías en la carpeta. Ahí este cerebro pone dos cosas: que Codex escriba solo dentro de la carpeta y que pida permiso para lo demás.
- Además de AGENTS.md y `.codex/config.toml`, Codex lee `.codex/hooks.json` (solo si confías en la carpeta): ahí viven las mismas alarmas que en Claude Code. En Mac corren con `sh`; en Windows, con `sistema/alarmas/correr.ps1`, que busca el `sh` de Git. Abre Codex en la carpeta del cerebro. Codex no sabe preguntar desde un hook, así que ante una carpeta `_privado` frena y le dice al asistente que te pida permiso en el chat. Falta probarlo con Codex de verdad.
- **En Codex, las alarmas no corren hasta que las apruebas.** Codex deja los `hooks` apagados hasta que el dueño los aprueba con el comando `/hooks`, y los vuelve a apagar cuando cambian (por ejemplo, con cada versión nueva del cerebro). Si no los has aprobado, el asistente lo nota (la marca `sistema/alarmas/.ultima-orden` no se actualiza con tu mensaje) y te pide que escribas `/hooks` y apruebes las alarmas. Aprobar es cosa tuya: el asistente no lo hace por ti. Sin ese paso, solo valen las reglas de `AGENTS.md`.
- Las alarmas de Codex no bloquean la lectura de archivos de claves por su nombre: ese bloqueo de lectura (`.env`, `.pem`, nombres con «token» o «llave») es de `.claude/settings.json` y solo vale en Claude Code. En Codex la protección de claves son las alarmas de escritura y las reglas de `AGENTS.md`, que el asistente sigue igual.
- Codex guarda sus conversaciones en `~/.codex/sessions/`; el arranque las lee de ahí con la herramienta de `sistema/herramientas/`.

## Cómo abrirla en GitHub Copilot

GitHub Copilot (CLI y VS Code) lee `AGENTS.md`, `.github/hooks/cerebro.json` (las alarmas) y `.mcp.json` o `.vscode/mcp.json` (el motor de agentes). En Windows hay un paso único: Copilot también lee `.claude/settings.json`, donde los comandos empiezan con `sh`, y PowerShell no lo encuentra. Antes de abrir Copilot corre una vez en PowerShell, dentro de la carpeta: `powershell -NoProfile -ExecutionPolicy Bypass -File sistema/alarmas/correr.ps1 -ArreglarRuta`, y abre Copilot de nuevo. Sin eso, Copilot en Windows no podría usar herramientas. Las alarmas pueden correr dos veces; no pasa nada. Un límite de Copilot: descarta lo que imprime al recibir tu mensaje (`userPromptSubmitted`), así que los avisos de las alarmas y el recordatorio de cómo hablarte le llegan al asistente en el siguiente arranque de sesión o después de su siguiente herramienta; si contesta un mensaje sin usar ninguna, esa respuesta sale sin ellos. Falta probarlo con Copilot de verdad.

## Motor de agentes de heyyou

Con el motor, el asistente configura y publica los agentes de tu cuenta del Hub de heyyou desde el chat (24 herramientas: ver y cambiar el borrador, revisarlo, publicar, restaurar). Publicar llega a tus clientes: el asistente te explica el cambio y espera tu sí. Necesita Node 20 o mayor. La primera vez instala lo que le falta (una sola vez, tarda unos segundos).

Pon tu llave (te la da tu administrador de heyyou; no la pegues en el chat) en la variable `HEYYOU_HUB_KEY`:

- Windows (PowerShell), pega esto y, cuando pida la llave, pégala ahí (no se ve en pantalla ni queda en el historial): `$k = Read-Host 'Pega tu llave' -AsSecureString; [Environment]::SetEnvironmentVariable('HEYYOU_HUB_KEY', [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($k)), 'User')`. Abre de nuevo tu asistente.
- Mac (zsh), pega esto y, cuando pida la llave, pégala ahí (no se ve en pantalla ni queda en el historial): `read -s "k?Pega tu llave: "; echo "export HEYYOU_HUB_KEY=$k" >> ~/.zshrc; unset k`. Abre una terminal nueva. Las apps de escritorio también la leen de ahí.

Por ahora apunta al Hub de desarrollo de heyyou, para validar. Para otro, pon `HEYYOU_HUB_URL` (producción: `https://hub-api.heyyou.cc`) igual que la llave. Sin llave el motor arranca y cada herramienta te dice qué falta.

Cuando heyyou publique el motor en línea, cambia en cada archivo el arranque local por la dirección remota con tu llave en la cabecera `x-api-key`: en `.mcp.json` y `.vscode/mcp.json`, `{"type":"http","url":"https://<direccion>/mcp","headers":{"x-api-key":"${HEYYOU_HUB_KEY}"}}` (en VS Code usa `${env:HEYYOU_HUB_KEY}`); en `.codex/config.toml`, `url` más `env_http_headers = { "x-api-key" = "HEYYOU_HUB_KEY" }` (hay un ejemplo comentado).

## Qué revisa el arranque y qué no

El arranque ya no te hace preguntas para empezar: te saluda, te dice en pocas líneas qué va a hacer y se pone a trabajar. Si cierras a la mitad, la siguiente sesión sigue donde se quedó. Trabaja en **tres vueltas**, y te avisa en cada paso:

1. **Lo que hay en tu compu.** Tus carpetas y tus conversaciones anteriores con la IA, también las de la nube. Al cerrar esta vuelta te enseña lo que va sabiendo.
2. **Tus conectores y herramientas.** Todo lo que tenga conectado tu app (correo, calendario, juntas, notas…), solo para leer. Al cerrarla, te enseña lo nuevo.
3. **Internet.** La página, las redes y la ficha de Google Maps de tu negocio, y lo que se sepa de tus clientes, proveedores y competencia. Al cerrarla, te enseña lo nuevo.

Si en una vuelta salen pistas nuevas (un cliente, un proveedor, una carpeta que nombras y no leyó), hace hasta tres vueltas extra cortas solo con esas.

**Lo que verás.** Avisos cortos mientras trabaja y, al cerrar cada vuelta, **el tablero de las 31 P**: las 31 cosas que ordenan tu negocio (la P31 son tus propios retos como dueño: tiempo, delegar, la IA) (`conocimiento/_30p.md`), con las que ya tienen algo, las que siguen vacías y los temas que más pesan. Lo ves en pantalla; no tienes que contestar para que siga. Si algo no cuadra, o es algo que no quieres que se guarde, dile «eso no» y lo corrige o lo saca en ese momento. Después te hace diez preguntas como mucho, solo de lo que no pudo saber por su cuenta.

**Sí revisa:**

- Las carpetas de tu usuario: Documentos, Escritorio, Descargas, Imágenes, las de nube sincronizadas (OneDrive, Google Drive, Dropbox, iCloud Drive) y las demás que por su nombre sean del negocio. Primero mira solo los nombres; lo que parece del negocio lo lee por tandas de diez, unos cincuenta documentos por sesión, y el resto en las sesiones siguientes.
- Tus conversaciones anteriores con Claude Code y Codex que estén en esta compu, para aprender cómo escribes, qué correcciones le haces a la IA y qué le pides seguido. Las lee en pantalla, por partes, sin copiarlas a ningún archivo.
- Tus conversaciones en claude.ai (web, escritorio y celular) y en ChatGPT: **esas no están en tu compu, hay que bajarlas** (abajo, «Cómo bajar tus conversaciones de claude.ai y ChatGPT»). Te lo recuerda en el arranque y sigue trabajando mientras llegan.
- Los conectores que tenga tu app, como el correo: solo para leer y solo de los últimos 90 días. Las carpetas personales no las abre; las del negocio (también las del banco o el contador del negocio) las lee enteras; en las que mezclan las dos cosas, como Recibidos, mira el remitente y el asunto de cada correo y abre solo los del negocio; los personales solo los cuenta. Después del arranque, cada vez que busque algo en tu correo, sigue igual.
- La página, las redes y la ficha de Google Maps de tu negocio. Si no encuentra nada, te pregunta si tienes.

**No revisa:**

- El resto de la compu: ni carpetas del sistema, ni de programas, ni `AppData` o `Library`, ni carpetas ocultas.
- Lo que parece personal por su nombre (familia, salud, tu banco personal, escuela, viajes, fotos): ni lo abre. Lo del banco o la contabilidad del negocio sí es del negocio.
- Archivos de contraseñas o claves (`.env`, `.pem`, `.key`, nombres con «contraseña», «claves» o «credenciales»): ni los abre.
- Lo que no es del negocio: si lo abrió y resultó ajeno, no guarda nada.

Al final te hace diez preguntas como mucho, de tres en tres, y antes de la primera te dice cuántas son: lo que ya vio en tus archivos o correos te lo pide confirmar («vi que…, ¿sigue así?») y te pregunta abierto solo lo que nada de eso responde (a quién le vendes, cómo quieres que suene tu marca), siempre con «no sé» y «luego». Cierra con lo que sabe de tu negocio, las rutinas que vio en tus conversaciones, tres ideas para empezar a usarlo y el **DNA de tu negocio** en `trabajo/`; antes de conectar el respaldo en línea y de armar ese DNA te pregunta si manda a una carpeta privada lo que pudiera ser sensible (abajo, «Tu carpeta privada»), y al final te enseña una tabla con tus 31 P: qué tan llena está cada una, lo más importante y dónde quedó. Si te vas antes de terminar, cierra con lo que ya tiene, te deja el DNA y te dice qué preguntas quedan para cuando quieras. heyyou es quien te instaló este asistente; mandarle ese DNA lo decides tú.

## Cómo bajar tus conversaciones de claude.ai y ChatGPT

Las conversaciones que tuviste en la web o en el celular viven en esas apps, no en tu compu. Para que el cerebro también aprenda de ellas, pide la exportación (tarda unos minutos u horas en llegar):

- **claude.ai:** entra a claude.ai, Configuración, Privacidad, «Exportar datos». Te llega un correo con un enlace.
- **ChatGPT:** entra a ChatGPT, Configuración, Controles de datos, «Exportar datos». Te llega un correo con un enlace.

Descarga el archivo `.zip` y suéltalo tal como llegó en la carpeta `entrada/` de esta carpeta (no hace falta descomprimirlo). El asistente lo lee solo: toma únicamente lo que tú escribiste, tapa las claves y no copia nada a otro archivo. Como esa exportación trae también cosas personales, al terminar te pregunta si la borra de `entrada/`.

## Se respalda sola

Cuando tengas configurado el repositorio propio de tu cerebro, la carpeta se sincroniza sola: guarda sus cambios y los sube, y baja lo que venga de otro lado, sin que hagas nada. heyyou lo deja listo al entregarte el cerebro. Esa copia es tuya y solo se sube a la dirección que tú tengas configurada.

## Tu privacidad

- Lo que el asistente lee pasa por Anthropic (si usas Claude Code) o por OpenAI (si usas Codex) para entenderlo, igual que cualquier mensaje que le escribes, según las condiciones de tu plan. No lo sube a ningún otro lado. Por eso conviene seguir las pautas de «Antes de correrlo».
- Lo que aprende se queda en esta carpeta, en tu compu. Si la guardas dentro de una carpeta de nube, se respalda en tu nube como cualquier archivo.
- No guarda contraseñas, claves, números de tarjeta o de cuenta, identificaciones ni expedientes médicos, aunque vengan en un documento del negocio o se los dictes. Tus claves viven solo en tu 1Password: tú las escribes en un cuadro aparte que el asistente no ve, y él las usa sin verlas. Del mapa de accesos solo guarda con qué cuenta entras y cómo se llama la clave en tu 1Password.
- De tu vida solo guarda lo que toca al trabajo («los martes no está»).
- Si dices «no guardes eso», lo borra y te dice qué quitó.
- Aunque para leer no te pide permiso, mandar, publicar, pagar, comprar, borrar algo fuera de esta carpeta, instalar programas, conectar cuentas y programar tareas: siempre te pregunta antes. La única excepción es 1Password, donde viven tus claves: lo instala avisándote, sin preguntar. Necesitas tu propia cuenta de 1Password (es de paga).

## Tu carpeta privada

Si algún día compartes tu cerebro (con un socio, con un contador, con quien te lo instaló), hay cosas que no quieres que se vean: datos de salud o de familia, deudas, sueldos de personas, pleitos, problemas personales, datos de tus clientes con nombre y teléfono, tus márgenes, lo que te pesa como dueño. Para eso existe `_privado/`, una carpeta en la raíz del cerebro (y cualquier carpeta que se llame `_privado`, a cualquier nivel, cuenta igual).

- **Nunca se sube a GitHub.** No entra al respaldo en línea.
- **Ningún asistente la abre sin tu permiso.** Antes de leer algo de ahí te pregunta en el chat y espera tu «sí», cada vez y en cada sesión. Buscar no entra: las búsquedas y el arranque la saltan.
- **Se guarda con la misma estructura** que `conocimiento/`: `_privado/conocimiento/<carpeta>/<nota>.md`. En la nota original queda «(hay datos en privado)» y, en el tablero de las 31 P, la fila dice lo mismo, sin repetir el dato.
- **Al cerrar el arranque, antes del respaldo y del DNA**, el asistente junta lo que pudiera ser sensible y te pregunta si lo manda ahí. Puedes decir que sí, que no o elegir uno por uno. Si no contestas, no se conecta el respaldo en línea ni se sube nada, y te lo vuelve a preguntar al empezar la sesión siguiente. También puedes pedirlo cuando quieras: «manda esto a privado».
- La carpeta trae adentro un `_leeme.md` que cuenta lo mismo; a ese archivo tu app también te pregunta antes de abrirlo, así que aquí queda todo explicado.
- **Si una nota dice «(hay datos en privado)»**, lo nuevo de ese tipo va a su gemela privada, con la misma ruta. Cuando una skill necesite esos datos (por ejemplo tus márgenes para cotizar), el asistente te pide permiso en ese momento; nunca vuelve a escribir el dato en la nota que se comparte.

Cómo funciona por dentro: cualquier carpeta llamada `_privado`, a cualquier nivel, es solo tuya. Cuatro candados, que no distinguen mayúsculas (`_Privado` cuenta igual): (1) `.gitignore` no la sube a GitHub, salvo su `_leeme.md`, y la sincronización deja de seguir lo que ya estuviera en git o se moviera ahí con `git mv`; (2) `.ignore` la saca de las búsquedas; (3) en Claude Code y Copilot, leerla pide tu permiso; en Codex, la alarma frena y el asistente te pide permiso en el chat (si dices que sí, tú le pegas el contenido o abres el archivo); (4) escribir ahí, por ejemplo mover algo, se permite. Cuida de descuidos, no de mala fe: un comando armado a propósito puede esquivarla. Tampoco la ve la sincronización con el respaldo.

## Qué hay en la carpeta

| Carpeta o archivo | Qué guarda |
| --- | --- |
| `AGENTS.md` | Las reglas del asistente. `CLAUDE.md` solo apunta ahí. |
| `conocimiento/` | Lo que sabe de tu negocio, por temas. `conocimiento/_30p.md` es el tablero de tus 31 P y `conocimiento/_mapa.md` dice qué tan lleno está cada tema. |
| `entrada/` | Suelta aquí lo que quieras que conozca; él lo ordena. |
| `trabajo/` | Lo que te entrega: reportes, páginas, presentaciones, el DNA. `trabajo/_indice.md` los lista. |
| `fuentes/` | Tu logo, folleto y fotos, y de dónde salió cada dato. |
| `skills/` | Las pericias (skills) que el asistente ya sabe hacer para tu negocio: cotizar, cobrar, contestar clientes, ordenar tu semana, aprender IA y más, y las que arme a tu medida. `skills/_indice.md` las lista; `skills/_recomendadas.md` trae otras de terceros para instalar. |
| `repositorios/` | Un inventario de proyectos abiertos de GitHub que te pueden servir (atender por WhatsApp, automatizar, facturas…), con qué tan difícil es instalar cada uno. El asistente solo te los sugiere. |
| `_privado/` | Tu carpeta privada. Ver abajo. |
| `sistema/` | Lo de la casa: el estado, las rutinas (arranque, DNA, repaso, entregables, crear skills, correcciones, automatizaciones y Higgsfield), las herramientas, `exclusiones.md` (lo que pediste que no se vea) y las libretas de lo que aprende. |

## Los candados y las alarmas

En Claude Code, `.claude/settings.json` hace dos cosas y no necesita nada instalado:

- No deja que Claude Code lea con sus herramientas de lectura archivos de claves por su nombre (`.env`, `.pem`, `.p12`, `.kdbx`, nombres con «token», «secret» o «llave», entre otros), dentro de esta carpeta y de tu carpeta personal, ni las conversaciones guardadas en `~/.claude/projects/` y `~/.codex/sessions/`: esas se leen solo con el extractor. No alcanza a la consola: un `cat` o un programa que lea por su cuenta no pasa por este candado. La protección de fondo son las reglas de `AGENTS.md` (punto 5); el candado es un extra.
- Te pide permiso antes de cambiar las reglas: `AGENTS.md`, `CLAUDE.md`, `sistema/rutinas/`, `.claude/`, `.agents/` y `.codex/`.

Además, unas alarmas (`sistema/alarmas/`) corren solas en Claude Code, Codex y Copilot (`.claude/settings.json`, `.codex/hooks.json` y `.github/hooks/cerebro.json`): no dejan escribir claves, tarjetas ni identificaciones en las notas, ni guardar fuera de esta carpeta, ni sacar claves de 1Password por la consola, frenan la lectura de carpetas `_privado` sin tu permiso y, al terminar cada turno, revisan que te avise lo que guardó. Corren en Windows con Git, en Mac y en Linux, sin instalar nada.

Son un extra. Si tu app no las corre, las reglas de `AGENTS.md` valen igual. Si un archivo del negocio tiene «claves» en el nombre (por ejemplo, «palabras-claves.docx»), el asistente no lo podrá abrir: cámbiale el nombre o pega su contenido en el chat.

## Cómo se usa después

- Platica normal. Cuando aprende algo te avisa en una línea («Guardé: … → ruta»).
- Corrígelo cuando se equivoque: cada corrección se vuelve regla. Si corriges algo que te entregó (un borrador, una cotización, una publicación), sigue la rutina `corregir-chamba`: primero apunta tu corrección en `skills/_aprendizajes.md`, en la sección de la skill que lo hizo, tal como la dijiste y solo para lo que la dijiste; luego lo rehace en ese momento, te lo enseña completo y la skill lo recuerda para la siguiente vez. Todas tus correcciones quedan además en una sola lista, y al abrir cada sesión te dice cuántas son y cuáles.
- Si pides algo con cierta forma, te lo entrega así, con todo lo que pediste que llevara; si cree que algo mejoraría o sobra, te lo sugiere en una línea en vez de cambiarlo o quitarlo solo.
- Cuando hay un paso siguiente, te lo sugiere en una línea al final («Sugiero…», «Puedo seguir con…»); solo te pregunta lo que únicamente tú sabes. Te habla de tú o de usted según le escribas, sin mezclar.
- Suelta documentos en `entrada/`.
- Una vez a la semana te propone un repaso de quince minutos.
- Pide lo que necesites: un reporte, una página, una presentación. Queda en `trabajo/`.
- Si pides algo que se va a repetir o que haría alguien de oficio (cotizar, dar seguimiento, cobrar, publicar en tus redes, contratar), el asistente usa la skill que lo resuelve, aunque no le digas «skill», y te dice cuál en la primera línea. Las de `skills/` son un punto de partida, no una lista cerrada: si ninguna sirve para lo que pides, arma una nueva para tu negocio, la prueba con un caso real y la deja guardada. Si tu cerebro viene de una versión anterior con puestos de ejemplo («empleados»), no se borran solos: te propone convertir cada uno en skill y mueve la ficha vieja a `skills/_viejos/` solo con tu «sí». Antes de enseñarte una chamba, la revisa contra lo que pediste, y te la enseña completa en el mismo mensaje.

## Si algo no funciona

- **No arrancó solo:** escribe `/arranque` o «lee AGENTS.md».
- **Dice que no puede guardar:** revisa que abriste la carpeta ya extraída, no el ZIP, y que le diste permiso de editar.
- **No ve tus archivos:** confirma que esta carpeta es la carpeta de trabajo de la sesión.

La versión de este cerebro y qué archivos son tuyos está en `sistema/version.md`.
