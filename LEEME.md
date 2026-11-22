# Tu cerebro de negocio

Esta carpeta es la memoria de tu negocio para tu asistente de IA. La abres en Claude Code o en Codex y el asistente te conoce solo: revisa, con tu permiso, tus documentos, tus conversaciones anteriores con la IA, tu correo y lo que hay de tu negocio en internet; guarda lo que aprende ordenado por temas; te pregunta solo lo que falta, y mejora cada vez que lo corriges. Todo queda aquí, en archivos de texto que puedes abrir.

## Antes de abrirla: solo en la compu del dueño

El arranque revisa la compu donde se abre la carpeta: sus documentos, su escritorio, sus descargas, sus carpetas de nube y sus conversaciones con la IA. **No la abras en una compu ajena** (la de un empleado, una prestada, una compartida o la de quien te la instaló): revisaría las cosas de esa persona y las mezclaría con tu negocio. Ábrela en tu compu, con tu cuenta.

Déjala en un lugar fijo, por ejemplo dentro de Documentos, y no la metas dentro de otra carpeta de trabajo que use Git.

El cerebro necesita el modelo mediano o uno mayor (en Claude, Sonnet u Opus); con el modelo chico (Haiku) no alcanza para crear empleados.

## Cómo abrirla en Claude Code

1. Si te llegó en un ZIP, descomprímelo (en Windows, clic derecho y «Extraer todo»; en Mac, doble clic). No trabajes dentro del ZIP.
2. Abre la app de escritorio de Claude, entra a la pestaña **Code** y elige esta carpeta como carpeta de trabajo. También sirve la terminal: entra a la carpeta y escribe `claude`. La versión web (claude.ai en el navegador) no puede tocar archivos de tu compu.
3. Escribe `/arranque`, «conóceme» o solo «hola».
4. Claude Code te va a pedir permiso para entrar a cada carpeta fuera de esta y para algunas acciones. Lee qué pide y apruébalo si estás de acuerdo.

## Cómo abrirla en Codex

Codex quedó configurado según su documentación, pero **todavía no se ha probado** con este cerebro.

1. Abre esta carpeta en Codex (la app, la extensión de VS Code o la terminal, con `codex` dentro de la carpeta).
2. Cuando Codex pregunte si confías en la carpeta, di que sí. Si la marcas como no confiable, Codex no lee `AGENTS.md` ni `.codex/config.toml`, y el cerebro no funciona.
3. Escribe «conóceme», `/arranque` o `$arranque`. Con `/skills` ves las rutinas.

Lo que dice la documentación de Codex y cómo lo usamos:

- Codex lee `AGENTS.md` por su cuenta, desde la raíz del proyecto hasta la carpeta donde lo abres, y corta lo que pase de 32 KiB en total. Este `AGENTS.md` mide unos 17 KiB. Si la carpeta está dentro de otra que usa Git, Codex también leería el `AGENTS.md` de esa otra: por eso conviene dejarla suelta.
- Encuentra las rutinas en `.agents/skills/<rutina>/SKILL.md`. Cada ficha solo apunta a la rutina de `sistema/rutinas/`.
- Usa `.codex/config.toml` solo si confías en la carpeta. Ahí este cerebro pone dos cosas: que Codex escriba solo dentro de la carpeta y que pida permiso para lo demás.
- Codex no tiene aquí un candado para archivos de claves. Su documentación muestra perfiles de permisos que niegan lecturas, pero no confirma cómo se escriben en la versión que está repartida ni si funcionan en Windows, y un ajuste mal escrito puede impedir que Codex arranque. Esa protección queda en las reglas de `AGENTS.md`, que el asistente sigue igual.
- Codex guarda sus conversaciones en `~/.codex/sessions/`; el arranque las lee de ahí con la herramienta de `sistema/herramientas/`.

## Qué revisa el arranque y qué no

Antes de abrir nada fuera de esta carpeta, el asistente te dice qué va a revisar y te da tres opciones: «Adelante», «Solo algunas carpetas» o «No revises mi compu». Ese aviso sale siempre, aunque tengas prisa. Si cierras a la mitad, la siguiente sesión sigue donde se quedó.

**Sí revisa:**

- Las carpetas de tu usuario: Documentos, Escritorio, Descargas, Imágenes, las de nube sincronizadas (OneDrive, Google Drive, Dropbox, iCloud Drive) y las demás que por su nombre sean del negocio. Primero mira solo los nombres; lo que parece del negocio lo lee por tandas de diez, unos cincuenta documentos por sesión, y el resto en las sesiones siguientes.
- Tus conversaciones anteriores con Claude Code y Codex que estén en esta compu, para aprender cómo escribes, qué correcciones le haces a la IA y qué le pides seguido. Las lee en pantalla, por partes, sin copiarlas a ningún archivo. Las de claude.ai, Cowork y ChatGPT no las ve solo: te da un texto para pedirle a esa app un resumen.
- Los conectores que tenga tu app, como el correo: solo para leer y solo de los últimos 90 días. Las carpetas personales no las abre; las del negocio (también las del banco o el contador del negocio) las lee enteras; en las que mezclan las dos cosas, como Recibidos, mira el remitente y el asunto de cada correo y abre solo los del negocio; los personales solo los cuenta. Después del arranque, cada vez que busque algo en tu correo, sigue igual.
- La página, las redes y la ficha de Google Maps de tu negocio. Si no encuentra nada, te pregunta si tienes.

**No revisa:**

- El resto de la compu: ni carpetas del sistema, ni de programas, ni `AppData` o `Library`, ni carpetas ocultas.
- Lo que parece personal por su nombre (familia, salud, tu banco personal, escuela, viajes, fotos): ni lo abre. Lo del banco o la contabilidad del negocio sí es del negocio.
- Archivos de contraseñas o claves (`.env`, `.pem`, `.key`, nombres con «contraseña», «claves» o «credenciales»): ni los abre.
- Lo que no es del negocio: si lo abrió y resultó ajeno, no guarda nada.

Después te hace diez preguntas como mucho, de tres en tres, y antes de la primera te dice cuántas son: lo que ya vio en tus archivos o correos te lo pide confirmar («vi que…, ¿sigue así?») y te pregunta abierto solo lo que nada de eso responde (a quién le vendes, cómo quieres que suene tu marca), siempre con «no sé» y «luego». Cierra con lo que sabe de tu negocio, qué tan lleno quedó cada tema, las rutinas que vio en tus conversaciones, tres ideas para empezar a usarlo y el **DNA de tu negocio** en `trabajo/`. Si te vas antes de terminar, cierra con lo que ya tiene, te deja el DNA y te dice qué preguntas quedan para cuando quieras. heyyou es quien te instaló este asistente; mandarle ese DNA lo decides tú.

## Tu privacidad

- Lo que el asistente lee pasa por Anthropic (si usas Claude Code) o por OpenAI (si usas Codex) para entenderlo, igual que cualquier mensaje que le escribes, según las condiciones de tu plan. No lo sube a ningún otro lado.
- Lo que aprende se queda en esta carpeta, en tu compu. Si la guardas dentro de una carpeta de nube, se respalda en tu nube como cualquier archivo.
- No guarda contraseñas, claves, números de tarjeta o de cuenta, identificaciones ni expedientes médicos, aunque vengan en un documento del negocio o se los dictes. Tus claves viven solo en tu 1Password: tú las escribes en un cuadro aparte que el asistente no ve, y él las usa sin verlas. Del mapa de accesos solo guarda con qué cuenta entras y cómo se llama la clave en tu 1Password.
- De tu vida solo guarda lo que toca al trabajo («los martes no está»).
- Si dices «no guardes eso», lo borra y te dice qué quitó.
- Mandar, publicar, pagar, comprar, borrar algo fuera de esta carpeta, instalar programas, conectar cuentas y programar tareas: siempre te pregunta antes. La única excepción es 1Password, donde viven tus claves: lo instala avisándote, sin preguntar. Necesitas tu propia cuenta de 1Password (es de paga).

## Qué hay en la carpeta

| Carpeta o archivo | Qué guarda |
| --- | --- |
| `AGENTS.md` | Las reglas del asistente. `CLAUDE.md` solo apunta ahí. |
| `conocimiento/` | Lo que sabe de tu negocio, por temas. `conocimiento/_mapa.md` dice qué tan lleno está cada tema. |
| `entrada/` | Suelta aquí lo que quieras que conozca; él lo ordena. |
| `trabajo/` | Lo que te entrega: reportes, páginas, presentaciones, el DNA. `trabajo/_indice.md` los lista. |
| `fuentes/` | Tu logo, folleto y fotos, y de dónde salió cada dato. |
| `empleados/` | Catorce puestos de ejemplo, como un cotizador o un asistente, y los que el asistente arme a la medida de tu negocio. |
| `sistema/` | Lo de la casa: el estado, las rutinas (arranque, DNA, repaso, entregables, empleados, correcciones y automatizaciones), las herramientas y las libretas de lo que aprende. |

## Los candados de Claude Code

`.claude/settings.json` hace dos cosas y no necesita nada instalado:

- No deja que Claude Code lea con sus herramientas de lectura archivos de claves por su nombre (`.env`, `.pem`, `.p12`, `.kdbx`, nombres con «token», «secret» o «llave», entre otros), dentro de esta carpeta y de tu carpeta personal, ni las conversaciones guardadas en `~/.claude/projects/` y `~/.codex/sessions/`: esas se leen solo con el extractor. No alcanza a la consola: un `cat` o un programa que lea por su cuenta no pasa por este candado. La protección de fondo son las reglas de `AGENTS.md` (punto 5); el candado es un extra.
- Te pide permiso antes de cambiar las reglas: `AGENTS.md`, `CLAUDE.md`, `sistema/rutinas/`, `.claude/`, `.agents/` y `.codex/`.

Además, unas alarmas (`sistema/alarmas/`) corren solas en Claude Code: no dejan escribir claves, tarjetas ni identificaciones en las notas, ni guardar fuera de esta carpeta, ni sacar claves de 1Password por la consola, y al terminar cada turno revisan que te avise lo que guardó. Corren en Windows con Git, en Mac y en Linux, sin instalar nada.

Son un extra. Si tu app no los corre, las reglas de `AGENTS.md` valen igual. Si un archivo del negocio tiene «claves» en el nombre (por ejemplo, «palabras-claves.docx»), el asistente no lo podrá abrir: cámbiale el nombre o pega su contenido en el chat.

## Cómo se usa después

- Platica normal. Cuando aprende algo te avisa en una línea («Guardé: … → ruta»).
- Corrígelo cuando se equivoque: cada corrección se vuelve regla. Si corriges el trabajo de un empleado o algo que te entregó, sigue la rutina `corregir-chamba`: primero apunta tu corrección en la ficha de ese empleado, tal como la dijiste y solo para lo que la dijiste; luego lo rehace en ese momento, te lo enseña completo y el empleado lo recuerda para la siguiente vez. Todas tus correcciones quedan además en una sola lista, y al abrir cada sesión te dice cuántas son y cuáles.
- Si pides algo con cierta forma, te lo entrega así, con todo lo que pediste que llevara; si cree que algo mejoraría o sobra, te lo sugiere en una línea en vez de cambiarlo o quitarlo solo.
- Cuando hay un paso siguiente, te lo sugiere en una línea al final («Sugiero…», «Puedo seguir con…»); solo te pregunta lo que únicamente tú sabes. Te habla de tú o de usted según le escribas, sin mezclar.
- Suelta documentos en `entrada/`.
- Una vez a la semana te propone un repaso de quince minutos.
- Pide lo que necesites: un reporte, una página, una presentación. Queda en `trabajo/`.
- Si pides algo que se va a repetir o que haría alguien de oficio (cotizar, dar seguimiento, llevar tus cuentas, publicar en tus redes), o quieres que alguien se encargue de algo («quiero quien conteste las cotizaciones»), el asistente arma un empleado para eso y hace con él la primera chamba, aunque no le digas «empleado». Los catorce puestos de `empleados/` son ejemplos para empezar, no una lista cerrada: si ninguno sirve para lo que pides, crea uno nuevo para tu negocio y te dice en una frase por qué ese puesto. Antes de enseñarte una chamba, la revisa contra lo que pediste, y te la enseña completa en el mismo mensaje.

## Si algo no funciona

- **No arrancó solo:** escribe `/arranque` o «lee AGENTS.md».
- **Dice que no puede guardar:** revisa que abriste la carpeta ya extraída, no el ZIP, y que le diste permiso de editar.
- **No ve tus archivos:** confirma que esta carpeta es la carpeta de trabajo de la sesión.

La versión de este cerebro y qué archivos son tuyos está en `sistema/version.md`.
