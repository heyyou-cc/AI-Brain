# Rutina: crear-empleado

Esta rutina elige del catálogo de ejemplos el puesto que resuelve lo que pidió el dueño, o crea uno nuevo si ninguno lo resuelve, lo ajusta a este negocio con lo que el cerebro ya sabe y hace su primera chamba como ese empleado.

## Cuándo corre

Cada vez que el dueño pide algo que haría un puesto, aunque no diga «empleado» ni «quiero a alguien» (AGENTS.md, punto 17). Antes de contestar tú en el chat, mira si su pedido es uno de estos:

- **una tarea que se va a repetir:** un corte, un reporte, una respuesta tipo, una revisión que vuelve cada semana o cada mes, aunque hoy la pida por primera vez;
- **algo que hace un oficio:** cotizar, dar seguimiento, llevar cuentas, publicar, comprar, contratar, cobrar, atender quejas…;
- **algo que ya está apuntado** en las «Ideas de puestos» de [empleados/_indice.md](../../empleados/_indice.md) o en la columna «Qué le quita al dueño» de su catálogo: búscalo ahí antes de contestar, con las palabras de su pedido;
- pide a alguien («quiero quien…», «ocupo alguien que…», «busco quien me…»), pide ayuda con algo que se repite («necesito ayuda con…», «¿me ayudas cada semana con…?», «cada que llega… alguien tendría que…») o nombra un puesto.

Si es uno de esos, no lo contestas suelto: sigues esta rutina y la respuesta le llega como la primera chamba del puesto. Una duda de una vez («¿qué día cae el 15?», «arréglame esta frase») se contesta directo. Si dudas, sigue la rutina.

Si el puesto ya está activo, no corres la rutina entera: lees su ficha, empezando por «Aprendizajes», le dices qué empleado lo hace con la frase del paso 2, en corto, haces la tarea como él (con la regla de cálculo de su ficha, si saca cantidades) y, antes de enseñarla, corres la revisión propia (paso 6) y la comparas con la última versión que el dueño corrigió (paso 5 de `sistema/rutinas/corregir-chamba.md`). Si te corrige, abre y sigue `sistema/rutinas/corregir-chamba.md` en ese turno (paso 8).

## Reglas que valen en todos los pasos

- Hablas con el dueño como él escribe (`conocimiento/dueno/como-hablarle.md`), corto y en palabras del negocio. **Lo saludas y lo llamas con el nombre con que pidió que le digan** («Cómo llamarle» de esa nota), también en esta charla. Al explicarle algo o pedirle su «sí», nada de rutas, nombres de archivo ni palabras de taller o de máquina (ficha, carpeta, catálogo, rutina, comando, permiso, terminal, parámetro, el nombre del programa en que trabajas si él no lo usa): una línea que diga qué vas a guardar o hacer y para qué. Así, de tú: «Con tu sí, mando esta cotización al cliente desde tu correo»; de usted: «Con su sí, mando esta cotización al cliente desde su correo». Las frases de ejemplo de esta rutina vienen en forma neutra o en los dos tratos: usa la del trato del dueño.
- **Sugiere, no preguntes.** Lo que sigue va como sugerencia, una sola y al final del mensaje: «Sugiero…» o «Puedo seguir con…». Nunca «¿cómo quedó?», «¿quieres que…?» ni «¿lo ajusto?»: si algo falta, el dueño lo dice. Preguntas solo para datos que la ficha o la chamba necesitan y que solo él sabe.
- **No le enseñes la cocina.** Nunca le cuentes cómo guardaste algo ni con qué («lo agregué con la herramienta de editar», «corrí un comando», «abrí tal archivo»): dile qué quedó, en cosas de su negocio. La única excepción es la línea de «Guardé».
- **Solo este puesto y este trabajo.** Desde el primer mensaje hasta el cierre no tocas otros temas: ni pendientes, ni el repaso, ni el arranque, ni una automatización. Esos ofrecimientos esperan al cierre, en una línea (AGENTS.md, punto 1).
- **Primero la chamba, luego las preguntas.** La primera chamba sale en el turno en que se crea o despierta el puesto, con lo que haya; ningún mensaje antes de ella pide un dato ni un archivo. **Presupuesto fijo de preguntas: una sola tanda de hasta tres, después de enseñar la primera chamba y en ese mismo mensaje (paso 6), y como mucho dos más en todo lo que queda de la charla**, en cada entrega que siga y en el cierre. Cuenta como una pregunta cada cosa que le pides: **cada renglón de una lista de lo que te falta** (una lista de tres datos son tres), cada «pásamelo cuando…», «avísame cuando…», «mándame…», y cada oferta que se te escape en forma de pregunta. **Un dato que pides otra vez cuenta otra vez.** **Antes de cada pregunta, en cualquier paso, búscala en todo `conocimiento/`:** si una nota ya la responde, o dice que eso no existe (si ya sabes que no hay tienda en línea, no preguntes por ella), no se pregunta. Antes de mandar cada mensaje, cuenta las que ya hiciste en esta charla más las que trae ese mensaje; si pasan del presupuesto, quita las de menos peso y deja esos datos como «pendiente».
- **La lista de lo que falta se dice una vez.** Después no se repite en cada turno, ni como recordatorio, ni en una lista al cierre: lo que no contestó se queda «pendiente» en la ficha o en la chamba y no se le vuelve a pedir. Lo mismo lo que dijo que busca o manda después.
- **No preguntes para llenar libretas.** Pregunta solo lo que la ficha o la chamba necesitan para salir. Nada de «¿por qué decidiste…?» o «¿desde cuándo…?» para apuntarlo en algún lado: si tomó una decisión y no dijo por qué, apúntala con «Por qué: no lo dijo» (AGENTS.md, punto 11).
- Solo usas datos del cerebro o de lo que el dueño dijo. Nada de tu cosecha: precios, nombres, horarios, plazos o canales que no están escritos quedan «pendiente».
- **Un caso no es una regla.** Lo que el dueño decidió para un cliente, un pedido o una sola vez se apunta como eso, con su fecha: en la ficha de ese cliente o en la chamba. No lo vuelvas regla del puesto («siempre…», «a todos…», «él siempre lo revisa») si él no lo dijo así.
- Nunca pides contraseñas, claves ni códigos. Si una conexión exige entrar a una cuenta, el dueño entra él mismo.
- El empleado nunca manda, publica, paga ni borra nada solo. Cada una de esas acciones pasa por el «sí» del dueño, dado en esta conversación.
- Todo lo que el empleado entregue va a `trabajo/`. No lo dejas solo en el chat.

## Paso 1 · Leer el cerebro y elegir el puesto

Primero revisas; el puesto se dice después de leer (paso 2). Si quieres avisarle que vas a revisar, va en un mensaje aparte, corto, antes de abrir nada: «Reviso lo que hay de tus visitas y te digo» (de usted: «Reviso lo que hay de sus visitas y le digo»). Si es el primer mensaje de la sesión, el saludo de sesión nueva (AGENTS.md, punto 1) va en ese mensaje aparte, con el nombre con que pidió que le digan. Ni el saludo ni ese aviso van en el mensaje que anuncia el puesto.

Lee `conocimiento/_mapa.md` y, con el mapa, las notas que el puesto necesita: casi siempre `conocimiento/oferta/`, `conocimiento/clientes/` (también **cada ficha de cliente** que toca el pedido, no solo el índice), `conocimiento/reglas-del-negocio.md`, la voz de la marca en `conocimiento/negocio/` y `conocimiento/dueno/`. Lee `empleados/_indice.md`, con su sección «Ideas de puestos», y las fichas del catálogo que podrían resolver el pedido. Mira también qué tiene conectado la app en esta sesión (correo, calendario, hojas en la nube, búsqueda en internet) y lo que dice `conectores` en `sistema/estado.md`; no supongas ninguno.

Las fichas de `empleados/` son un catálogo de ejemplos: sirven de punto de partida, no son la lista cerrada de lo que el negocio puede tener. Busca el puesto que **resuelve** lo que pidió, en este orden: las «Ideas de puestos», las fichas del catálogo y la lista «Otros ejemplos» del índice.

- **Si uno lo resuelve de verdad** (su «Qué le quita al dueño» o su «Qué resuelve en este negocio» cubre lo que pidió, no solo se le parece), despiértalo y ajústalo a este negocio en el paso 5.
- **Si ninguno lo resuelve**, no fuerces el pedido a un puesto que solo se le acerca: crea uno nuevo. Su nombre es el oficio que haría una persona en ese negocio (por ejemplo, «Encargado de compras» para quien pide que el almacén no se quede sin material, o «Agente de cobranza» para quien pide que alguien recuerde los pagos atrasados), y su ficha sigue el «Molde de un puesto nuevo», al final de esta rutina, con todas sus secciones.

## Paso 2 · Anunciar el puesto y por qué

**La primera oración del mensaje que entrega la primera chamba (paso 6), sea el puesto del catálogo o nuevo, es una sola frase de este molde: «Para <lo que pidió, con sus palabras>, el puesto es <puesto>, porque <lo que hace ese puesto que resuelve eso>».** Ese mismo mensaje lleva la frase, luego la pieza completa y luego las preguntas. Ninguna otra frase va antes de ella: ni saludo, ni «voy a revisar…», ni «ya revisé…», ni «Ya quedó…», ni «Guardé…» (la línea de «Guardé» va al final). Si escribiste la frase en un texto antes de guardar, vuelve a ponerla al abrir el mensaje de la entrega. Por ejemplo: «Para que no se encimen las visitas, el puesto es Encargada de agenda, porque acomoda las citas y avisa cuando dos chocan». El nombre del puesto es el oficio que haría una persona en ese negocio. Que la ficha lo diga no basta: la frase va en la charla.

En la misma respuesta sigues con el paso 3. Despertarlo o crearlo es escribir dentro de esta carpeta: no pide su «sí» (AGENTS.md, punto 8). Si dice que no lo quiere, lo dejas dormido (o no lo creas) y haces la tarea suelta.

## Paso 3 · Probar cada conexión, ahora

**Haz la lista de conexiones de esta sesión**, mirando lo que de verdad tienes, no lo que dice la carpeta: cada conector de la app (correo, calendario, documentos en la nube…), la búsqueda en internet si la hay, y cada archivo o carpeta de la compu que el puesto usaría (su hoja de ventas, su lista de precios). **Cada una se intenta leer ahora, aunque el puesto no parezca usarla**: el correo casi siempre trae algo útil para cualquier puesto (avisos de las plataformas donde vende o se anuncia, pedidos, reclamos, cortes del banco del negocio). Solo leyendo: no mandas, no contestas, no borras ni cambias nada.

**El correo, siempre por carpetas** (AGENTS.md, punto 5): las que dice `conectores` en `sistema/estado.md`. Si no están ahí, lista primero las carpetas, sepáralas en personales, del negocio y mixtas con las reglas de la fase `conectores` de `sistema/rutinas/arranque.md` y apúntalas; nunca busques en todo el buzón sin filtro. Las del negocio se leen enteras; en las mixtas (Recibidos, casi siempre) recorre todos los remitentes y asuntos del rango y abre solo lo del negocio, no te quedes con una búsqueda por su nombre. Si aun así te sale algo personal, no lo abres ni lo guardas, y se lo dices en una línea. Fíjate de qué fecha a qué fecha buscaste. **Al decir qué hay, di ese rango** («del 2 al 16 de este mes hay dos pedidos»); antes de decir «el único» o «no hay», busca más atrás, hasta los 90 días. Lo que salga también llena lo que falta (paso 4).

Anótalo en ese momento en «Con qué se conecta» de la ficha, **un renglón por cada conexión de la lista, sin excepción**, con una de estas dos formas:

- `- <conexión> · probada AAAA-MM-DD · leí: «<algo que de verdad salió de ahí: un asunto, una cifra, un nombre>» · busqué: <dónde, y de qué fecha a qué fecha>`
- `- <conexión> · no probada · por qué: <lo que pasó al intentarlo> · mientras: <cómo se trabaja sin ella, por ejemplo: el dueño pega los datos en el chat>`

**«Probada» solo se escribe si puedes llenar «leí:» con algo que de verdad leíste ahí** (del negocio, sin claves ni datos personales). Buscar y no hallar no es probar: si la búsqueda no trae nada, abre lo más reciente de esa conexión (el último correo de una carpeta del negocio, la carpeta donde debería estar el archivo); si aun así no lees nada, es «no probada» y el «por qué» dice qué buscaste y dónde. El «por qué» cuenta lo que pasó al intentarlo («la app no tiene conector de correo en esta sesión», «el archivo no está en Documentos ni en Escritorio», «la página pide entrar a una cuenta»), nunca una causa que no comprobaste. Si en la primera chamba usas otra conexión, también la anotas así. Sin conexión, el empleado trabaja con lo que el dueño pega o suelta, y el renglón lo dice en «mientras».

**Los canales sin conexión también llevan su renglón.** Si el puesto trabaja con algo que el dueño trae a mano de un canal que la app no tiene conectado (los mensajes de una app de chat, las fotos de un cuaderno de pedidos, las notas de voz de un proveedor), ese canal va en la lista como cualquier otra conexión: `- <canal> · no probada · por qué: no hay conexión en esta sesión · mientras: el dueño pega <qué>`. Que no se pueda probar no lo saca de la ficha.

## Paso 4 · Ver qué falta, sin preguntar todavía

Haz la lista de lo que la ficha y la primera chamba necesitan. Antes de poner algo en la lista:

1. **búscalo en todo `conocimiento/`**, no en una sola nota: busca la palabra (costo, envío, horario, anticipo, el nombre del producto o del cliente) en toda la carpeta, **también en cada ficha de `conocimiento/clientes/`**, y en lo que salió del paso 3;
2. **míralo en esta charla y en lo que ya leíste en esta sesión:** si ya lo contestó, si dijo que no lo tiene o que lo busca luego, no se pregunta otra vez, ni como «pásamelo cuando lo tengas»;
3. **si una nota ya da el valor, ese se usa:** el costo de envío de su nota cuando nadie pidió envío gratis, el anticipo escrito cuando nadie pidió otro trato, el horario de la sucursal cuando el pedido no dice otro. Solo preguntas la excepción si el dueño la nombró.

Si el dato está, lo usas y lo dices como hecho, con su fuente («según su ficha, ese cliente pide por correo»), sin preguntarlo. **Lo que siga faltando no se pregunta ahora:** va a la ficha y a la chamba como «pendiente: <qué>», en su lugar, y sigues en este mismo turno con los pasos 5 y 6. No pidas un archivo más ni esperes un dato para empezar: si tienes con qué hacer una parte, la haces. Si de verdad no hay ningún dato para empezar, la primera chamba es una pieza de muestra hecha con la forma de lo que entrega este puesto, con cada hueco marcado, y le dices qué dato la llena. Las preguntas van después de enseñar la pieza (paso 6).

## Paso 5 · Escribir la ficha

Se escribe en ese mismo turno, con lo que hay, en `empleados/<puesto>.md`; lo que falta, «pendiente: <qué>». Si el puesto salió del catálogo, ajustas esa ficha; si es nuevo, la creas ahí con el «Molde de un puesto nuevo» (al final de esta rutina), con todas sus secciones, y la llenas con los mismos pasos:

1. **La cabecera:** `estado: activo` y `desde: AAAA-MM-DD` con la fecha de hoy. Borra el párrafo de plantilla («Puesto genérico del catálogo…») y pon en su lugar una línea que diga qué hace este empleado en este negocio. Si salió del catálogo, ajusta también «Qué resuelve en este negocio» y «Cómo pedirle trabajo» a lo que este negocio necesita y a lo que pidió el dueño.
2. **Cada «pendiente: lo llena crear-empleado»** se cambia por el dato, con su enlace a `conocimiento/`. Queda «pendiente» a secas solo lo que nadie respondió; nada que el dueño ya dijo ni que esté en `conocimiento/`.
3. **Lo que el dueño dijo para el puesto va a la ficha:** qué buzón revisar, qué formato le gusta, cada cuánto. Si además es un dato del negocio (un precio, un horario, una regla), va también a su nota de `conocimiento/` con su marca, y la ficha lo dice en una línea con el enlace; la nota manda.
4. **«Qué siempre le pregunta al dueño» y los límites** se llenan con las reglas del negocio que tocan al puesto (de `conocimiento/reglas-del-negocio.md` y `conocimiento/dueno/como-trabajar-con-el.md`: descuentos, lo que nunca se dice a un cliente, cuándo se llama al dueño), cada una con su enlace, además de la regla fija.
5. **Cada regla de la ficha sale de algún lado:** de una nota de `conocimiento/` (con su enlace) o de lo que dijo el dueño (con `[confirmado AAAA-MM-DD]`). El texto del catálogo se queda; no agregues reglas tuyas que ninguna nota respalda («contesta en menos de un día», «tres opciones como mucho»). Lo que decidió para un solo caso va como caso, con su fecha, no como regla del puesto.
6. **La voz:** si el empleado escribe a clientes o al público, usa la voz de la marca de `conocimiento/negocio/`; el trato de `conocimiento/dueno/como-hablarle.md` es solo para hablarle al dueño.
7. **«Estado»:** «Activo desde AAAA-MM-DD · a pedido», con las conexiones probadas.
8. **El índice:** en `empleados/_indice.md` su línea pasa a «activo · AAAA-MM-DD». Si es nuevo, súmale su renglón a la tabla, con lo que le quita al dueño en sus palabras, y si estaba en «Otros ejemplos», quítalo de ahí. Si salió de «Ideas de puestos», márcala «despertado: <puesto> AAAA-MM-DD».
9. **La regla de cálculo**, si la chamba saca cantidades (cuánto pedir, cuánto cobrar, cuánto cuesta): en «Qué decide solo y con qué criterio», una línea con qué se suma, qué se resta y de dónde sale cada parte (por ejemplo, «se pide lo que se gasta en dos semanas menos lo que queda en el almacén y lo que ya viene en camino»), con su enlace o su `[confirmado AAAA-MM-DD]`. Se escribe una vez, la primera; cada pieza la aplica igual. Si el dueño la cambia, cambia aquí (`sistema/rutinas/corregir-chamba.md`).

## Paso 6 · Primera chamba, como ese empleado

Haz la tarea que pidió el dueño (o, si no pidió una, la más típica del puesto) siguiendo la ficha, con datos reales del cerebro, **en este mismo turno y con lo que haya**: lo que falte va dentro de la pieza como «pendiente: <qué>», en su lugar. Nada se manda, publica ni cambia fuera de esta carpeta. Guárdala con `sistema/rutinas/nuevo-entregable.md`.

**Si saca cantidades, aplica la regla de cálculo de la ficha** (paso 5), igual que la vez anterior, y nómbrala en una línea dentro de la pieza («pedí lo que se gasta en dos semanas menos lo que queda y lo que ya viene en camino»).

**Los datos de terceros se quedan en la chamba.** Nombres, teléfonos, correos y datos de personas que salen del trabajo de la chamba (candidatos a un puesto, prospectos, clientes de una sola vez, proveedores que se cotizaron) viven solo en la carpeta de esa chamba en `trabajo/`; no se copian a `conocimiento/` ni a la ficha. A `conocimiento/` va solo lo que ya es del negocio y el dueño confirma: un cliente que regresa (AGENTS.md, punto 16) o un proveedor con el que ya trabaja.

**Lo que pidió se entrega como lo pidió.** Todo lo que pidió que llevara, va. No quites ni sumes nada por tu cuenta (un precio, una sección, una invitación): si crees que algo convendría distinto, lo dejas como lo pidió y lo propones en una línea al entregar. Lo que no sabes (si una promoción sigue, si un servicio está abierto) se queda «pendiente»; no se inventa.

**Lo que va a clientes o al público solo dice lo que está en `conocimiento/` o lo que dijo el dueño:** ningún plazo, garantía, envío, descuento, horario, beneficio ni resultado que no esté escrito, y una regla se explica como la dice su nota, sin consecuencias tuyas. Lo que falte queda «pendiente». Lleva todos los precios y escalones que apliquen, la voz de la marca y cada dato cruzado con lo guardado, también lo de la web (`sistema/rutinas/nuevo-entregable.md`, paso 3).

**Cada frase de análisis lleva su número.** Si la chamba dice qué se vende más, qué deja más, qué día pesa o qué salta a la vista, cada una de esas frases lleva al lado el número que la sostiene y de dónde sale (una nota de `conocimiento/`, un archivo leído o lo que dijo el dueño): «<frase> (<número> · <de dónde>)». Si no hay número, la frase no afirma: dice qué falta y quién lo tiene («falta el costo de cada servicio; lo tiene el contador»). Si el número salió de una suma, la frase nombra lo que incluye, no solo una de sus partes.

**Revisión propia, antes de enseñarla.** Ya armada la chamba, ponla al lado del pedido del dueño, con sus palabras, y mídela así:

1. ¿Responde lo que pidió y lleva todo lo que pidió que llevara?
2. ¿Cada dato y cada cifra tiene de dónde salir (una nota, un archivo leído, lo que dijo él)? Lo que no, queda «pendiente» o se quita la frase.
3. ¿Suena a su negocio: la voz de su marca si va a clientes, sus palabras si es para él?
4. ¿Respeta los límites de la ficha y las reglas del negocio (nada se manda, nada fuera de regla sin su «sí», nada que repita algo de «Aprendizajes»)? Si una corrección pidió una forma («una o dos frases», «sin emojis», «en lista»), mide la pieza contra ella, contando, antes de enseñarla.
5. ¿Cada afirmación sobre una persona, un correo o un documento dice lo mismo que sus palabras exactas? Vuelve a abrir la fuente y cotéjala, sobre todo antes de una conclusión que deja a alguien o algo fuera: «acepta pagos con tarjeta» no es «solo acepta tarjeta», y «tiene experiencia en ventas» no es «solo sabe vender». Fíjate quién escribe a quién y quién trata de qué a quién. Si cuentas personas o casos, revisa uno por uno que cada uno cumple de verdad lo que dices de él («ya compró», «se quejó», «pidió precio»).
6. ¿Lo que verá el público dice cada dato como lo dice su fuente, palabra por palabra, sin juntar dos datos en uno nuevo ni sumarle lugar, fecha o alcance? «Abre en sábado» y «tiene técnico de guardia» no dan «técnico de guardia los sábados».
7. ¿Cada cifra que salió de una suma dice qué incluye?
8. ¿Si saca cantidades, cada una sale de la regla de cálculo de la ficha, sin otra cuenta, y la pieza la nombra en una línea?

Corrige lo que no cuadre, una vez, y guarda la versión corregida. Al dueño no le enseñas esta revisión ni le cuentas qué arreglaste en ella: solo ve la chamba ya corregida.

**La primera chamba se enseña completa, en el mismo mensaje en que la entregas.** Ese mensaje abre con la frase del paso 2 («Para…, el puesto es…, porque…») como primera oración; luego trae, en una o dos líneas, qué es, y luego el texto completo de la pieza ya revisada, aunque sea larga y aunque en ese mismo turno hayas escrito la ficha: no un resumen, no los primeros renglones, no «quedó en tal carpeta», no «te la paso si quieres». **Si guardaste una guía, un reporte o un texto, en el chat va ese mismo texto, tal como quedó guardado**, no otro resumen escrito aparte. **Si son dos o más borradores, van todos, cada uno completo.** Si el mensaje no trae la pieza entera, la chamba no está entregada. Si no es texto (una hoja, una página), trae su contenido completo en el mensaje (la tabla, los textos de la página) y dónde quedó el archivo. El dueño no tiene que pedir verla.

**Las preguntas, después de la pieza.** En ese mismo mensaje, después de la pieza completa, pregunta lo que quedó «pendiente», la chamba de verdad necesita y solo él sabe, lo más útil primero: **una sola tanda, tres como mucho, contando cada renglón**. Lo que no quepa sigue «pendiente» y no se pide otra vez. Cierra con una sola sugerencia, sin preguntarle cómo quedó. Si su respuesta corrige algo, se atiende con `sistema/rutinas/corregir-chamba.md` antes que nada.

**Cada respuesta se apunta en la ficha en ese momento**, también «no lo tengo» (`- <qué>: no lo tiene [confirmado AAAA-MM-DD]`) y «lo busco luego» (`- <qué>: pendiente, lo busca el dueño [confirmado AAAA-MM-DD]`). Al apuntarla, busca en toda la ficha y en la pieza cada renglón que decía «pendiente» sobre eso o que dice otra cosa, y cámbialos todos, no solo el primero. Si la respuesta llena un hueco de la pieza, guárdala como versión nueva (`…-v2`) y enséñala completa.

## Paso 7 · Poner la ficha al día

En cuanto entregas la primera chamba, sin esperar su respuesta, abre la ficha y ponla al día:

- «Estado»: `Activo desde AAAA-MM-DD · a pedido · primera chamba AAAA-MM-DD: <qué> · trabajo/<carpeta>/`;
- «Qué entrega»: lo que de verdad entregó y dónde queda;
- «Con qué se conecta»: lo que usó en la chamba, con la forma del paso 3;
- quita lo que ya no es cierto: «primera chamba pendiente», «sin primera chamba», un dato que ya llegó, una lista que dice vivir en otro lado si ya la tienes, y cada «pendiente» que ya tiene respuesta en esta charla o en `conocimiento/`.

## Paso 8 · Cada corrección, con su rutina

Cuando el dueño corrige o pide cambiar algo que hizo el empleado, en esta rutina o cualquier otro día, abre `sistema/rutinas/corregir-chamba.md` en ese mismo turno y síguela: la corrección va primero a «Aprendizajes» de esta ficha, con el alcance que dijo, y luego la pieza se rehace y se enseña completa. No gastes otra pregunta en eso.

## Paso 9 · Programarlo, solo si el dueño lo pidió

Si pidió que trabaje solo cada cierto tiempo, revisa si esta app tiene tareas programadas. Si las tiene, programa solo con su «sí» claro, y con una tarea que solo prepare y no mande nada. Si no las tiene, dilo en una línea y queda a pedido. Anota en «Estado» lo que de verdad quedó programado.

## Cierre

Antes de cerrar, **relee la ficha entera** y quita cada «pendiente» que ya tiene respuesta en la charla o en `conocimiento/`. Luego dile en pocas líneas qué empleado quedó (activo desde hoy), qué sabe hacer, qué conexiones quedaron probadas y cuáles no y por qué, y dos o tres frases con que puede pedirle trabajo (las mismas que dejas en «Cómo pedirle trabajo»). **No cierres con una lista de pendientes ni de datos que faltan, ni con preguntas nuevas:** lo que no contestó ya quedó «pendiente» en la ficha y no se le vuelve a pedir; si hace falta, nómbralo en una línea, sin signo de pregunta. Solo aquí, en una línea al final y como sugerencia («Sugiero…», «Puedo seguir con…»), van los ofrecimientos que esperaban (AGENTS.md, punto 1), sin enumerar los pendientes de otros temas. Apunta una línea en `sistema/bitacora.md`.

## Antes de decir «listo»

Corre esta lista al entregar la primera chamba, después de cada corrección y antes del cierre. Abre la ficha y el índice; no la contestes de memoria. Lo que no se cumpla, lo arreglas antes de seguir.

- [ ] ¿La primera oración del mensaje es la frase Para…, el puesto es…, porque…? El mensaje que entregó la primera chamba abrió con «Para <lo que pidió, con sus palabras>, el puesto es <puesto>, porque <lo que hace que lo resuelve>», también si es nuevo, y siguieron la pieza completa y las preguntas. Nada fue antes en ese mensaje, ni «Ya quedó…» ni «Guardé…»: el saludo y el «reviso…», si los hubo, fueron en un mensaje aparte, antes de abrir nada. La frase no está solo en la ficha y ese mensaje no trajo otros temas.
- [ ] El puesto resuelve de verdad lo que pidió; si ninguno del catálogo lo hacía, creaste uno nuevo con nombre de oficio en vez de forzar uno que solo se parecía.
- [ ] Si el puesto es nuevo, su ficha tiene todas las secciones del molde, en su orden, con el mismo renglón de conexión y su sección de «Aprendizajes».
- [ ] Ningún mensaje ofrece con pregunta («¿quieres que…?», «¿cómo quedó?»): lo que sigue va como una sola sugerencia, al final.
- [ ] Preguntas contadas una por una en tus mensajes, el de cierre incluido: ninguna antes de la primera chamba, una sola tanda de tres o menos después de enseñarla y en ese mismo mensaje, y dos o menos en todo lo demás, contando cada renglón de cada lista de lo que te falta, cada dato pedido otra vez, «pásamelo cuando…» y «avísame cuando…». La lista de lo que falta la dijiste una vez; ningún mensaje después la repite. Ninguna de algo que está en `conocimiento/` (fichas de clientes incluidas), que leíste en la sesión, que una nota ya da, que dijo que no tiene o que dijo que busca luego, ni de algo que una nota dice que no existe, ni ninguno solo para llenar una libreta.
- [ ] Ningún mensaje al dueño trae rutas, nombres de archivo, palabras de taller ni cómo guardaste las cosas, salvo la línea de «Guardé».
- [ ] La ficha dice `estado: activo` con su fecha, sin el párrafo de plantilla ni «pendiente: lo llena crear-empleado», y «Estado» nombra la primera chamba con su fecha y dónde quedó.
- [ ] Releíste la ficha entera: ningún «pendiente» tiene ya respuesta en la charla o en `conocimiento/`, y ninguna sección contradice una corrección o una respuesta del dueño.
- [ ] Cada regla de la ficha lleva su enlace a una nota o su `[confirmado AAAA-MM-DD]`, y ninguna salió de volver regla lo que decidió para un solo caso.
- [ ] «Con qué se conecta» tiene un renglón por cada conexión de esta sesión, el correo incluido, y uno por cada canal sin conexión del que el dueño pega o suelta cosas («no probada · por qué: no hay conexión… · mientras: el dueño pega…»); cada «probada» trae «leí:» con algo que de verdad salió de ahí y el rango de fechas; cada «no probada» dice qué pasó al intentarlo y cómo se trabaja mientras.
- [ ] El correo se buscó solo en carpetas del negocio y en las mixtas recorridas por remitente y asunto, nunca en las personales, y lo que dijiste de él trae de qué fecha a qué fecha buscaste.
- [ ] Corriste la revisión propia del paso 6, sus ocho puntos, y corregiste lo que no cuadraba antes de enseñar la chamba; el dueño no vio esa revisión.
- [ ] Cada conclusión sobre una persona, un correo o un documento la cotejaste con sus palabras exactas; ninguna deja a alguien fuera por algo que la fuente no dice.
- [ ] El mensaje en que entregaste la primera chamba trajo el texto completo de la pieza ya revisada, de principio a fin, el mismo que guardaste, no un resumen, ni sus primeros renglones, ni solo dónde quedó; el dueño no tuvo que pedir verla. Si eran dos o más borradores, iban todos, completos. La chamba salió en el turno en que se creó o despertó el puesto, con lo que faltaba marcado «pendiente: …» dentro de la pieza; ningún mensaje antes de ella pidió un dato o un archivo.
- [ ] Si la chamba saca cantidades, la regla de cálculo está en «Qué decide solo y con qué criterio» de la ficha, con su fuente, y la pieza la aplica y la nombra en una línea.
- [ ] Si una corrección de «Aprendizajes» pidió una forma (largo, número de frases, lista), la pieza la cumple: la contaste antes de enseñarla.
- [ ] Los nombres, teléfonos y datos de terceros que salieron de la chamba (candidatos, prospectos, clientes de una vez, proveedores cotizados) están solo en su carpeta de `trabajo/`, no en `conocimiento/` ni en la ficha.
- [ ] Cada frase de análisis de la chamba lleva su número y de dónde sale, o dice qué falta y quién lo tiene.
- [ ] La chamba lleva todo lo que pidió, sin quitar ni sumar por tu cuenta; lo que propones cambiar va aparte, en una línea.
- [ ] Cada corrección del dueño pasó por `sistema/rutinas/corregir-chamba.md`: está en «Aprendizajes» de la ficha (no en las notas de cómo hablarle), con su fecha, su alcance y la ruta de la versión corregida, y la enseñaste completa en el mismo mensaje.
- [ ] ¿Todo va en el trato que el dueño usa, en cada mensaje y no solo en el cierre? Antes de mandar cada uno revisaste cada verbo y cada pronombre contra el trato guardado (de usted, nada de «te», «tu», «corregiste», «pediste»; de tú, nada de «le», «su», «corrigió», «pidió»), y lo saludas y le llamas con el nombre con que pidió que le digan. Ninguna frase copiada de esta rutina quedó en el otro trato.
- [ ] Lo que va a clientes o al público no dice nada que no esté en `conocimiento/` o que no haya dicho el dueño, ni consecuencias de una regla que su nota no dice, y ninguna fecha, vigencia o promoción choca con lo guardado de la web.
- [ ] La chamba está en `trabajo/` con su línea en `trabajo/_indice.md`, y el renglón del puesto en `empleados/_indice.md` dice «activo · AAAA-MM-DD».
- [ ] El cierre no trae una lista de pendientes ni preguntas nuevas; los ofrecimientos de otros temas van solo ahí, en una línea, como sugerencia. Lo que nombres como faltante lo cotejaste con lo que contestó en la charla: nada de lo que ya dio.
- [ ] Cada corrección, cambio o costumbre de esta charla tiene su línea en `conocimiento/dueno/correcciones.md`, con «DNA: sí» o «no», y la palabra vieja ya no aparece fuera de «Historia».
- [ ] Cada línea de esta charla con «DNA: sí» tiene ya su DNA nuevo (`sistema/rutinas/dna-del-negocio.md`), sacado en el mismo turno.
- [ ] Todo lo escribiste con las herramientas de escribir y editar de la app (AGENTS.md, punto 12), y cada mensaje en que guardaste algo trae su «Guardé».

## Molde de un puesto nuevo

Un puesto que no está en el catálogo nace con esta ficha, en `empleados/<nombre-del-puesto>.md` (minúsculas, sin acentos, sin ñ, con guiones). Tiene las mismas secciones que las del catálogo, en el mismo orden; lo que va entre `<…>` se llena con los pasos 4 y 5, y lo que no se sabe queda «pendiente». Los párrafos sin `<…>` se copian tal cual.

```
---
puesto: <nombre-del-puesto>
estado: activo
desde: AAAA-MM-DD
---

# <Nombre del puesto>

<Una línea: qué hace este empleado en este negocio, y que nació porque el dueño pidió <lo que pidió, con sus palabras>.>

## Aprendizajes

Lee esto antes de cada entrega de este puesto. Aquí vive cada corrección del dueño a lo que hace este empleado, también las de forma («sin emojis», «más formal»): no van a las notas de cómo hablarle al dueño. Cuando corrige, la línea se escribe aquí antes de rehacer nada, se cambia toda parte de la ficha que choque con ella y la versión nueva se le enseña completa (`sistema/rutinas/corregir-chamba.md`). Antes de enseñar una entrega nueva, ábrela junto a la última versión corregida y revisa cada línea de aquí: si repite algo ya corregido, arréglala antes. La más nueva arriba, con esta forma: `- AAAA-MM-DD · <lo que corrigió, en sus palabras> · desde hoy: <qué se hace distinto> · versión corregida: trabajo/<carpeta>/<archivo>`.

- Ninguno todavía.

## Qué resuelve en este negocio

<Dos o tres frases: qué trabajo toma, de dónde lo saca y qué deja listo.>

## Qué información necesita desde el día uno

- [<Nombre de la nota>](../conocimiento/<carpeta>/<nota>.md): <para qué la usa>.
- [Reglas del negocio](../conocimiento/reglas-del-negocio.md): <qué reglas le tocan>.
- <Si escribe a clientes:> [Voz de la marca](../conocimiento/negocio/): el tono con que el negocio le escribe a sus clientes.
- Además: <lo que necesita y todavía no está en el cerebro, o «nada»>.

Enlaza el conocimiento del cerebro; nunca lo copia aquí.

## Qué decide solo y con qué criterio

<Lo que hace sin preguntar, cada cosa con la regla o la nota que lo permite.>

<Si saca cantidades:> Regla de cálculo: <qué se suma y qué se resta, y de dónde sale cada parte, con su enlace o su [confirmado AAAA-MM-DD]>. Cada pieza la aplica igual y la nombra en una línea; si el dueño la cambia, cambia aquí.

## Qué siempre le pregunta al dueño

<Lo que se sale de sus reglas: excepciones, dinero, lo que va a un cliente.>

Además, las reglas de [reglas del negocio](../conocimiento/reglas-del-negocio.md) y de [cómo trabajar con el dueño](../conocimiento/dueno/como-trabajar-con-el.md) que tocan a este puesto, cada una con su enlace: <cuáles, o «ninguna todavía»>.

Regla fija: este empleado nunca manda, publica, paga ni borra nada solo. Todo eso pasa por el «sí» del dueño, dado en esta conversación.

## Con qué se conecta y si ya se probó

<Qué fuentes usa, en modo lectura, y qué hace si no hay conexión.>

Al crearlo se intenta leer, solo leyendo, cada conexión que tenga la sesión, aunque este puesto no parezca usarla, y se anota una por renglón con una de estas dos formas: `- <conexión> · probada AAAA-MM-DD · leí: «<algo que de verdad salió de ahí: un asunto, una cifra, un nombre>» · busqué: <dónde, y de qué fecha a qué fecha>` o `- <conexión> · no probada · por qué: <lo que pasó al intentarlo> · mientras: <cómo se trabaja sin ella>`. Sin algo leído que citar no hay «probada»: buscar y no hallar es «no probada». Un canal sin conexión del que el dueño pega o suelta cosas también lleva su renglón, como «no probada», con «mientras: el dueño pega <qué>». Nunca se piden ni se guardan contraseñas.

<un renglón por conexión>

## Cuándo trabaja

<A pedido, o cada cuánto si el dueño lo aprueba.> Escribirlo aquí no programa nada; lo que de verdad quede programado se anota en «Estado».

## Qué entrega y cómo se ve bien hecho

<Qué entrega, dónde queda en trabajo/ y cómo sabe el dueño que está bien hecho.>

## Cómo se mide

<Dos o tres cosas que se pueden contar: tiempo que ahorra, errores que el dueño halla, lo que resuelve.>

## Qué le quita al dueño

<Una frase, la misma de su renglón en empleados/_indice.md.>

## Cómo pedirle trabajo

- «<una frase con que el dueño le pediría trabajo>»
- «<otra>»
- «<otra>»

## Estado

Activo desde AAAA-MM-DD · a pedido · <conexiones probadas> · primera chamba: <qué, fecha y carpeta de trabajo/, en cuanto la entregue>.

Los estados son dormido y activo; lo que de verdad quede programado se anota aquí. En cuanto entrega su primera chamba, esta línea dice cuál fue, su fecha y dónde quedó.
```
