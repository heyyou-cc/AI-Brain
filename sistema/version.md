# Versión del cerebro

Para qué sirve: dice qué versión es esta carpeta y qué archivos son nuestros (heyyou los puede reemplazar en una versión nueva) y cuáles son del dueño (nunca se pisan). Quien ponga una versión nueva encima reemplaza solo lo nuestro.

- Versión: 1.11.0
- Fecha: 2026-11-24
- Probada en: la 1.8, en Claude Code; la 1.9 a la 1.11 falta correrlas enteras. La herramienta de leer documentos se corrió en Windows (PowerShell 5.1 y Git Bash) con documentos de ejemplo, y las dos versiones dan la misma salida; en un Mac no se ha corrido. El extractor de exportaciones de claude.ai y ChatGPT (`-Exportacion`) se probó en PowerShell 5.1 con archivos de muestra, `.zip` y `.json`; la versión `.sh` se probó solo en su lógica, con Node en vez de `osascript`, y no se ha corrido en un Mac. Las alarmas, los tres formatos de evento (Claude, Codex y Copilot), la carpeta `_privado` y el lanzador de Windows se probaron en Windows con Git Bash y PowerShell 5.1: `probar.sh` 143 de 143 y `probar-sincronizar.sh` 104 de 104. El motor de agentes (`sistema/mcp/`), `.codex/hooks.json`, `.github/hooks/` y los demás archivos nuevos de plomería quedan configurados según su documentación. Sin probar: Mac, Codex y Copilot reales.

## Nuestros: se pueden reemplazar en una versión nueva

- `AGENTS.md`, `CLAUDE.md` y `LEEME.md`.
- `.claude/settings.json`, `.codex/config.toml`, `.codex/hooks.json`, `.gitattributes` y las reglas de fábrica de `.gitignore` (las líneas que el dueño agregue se conservan).
- `.github/hooks/` (las alarmas de Copilot), `.mcp.json` y `.vscode/mcp.json` (el motor de agentes), `.ignore` (saca `_privado` de las búsquedas) y todo `sistema/mcp/` (el motor de agentes de heyyou).
- Las ocho rutinas de fábrica en `sistema/rutinas/`: `arranque.md`, `dna-del-negocio.md`, `repaso-semanal.md`, `nuevo-entregable.md`, `proponer-automatizacion.md`, `crear-skill.md`, `corregir-chamba.md` y `higgsfield.md`.
- Sus puertas: `.claude/skills/<nombre>/SKILL.md` y `.agents/skills/<nombre>/SKILL.md` de esas ocho y de las catorce skills de fábrica.
- En `skills/`: las catorce skills de fábrica (`cotizar`, `responder-clientes`, `cobrar`, `contenido-para-redes`, `propuesta-comercial`, `prospectar`, `dar-seguimiento`, `investigar-competencia`, `revisar-numeros`, `minuta-de-junta`, `documentar-un-proceso`, `plan-de-la-semana`, `contratar` y `aprender-ia`), `skills/_recomendadas.md` (menos su sección «No las quiere») y las reglas y la tabla de fábrica de `skills/_indice.md` (los estados, las ideas y las skills del dueño de ese archivo son del dueño). Una skill de fábrica no se corrige a mano: lo que el dueño le corrige vive en `skills/_aprendizajes.md`.
- `repositorios/_indice.md` (menos su sección «No los quiere»): el inventario de proyectos de consulta que heyyou pone al día.
- `sistema/clasificacion.md`, todo `sistema/herramientas/`, todo `sistema/alarmas/` (menos `.ultima-orden`), todo `sistema/accesos/` (menos `.caja` y `.caja-linux`, que son del dueño), `sistema/tareas/probar-alarmas.md` y `sistema/tareas/conectar-caja-fuerte.md` y `sistema/tareas/conectar-respaldo.md` si siguen en la carpeta, y este archivo.
- Los `_leeme.md` de `entrada/` y `entrada/por-clasificar/`, y las primeras líneas (para qué sirve y forma) de las libretas de `sistema/`, sin tocar lo que el dueño ya tiene debajo.

## Del dueño: nunca se pisan

- Todo `conocimiento/`, también las 31 notas de las 31 P y `conocimiento/_30p.md` (el tablero), aunque una nota siga siendo plantilla (si una versión nueva trae otra forma, se propone, no se pisa; si trae una nota que falta, como la lista de correcciones o la de la P31, se agrega vacía).
- **`_privado/`, entera.** Es del dueño: nunca se pisa, nunca se sube a GitHub y ningún asistente la abre sin su permiso. Esto vale también para cualquier carpeta que se llame `_privado`, a cualquier nivel.
- Todo `trabajo/`, `fuentes/` y `entrada/` (fuera de sus `_leeme.md`).
- `skills/_aprendizajes.md` (lo que el dueño corrigió a cada skill), `skills/_viejos/` (las fichas de puestos que se convirtieron), las skills que el dueño creó o convirtió y los estados y las ideas de `skills/_indice.md`.
- `sistema/exclusiones.md` (lo que el dueño pidió que no se vea ni se guarde) y `sistema/sincronizar.conf` (la dirección de su repositorio propio).
- `sistema/estado.md`, `sistema/registro-del-barrido.md`, `sistema/golpes.md`, `sistema/decisiones.md`, `sistema/ideas-para-automatizar.md` y `sistema/bitacora.md`, en lo que está debajo de sus primeras líneas.
- Las rutinas y las skills que el dueño aceptó o creó después y sus puertas (listas de abajo), y `.claude/settings.local.json` si existe.
- **Si el cerebro trae la carpeta de puestos de una versión anterior (`empleados/`):** no se borra ni se pisa. Los puestos despiertos o creados para el negocio se conservan hasta que el asistente, en la primera sesión con la 1.11, proponga convertir cada uno en skill; la ficha vieja se mueve a `skills/_viejos/` solo con el «sí» del dueño (`sistema/rutinas/crear-skill.md`, «Migración»).

## Desde 1.10

Cuando alguien abre con la 1.11 una carpeta que ya existía (la `version` de `sistema/estado.md` dice 1.10 o menos, tiene `empleados/` o `conocimiento/_30p.md` no trae la P31), el asistente corre esto una sola vez, en la primera sesión, sin preguntar lo que es de plantilla y sin tocar un solo dato del dueño. Al terminar escribe `migracion_1_11: <fecha de hoy>` y `version: 1.11` en el estado, y una línea en `sistema/bitacora.md`.

1. **Las 31 P, solo la forma.**
   - Agrega la fila de la P31 al final de `conocimiento/_30p.md` y de `conocimiento/_mapa.md`, con la forma de las otras (`| P31 | Problemas del dueño | [problemas](dueno/problemas.md) | vacía | — |`; en el mapa, `| P31 | Problemas del dueño | [`dueno/problemas.md`](dueno/problemas.md) | vacía |`). Si la nota de la P31 ya trae datos, cuenta su llenado con la escala del mapa en vez de poner «vacía».
   - Cambia el nombre de la P12 a «Problemas del negocio» y el de la P20 a «Pericias (skills)», con enlace a `skills/_indice.md` (en el tablero `[skills](../skills/_indice.md)`; en el mapa `[`skills/_indice.md`](../skills/_indice.md), sección «Ideas de skills»`). No cambies «Qué tan lleno» ni «Lo más importante» de ninguna fila, y no reescribas lo que el dueño ya llenó.
   - Cambia «30» por «31» solo en las líneas de fábrica que cuentan las P (por ejemplo, «Las 31 P están repartidas…» del mapa).
   - Crea `conocimiento/dueno/problemas.md` si falta, con la forma de la nota de fábrica de la P31 (la primera línea dice para qué sirve, luego `P: P31 · Problemas del dueño`, «Lo que sabemos», «Lo que falta saber» y «Historia»), y su línea en `conocimiento/dueno/_indice.md`.
2. **Borra lo viejo de fábrica**, solo si sigue como lo entregó heyyou (si el dueño lo cambió o aparece en «Rutinas del dueño», no lo borres: díselo en una línea): `sistema/rutinas/crear-empleado.md`, las puertas `crear-empleado` de `.claude/skills/` y de `.agents/skills/`, y la carpeta `sistema/catalogo/` (su contenido útil ya vive en `skills/_recomendadas.md` y `repositorios/_indice.md`; comprueba que existan antes). No toques `empleados/` en este paso.
3. **Puestos de la carpeta `empleados/`.** Si hay puestos despiertos o creados para el negocio, propón **una sola vez** convertirlos en skills, como dice «Migración» en `sistema/rutinas/crear-skill.md`. Si el dueño dice que no, apunta `migracion_empleados: no` en el estado y no lo propongas otra vez; si dice que sí, `migracion_empleados: hecha` al terminar.
4. **La pregunta de privacidad.** Si el arranque ya estaba `listo`, haz una vez la pregunta de privacidad del cierre (`sistema/rutinas/arranque.md`, paso 3 de `cierre`), con su aviso de costo, y escribe `pregunta_privado`. Mientras no conteste, la sincronización queda en pausa (`sistema/alarmas/sincronizar.sh`): la plantilla trae esa regla y vale también aquí.
5. **Las reglas de privacidad del `.gitignore`.** Comprueba que traiga `**/_[Pp][Rr][Ii][Vv][Aa][Dd][Oo]/*` y su excepción `!**/_[Pp][Rr][Ii][Vv][Aa][Dd][Oo]/_leeme.md`; si falta, agrégalas. Lo que una versión vieja ya haya subido queda en el historial del respaldo; la sincronización solo evita que siga subiendo, y heyyou puede limpiarlo del historial si el dueño lo pide.

## Rutinas del dueño

Las que nacen con `sistema/rutinas/proponer-automatizacion.md` se apuntan aquí, una por renglón, para que una versión nueva no las pise: `- <nombre> · sistema/rutinas/<nombre>.md · desde AAAA-MM-DD`.

Ninguna todavía.

## Skills del dueño

Las que nacen con `sistema/rutinas/crear-skill.md` (o se convierten de un puesto de una versión anterior) se apuntan aquí, una por renglón, para que una versión nueva no las pise: `- <nombre> · skills/<nombre>/SKILL.md · desde AAAA-MM-DD`.

Ninguna todavía.

## Historia de versiones

- 1.11.0 · 2026-11-24 · Retos del dueño, carpeta privada, skills en lugar de puestos e inventario a la vista, uno por renglón:
  - Nace la P31, «Problemas del dueño»: los retos del dueño (o del alumno) como persona que dirige o aprende, como el tiempo, delegar, la IA, sentirse rebasado o vender. Nota nueva `conocimiento/dueno/problemas.md`. El arranque la busca en sus conversaciones con la IA, su correo y lo que dice, y la pregunta en la entrevista si sigue vacía. La P12 pasa a llamarse «Problemas del negocio». Son 31 P: tablero, mapa, ficha de clasificación, DNA y avisos al día.
  - Carpeta privada: `_privado/` en la raíz del cerebro, y cualquier carpeta con ese nombre a cualquier nivel. Ahí va lo sensible del dueño con la misma ruta que en `conocimiento/`. Nunca se sube a GitHub y ningún asistente la abre sin su «sí» en el chat, cada vez y en cada sesión; buscar no entra. Si un dato de una P se fue ahí, su fila dice «hay datos en privado», sin repetirlo. La regla vale sin distinguir mayúsculas (`_Privado`, `_PRIVADO`). Lo que se mueva con `git mv` o ya estuviera seguido por git se deja de seguir sin borrarlo del disco. Las alarmas preguntan también ante comandos que recorren todo el cerebro (`grep -r`, `rg --no-ignore`, `tar`, `zip`…) y ante `<` o verbos como `cut`, `wc`, `sort`, `jq`. Su explicación está en `AGENTS.md`, en `LEEME.md` y en el `_leeme.md` de la propia carpeta; ese archivo también pide permiso en Claude Code (su regla `ask` no se puede excepcionar), por eso lo explicado está en los otros dos. Si una nota dice «(hay datos en privado)», lo nuevo de ese tipo va a su gemela privada y usarlo pide permiso.
  - El cierre del arranque cambia de orden y trae una pregunta y un resumen: primero la pregunta de privacidad («¿la mando a una carpeta privada?», con sí, no o una por una, y el aviso de que usar esos datos después pedirá permiso), luego, si dijo que sí, se mueve lo sensible, luego el respaldo en línea, luego el DNA (que nunca incluye lo privado) y al final el mensaje con un resumen visual de las 31 P (tabla agrupada por carpeta, con barra de qué tan llena está cada una, lo más importante y dónde quedó, y una línea de conteo). Si el dueño no contesta, `pregunta_privado` queda `pendiente`, no se conecta el respaldo, la sincronización se pone en pausa (no guarda ni sube nada) y se repite al empezar la sesión siguiente. Campos nuevos del estado: `pregunta_privado`, `datos_en_privado`, `migracion_1_11` y `migracion_empleados`.
  - Se quitan `empleados/` y la rutina `crear-empleado`. En su lugar, `skills/` con catorce skills de fábrica y la rutina `crear-skill` para armar las que pida el negocio, cada una con sus dos puertas (Claude Code, Codex y Copilot las encuentran). La P20 pasa de «Puestos artificiales» a «Pericias (skills)». Lo que el dueño corrige a una skill vive en `skills/_aprendizajes.md`.
  - Migración: un cerebro viejo con puestos despiertos o creados no los pierde. En la primera sesión con la 1.11 el asistente propone convertir cada uno en skill y mueve la ficha vieja a `skills/_viejos/` solo con el «sí» del dueño.
  - El inventario de repositorios sube a la vista: `repositorios/_indice.md`, agrupado por para qué sirve (atender por WhatsApp y voz, automatizar, CRM, contenido y video, web y scraping, agentes con el teléfono o el navegador, memoria y juntas, facturas y contabilidad, conectores MCP, cómo trabajar con agentes y aprender IA), con enlace, para qué le sirve al dueño y qué tan difícil es de instalar. Las habilidades de terceros pasan a `skills/_recomendadas.md`. `sistema/catalogo/` desaparece. El asistente solo sugiere; instalar sigue pidiendo el «sí» del dueño.
  - Plomería: las alarmas corren en Claude Code, Codex y Copilot, en Windows y Mac. Un lector común (`_leer-evento.sh`) entiende los tres formatos de evento; no dependen de `CLAUDE_PROJECT_DIR`. Nuevos: `.codex/hooks.json`, `.github/hooks/cerebro.json`, `sistema/alarmas/correr.ps1` (lanzador de Windows) y `antes-de-leer.sh`. Carpeta `_privado` a cualquier nivel: no se sube (`.gitignore`), no se busca (`.ignore`) y leerla pide permiso (`ask` en Claude y Copilot; en Codex frena y pide permiso en el chat). Motor de agentes de heyyou como MCP local en `sistema/mcp/motor-de-agentes/` (`.mcp.json`, `.vscode/mcp.json`, `.codex/config.toml`; llave en `HEYYOU_HUB_KEY`; por ahora contra el Hub de desarrollo). Codex deja los hooks apagados hasta que el dueño los aprueba con `/hooks` (y los apaga otra vez cuando cambian): el asistente se lo pide si la marca `.ultima-orden` no se actualiza. Copilot descarta lo que imprime `userPromptSubmitted`: sus avisos y el recordatorio de la voz llegan en el siguiente `sessionStart` o `postToolUse` (`additionalContext`) y los choques de sincronización frenan en `agentStop`; si Copilot contesta sin usar herramientas, la voz espera. Pruebas en Windows: `probar.sh` 143 de 143, `probar-sincronizar.sh` 104 de 104. Sin probar: Mac, Codex y Copilot reales.
  - La 1.11 no se ha corrido de punta a punta ni en Claude Code ni en Codex.

- 1.10.0 · 2026-11-23 · El arranque trabaja solo y se sincroniza solo, uno por renglón:
  - El arranque ya no pide permiso: saluda, dice qué va a hacer y empieza en ese mismo turno. `permiso` pasa a `directo` (los valores viejos siguen valiendo). Lo personal y los archivos de claves siguen sin abrirse.
  - Trabaja en tres vueltas que avisa paso a paso: lo que hay en la compu (carpetas y conversaciones con la IA, también las de la nube), los conectores y herramientas de la app (solo para leer) e internet, con la fase nueva `enriquecer` (busca por lo hallado: clientes, proveedores, competencia). Si salen pistas nuevas, hasta tres vueltas extra cortas. Usa sub-agentes por bloque.
  - Las 30 P ya vienen armadas: 30 notas en `conocimiento/` y el tablero `conocimiento/_30p.md`. Cada dato va a su P desde el primero, y al cerrar cada vuelta el asistente enseña el tablero para que el dueño corrija. Los campos nuevos del estado son `vuelta_extra`, `enriquecer` y `tablero`, y las fases nuevas `tablero-1`, `tablero-2`, `tablero-3` y `pistas`.
  - `sistema/exclusiones.md`: lo que el dueño saca con «eso no» queda apuntado, y el arranque lo revisa antes de abrir cada fuente y de guardar cada dato.
  - El arranque pide la exportación de conversaciones de claude.ai y ChatGPT, y el extractor (`sistema/herramientas/extraer-conversaciones.ps1` y `.sh`) la lee con `-Exportacion`: acepta el `.zip` o el `conversations.json`, detecta el formato, deja solo los mensajes del dueño, tapa las claves y no escribe ningún archivo.
  - Catálogos nuevos en `sistema/catalogo/` (habilidades recomendadas y proyectos de referencia, sin instalar nada sin el «sí» del dueño) y la rutina `sistema/rutinas/higgsfield.md` (anuncios, videos y fotos con IA, pide el «sí» antes de gastar créditos; sin probar).
  - Sincronización automática con el repositorio propio y privado del dueño (`sistema/alarmas/sincronizar.sh`, enganchada al empezar, con cada mensaje, tras cada escritura y al terminar): guarda en un commit, junta lo de la otra compu con merge y sube. Solo sube y baja si origin es la dirección escrita en `sistema/sincronizar.conf`. Si la carpeta sigue unida a la plantilla de heyyou, o no tiene origin ni dirección, no hace nada, ni siquiera el commit, y avisa una vez por sesión. Las libretas donde solo se agregan renglones (bitácora, registro del barrido, golpes, decisiones, exclusiones, ideas, correcciones y registro de fuentes) juntan los dos lados solas (`.gitattributes`); en cualquier otro archivo que choca, notas incluidas, se queda la versión de esta compu, la otra queda al lado como `<nombre>.remoto.<ext>` y el asistente las junta a mano. Un archivo de más de 100 MB no entra al respaldo: queda solo en la compu y se avisa una vez. Nueva tarea `sistema/tareas/conectar-respaldo.md` para dejar el respaldo en línea con el «sí» del dueño. Probada en Windows (Git Bash) con dos copias de prueba sin internet: 63 de 63; en Mac y Linux no se ha corrido, ni contra GitHub de verdad.
  - El LEEME trae pautas para que no se filtre lo que el dueño no quiere (mover lo privado, apagar conectores, claves que no se abren, por dónde pasa lo leído) y cómo bajar las exportaciones. No se volvió a probar en el banco: lo último medido es la 1.8.

- 1.9.5 · 2026-11-20 · Las claves del negocio viven solo en el 1Password del dueño. Nuevo `sistema/accesos/`: la ventanita (un cuadro aparte donde el dueño escribe una clave sin que pase por el chat y se guarda en 1Password) y el mesero (lleva claves de 1Password a un programa o a un archivo sin que el asistente las vea), en PowerShell y en sh; el asistente abre 1Password con una llave de servicio guardada en la caja de la compu (cifrada en Windows, Llavero en Mac). Nueva alarma de la consola que frena usar 1Password directo, la llave y volcar variables. Nueva tarea `sistema/tareas/conectar-caja-fuerte.md` que instala 1Password avisando (se quita la regla de no instalar nada para 1Password) y lo conecta con el dueño; la llama el cierre del arranque. Probado en Windows contra un cajón de prueba; la ventana para escribir no la ha usado una persona; Mac y Linux sin correr. Codex no corre las alarmas.

- 1.9.4 · 2026-11-19 · Alarmas automáticas en Claude Code (`sistema/alarmas/`, encendidas en `.claude/settings.json`): frenan escribir claves, tarjetas, CLABE, CURP o RFC de persona en una nota, frenan escribir fuera de la carpeta y, al terminar cada turno, revisan `entrada/_paso/` y la línea «Guardé:». Corren con `sh` en Mac, Linux y Windows con Git Bash. Probadas en Windows: 23 de 23 y dos en vivo; en Mac y Linux no. La primera vez que se corre el arranque en una compu, `sistema/tareas/probar-alarmas.md` las prueba y se borra (en Windows se borra sin probar). Codex no las corre.

- 1.9.3 · 2026-11-19 · El asistente aprende solo cómo escribe el dueño desde el primer mensaje, aunque no haya arranque, durante 30 días (`estilo_aprende_hasta` en el estado), y un recordatorio corre en cada mensaje del dueño en Claude Code (`.claude/settings.json`, hooks). Codex no tiene ese recordatorio: le queda la regla de AGENTS.md, punto 2. No se probó en el banco. Además, con ideas tomadas del repo ECC (licencia MIT): dos puestos nuevos en el catálogo (encargado de compras e inteligencia competitiva), mejores recetas en nueve fichas (devoluciones, no mezclar datos de un cliente con otro, seguimiento a prospectos, redes, campañas, web, correo), la regla de pedidos ya cuenta lo que viene en camino, la voz de la marca se arma con textos reales y un «sí» del dueño vale solo para el texto que vio.

- 1.9.2 · 2026-11-18 · Tres cambios chicos y una nota, uno por renglón:
  - El trato (tú o usted) se toma de cómo escribe el dueño, en la charla y en sus conversaciones viejas con la IA: si escribe de tú, se le habla de tú; de usted, solo si él lo usa o lo pide. Si lo pide con palabras, eso manda. Corrige a la 1.9.1, que hablaba de usted a quien escribe de tú.
  - Pedir algo que se va a repetir o que es de un oficio (cotizar, cobrar, comprar, contratar, publicar) ya no se hace como entregable suelto: pasa a crear-empleado.
  - El LEEME dice que el cerebro necesita el modelo mediano o uno mayor (Sonnet u Opus); con Haiku no alcanza para crear empleados.
  - La 1.9.2 no se volvió a probar en el banco: lo último medido es la 1.9.1.
- 1.9.1 · 2026-11-18 · Retoque chico antes de la prueba final, uno por renglón:
  - Al crear o despertar un empleado, la primera oración del mensaje que entrega su primera chamba es «Para…, el puesto es…, porque…»; luego va la pieza completa y luego las preguntas. Nada de «Ya quedó…» ni «Guardé…» antes.
  - El saludo de sesión nueva y la respuesta a «¿qué sabes?» son una sola forma: «Hola, <nombre>.», tus correcciones y costumbres una por renglón (siete como mucho, y «y N más») y lo que falta en una línea. Si preguntaste qué sabe, suma hasta tres renglones del negocio. Diez renglones como mucho.
  - El trato solo cambia si lo pides con palabras; una frase suelta de tú o en tono informal no lo cambia ni se apunta como corrección.
  - Una rutina queda aprobada solo si dices que la deje fija o que se haga cada vez («sí, cada lunes», «déjala así»); pedir la pieza de esta vez se hace, se apunta como pedido y la idea sigue igual.
- 1.9 · 2026-11-18 · Cambios, uno por renglón:
  - La lista de correcciones guarda tres cosas: lo que corriges, lo que cambia en el negocio aunque nadie corrija (algo que se firmó, abrió o suspendió) y lo que pides de forma fija («cada lunes…»).
  - Cada línea de esa lista dice si el dato sale en tu DNA; si sale, el DNA nuevo se saca en ese mismo momento. Esto reemplaza la revisión del DNA al cerrar la sesión, que no se cumplía.
  - Al guardar una corrección busca la palabra o la cifra vieja en todas sus notas, en las fichas de los empleados y en el DNA, y la cambia en cada lugar; lo que queda como historia, va marcado como historia.
  - Si lo que corriges es un error suyo, y no un dato del negocio, va también a su libreta de golpes en ese momento.
  - El saludo de sesión nueva es «Hola» con tu nombre, tus correcciones y lo que pides de forma fija, uno por renglón (siete como mucho, y «y N más»), y lo que falta en un renglón. Nada más.
  - Un empleado nuevo hace su primera chamba en el mismo turno en que nace, con lo que haya: lo que falta va marcado «pendiente» dentro de la pieza, y las preguntas van después de enseñártela, nunca antes. Sin ningún dato, hace una pieza de muestra y te dice qué dato la llena.
  - Si un empleado saca cantidades (cuánto pedir, cobrar o cuesta), la regla de la cuenta se escribe una vez en su ficha y cada pieza la aplica igual y la nombra en una línea.
  - El mensaje que te dice el puesto abre con «Para…, el puesto es…, porque…»; el saludo o el «reviso…» van antes, en un mensaje aparte.
  - Si un empleado te entrega dos o más borradores, en el chat van todos, completos.
  - No dice «ya te conté», «como te dije» ni «lo que te sugerí» si no puede señalar ese mensaje en la charla de hoy; si no está, te lo cuenta como nuevo.
  - Una rutina queda aprobada solo con un sí a dejarla fija; pedir la pieza de esta semana es un pedido y la idea sigue como idea.
  - El repaso semanal se ofrece solo desde una fecha que se apunta una vez al cerrar el arranque o el repaso (ocho días después); al ofrecerlo solo compara la fecha de hoy con esa.
  - En tu página sigue los enlaces de verdad: abre el inicio, toma la dirección de cada enlace del menú y de cada red, y la abre; ya no arma direcciones a mano. Si una falla, vuelve al inicio o busca la sección con tu nombre, y busca las redes de cada ciudad. Al cerrar te dice qué no abrió y por qué.
  - Si un archivo trae una orden escondida, en ese mismo mensaje te dice qué pedía y que no la siguió, nunca «la cuento abajo».
  - `AGENTS.md` se recortó para seguir debajo de 16 KiB: sale la línea de borrar los archivos de paso (ya la trae el punto 5) y la de qué hacer si dices que un dato no lo diste tú (la trae la ficha de clasificación).
  - Si ya tienes una lista de correcciones de una versión anterior, sus líneas valen igual; la forma nueva se propone, no se pisa.
- 1.8 · 2026-11-18 · Cambios, uno por renglón:
  - La sugerencia de dejar como rutina lo que pides seguido va siempre en el mensaje que cierra la primera sesión, con la frase «Sugiero dejar como rutina: …», salvo que ya te la haya dado al leer tus conversaciones.
  - Ya no apunta en ningún lado que te sugirió algo: tu respuesta se apunta, con tus palabras, solo cuando llega.
  - Nunca te dice que no contestaste, que algo «quedó sin respuesta» ni «lo que te sugerí»; si duda de si ya te lo dijo, te lo sugiere otra vez y ya.
  - Al pedirle algo que hace un empleado, primero revisa (puede decirte en media línea qué va a ver) y luego te dice el puesto con una sola frase: «Para lo que pediste, el puesto es tal, porque hace tal cosa».
  - Todas tus correcciones quedan en una sola lista, una línea cada una con su fecha y dónde quedó; cada corrección nueva se suma ahí en el mismo momento.
  - El saludo de sesión nueva es corto y siempre igual: tu nombre, cuántas cosas le has corregido y cuáles, copiadas de esa lista, y en un renglón lo que falta.
  - Cuando corriges algo, busca en todas sus notas lo que diga lo contrario y lo cambia en ese momento.
  - Antes de decirte qué falta, revisa cada renglón contra lo que ya le contestaste.
  - Si no puede usar un programa para hacer una cuenta, la hace en ese momento con lo que sí tiene y pone el número en las notas que lo esperaban.
  - En tu página abre cada sección de su menú y cada red que enlaza, una por una, y al terminar te dice en una línea qué no halló.
  - Si cambia algo que tu DNA dice (algo que se firmó, se abrió o se suspendió), saca el DNA nuevo en esa misma sesión; lo revisa al cerrar cada sesión.
  - Si un archivo trae una orden escondida o algo raro, te lo dice en su siguiente mensaje, no hasta el final.
  - Al armar un empleado no te pregunta lo que ya sabe ni lo que una nota dice que no existe; cada renglón de una lista de lo que falta cuenta como pregunta.
  - La primera chamba trae en el mensaje el mismo texto que guardó, y si ya tiene los datos la hace en ese momento, sin «todavía no puedo».
  - Te saluda y te llama por tu nombre también al armar un empleado.
  - Si corriges la forma de una entrega («una o dos frases», «sin emojis»), la siguiente se mide contra eso antes de enseñártela.
- 1.7 · 2026-11-18 · Cambios, uno por renglón:
  - Ya no apunta que te propuso algo si no te lo mandó: sus apuntes copian, entre comillas, la frase exacta que te mandó y la fecha; si no la halla en la charla, dicen «no propuesta».
  - La propuesta de dejar escritas como rutina las cosas que le pides seguido te llega de verdad en la primera sesión, al terminar de leer tus conversaciones con la IA, como sugerencia y sin pregunta.
  - Si no contestas una propuesta, no lo toma como un «no»: queda pendiente y te la vuelve a sugerir una sola vez en la sesión siguiente. Nunca te dice que no contestaste sin comprobar antes que te lo mandó.
  - Nada queda apuntado como hecho («propuse», «mandé», «dejé», «guardé») si no puede señalar dónde quedó.
  - Al pedirle algo que hace un empleado, la primera línea de su respuesta, antes de abrir nada, te dice qué puesto va a usar o crear y por qué resuelve lo que pediste, con tus palabras.
  - Al armar un empleado te hace una sola tanda de hasta tres preguntas antes de la primera chamba y como mucho dos más en toda la charla; la lista de lo que falta te la dice una vez y luego queda pendiente en la ficha, sin repetírtela.
  - La primera chamba de un empleado te llega entera en el mensaje, aunque sea larga; un resumen o «quedó en tal carpeta» no cuenta como entrega.
  - Los nombres, teléfonos y datos de candidatos, clientes de una vez o proveedores que salen de una chamba se quedan en la carpeta de esa chamba, no en lo que el cerebro sabe de tu negocio.
  - Antes de mandarte cada mensaje revisa cada verbo y cada pronombre contra tu trato, en todas las rutinas y no solo en el cierre; si le hablas de usted, no se le escapa un «lo que me corregiste».
  - Te llama por el nombre o título con que firmas o pides que te digan, y te saluda al abrir cada sesión nueva.
  - En el saludo de sesión nueva cuenta tus correcciones y las nombra todas, una línea corta cada una, después de releer lo de la última sesión; no te pide lo que ya le diste.
  - Lo que dices sin fecha («el martes cierro temprano») se guarda como lo dijiste, con el día en que lo dijiste, no con una fecha calculada.
  - Un dato que sirve a dos temas se apunta en los dos, o en uno con su enlace en el otro; cómo te presentas y desde cuánto se te compra van con tu negocio, y quién te compra y si vuelve, con tus clientes.
  - En la web busca las redes de cada sucursal o marca de cada ciudad y las secciones que anuncia tu página (mayoreo, prensa), y te dice cuáles no halló.
  - Si el buscador solo trae cosas ajenas, entra directo a la página que sale en tus correos o documentos y abre sus secciones una por una.
  - Si corriges un dato que ya trae tu DNA, también saca el DNA de nuevo en esa misma sesión.
- 1.6 · 2026-11-18 · Cambios, uno por renglón:
  - Cuando corriges algo que te entregó un empleado, aunque sea solo la forma, la corrección queda escrita en la ficha de ese empleado antes de rehacerlo, y no en las notas de cómo hablarte; así ese empleado ya no repite el error. Lo hace una rutina nueva, `corregir-chamba`, que se abre sola en cuanto corriges o pides un cambio.
  - Tu corrección se guarda tal como la dijiste: si la limitas a un cliente, un producto o un lugar, no la vuelve regla para todos ni le suma casos que no nombraste.
  - En tu correo ya no se salta la bandeja de Recibidos: las carpetas personales no se abren, las del negocio se leen enteras y las que mezclan las dos cosas se recorren completas por remitente y asunto; abre solo lo del negocio y lo personal solo lo cuenta.
  - Las frases de ejemplo que te dice vienen en forma neutra o en tu trato; si le hablas de usted, no se le escapa un «te sugiero». Antes de cada mensaje de cierre revisa que todo vaya en tu trato.
  - Ya no te dice palabras de máquina como «terminal», «comando» o «parámetro», ni el nombre del programa en que trabaja, salvo que tú lo uses.
  - La primera vez que te nombra a heyyou te dice en media línea quién es (quien te instaló este asistente) y para qué te sirve mandarle tu DNA; si desde aquí no se puede mandar, no te ofrece mandarlo.
  - Si te dice que sigue con algo, sigue en ese mismo mensaje; si necesita tu «sí», te lo pide claro.
  - Antes de guardar algo de una persona o de contarte algo, lo coteja con su fuente: quién le escribe a quién y si cada caso que cuenta es de verdad lo que dice.
  - Al empezar una sesión nueva te dice también, en una línea, lo que todavía falta.
  - En la entrevista, lo que ya vio en tus archivos, correos o conversaciones no te lo pregunta abierto: te dice lo que vio y te pide confirmarlo en la misma pregunta.
  - Si las dos primeras búsquedas no traen tu página, tus redes y sus secciones, busca de otras formas (con tu ciudad, con cada red social, con el dominio de tu correo o folleto, sección por sección) antes de dar la web por vista.
- 1.5 · 2026-11-18 · Cambios, uno por renglón:
  - Ya no te ofrece cosas con preguntas («¿quieres que…?»): te sugiere un solo paso siguiente al final del mensaje («Te sugiero…», «Si quieres, sigo con…»). Solo te pregunta lo que únicamente tú sabes; mandar, publicar o pagar te lo propone en una línea y espera tu «sí».
  - Cuenta sus preguntas en toda la plática, también en el cierre: no te suelta una tanda nueva al despedirse, lo que quedó sin respuesta te lo nombra en una línea y no te lo vuelve a pedir en otro mensaje. Si te dice cuántas preguntas te hará, hace esas.
  - Antes de preguntarte algo, lo busca en todas sus notas, no solo en la del tema.
  - Al armar un empleado, la primera frase que lees es por qué ese puesto resuelve lo que pediste, y la primera chamba te llega completa en el mismo mensaje, ya revisada, sin que tengas que pedir verla.
  - Antes de sacar una conclusión sobre una persona, un correo o un documento, vuelve a leer sus palabras exactas.
  - Si un empleado trabaja con mensajes que tú le pegas de una app que no está conectada, su ficha lo dice.
  - Si no lo dejan guardar un archivo de paso fuera de su carpeta, lo guarda dentro y termina el trabajo; al contarte qué pasó, te dice la causa exacta.
  - En tu correo revisa todos los correos de las carpetas del negocio, no solo los que traen el nombre de tu negocio.
  - Lo que verá el público lo coteja palabra por palabra con su fuente, sin sumarle datos que no dice.
  - Cuando te da una cifra que salió de sumar, te dice qué sumó.
  - Cuánto tiempo pasó lo saca restando fechas, no a ojo; no te sugiere el repaso antes de tiempo.
  - Al cerrar el arranque y al cerrar cada sesión, revisa que sus apuntes de en qué va digan lo que ya le contestaste.
  - Al empezar una sesión nueva te saluda del largo que le pediste y te nombra todas las correcciones que tiene guardadas.
  - Cuando lo corriges, apunta su error en ese mismo momento; si apuntó mal una decisión tuya, la marca como corregida en vez de borrarla.
  - No te dice que algo quedó hasta comprobarlo, y no te pasa sus notas de trabajo.
- 1.4 · 2026-11-18 · Cambios, uno por renglón:
  - Los doce puestos de `empleados/` quedan como ejemplos para empezar: el asistente elige el que de verdad resuelve lo que pides y lo ajusta a tu negocio, o crea un puesto nuevo con su propia ficha, igual de completa que las del catálogo.
  - Te dice en una frase por qué ese puesto resuelve lo que pediste, también cuando es nuevo.
  - Antes de enseñarte la chamba de un empleado, la revisa contra lo que pediste (que responda, que cada dato tenga de dónde salir, que suene a tu negocio y que respete sus límites) y la corrige; tú ves solo la versión final.
  - Si pides algo que se va a repetir, algo que haría alguien de oficio o algo que ya estaba en tus ideas de puestos, arma un empleado aunque no digas «empleado»; una duda de una vez la contesta directo.
  - Al armar un empleado te pide cinco cosas como mucho, y cada dato de una lista cuenta; lo que no contestas queda pendiente y no te lo vuelve a pedir, ni en el cierre.
  - No te pregunta lo que ya está escrito (si una nota trae el dato, lo usa) ni cosas solo para llenar sus libretas, como el porqué de una decisión.
  - Lo que decides para un cliente o una vez queda como eso, no como regla para todos.
  - Cuando corriges a un empleado, cambia todo lo de su ficha que choque con tu corrección, no solo una parte.
  - No te cuenta cómo guardó las cosas ni con qué: te dice qué quedó.
  - Lo que te dice que te deja (un borrador, una lista) ya está hecho y te dice dónde quedó.
  - Lo que pediste tres veces o más en tus conversaciones con la IA te lo propone en cuanto termina de leerlas, no al final.
  - Te habla en palabras de tu negocio, sin nombres de sus archivos ni de cómo se ordena por dentro.
  - La entrevista no gasta preguntas en lo que ya leyó: las usa en lo que solo tú sabes, empezando por tus metas de los próximos tres meses.
  - En tu página abre cada sección que anuncia y las redes que nombran tus documentos, y guarda la dirección completa de cada sucursal.
  - Al empezar una sesión nueva te dice primero lo que le has corregido; nunca dice que no lo has corregido si tiene algo guardado.
  - Tu correo se busca siempre solo en las carpetas del negocio, en cualquier sesión; si ve algo personal por error, no lo guarda y te lo dice.
  - Lo que pides que lleve una página o un texto, lo lleva; si cree que algo no conviene, te lo pregunta antes y no lo quita sin tu «sí».
  - Antes de decirte qué falta, busca en lo que ya sabe y en lo que leyó en la sesión.
- 1.3 · 2026-11-18 · Cambios, uno por renglón:
  - Cuando corriges el trabajo de un empleado, la corrección queda en la ficha de ese empleado, no en las notas de cómo hablarte; lo rehace en el acto, te lo enseña completo y, antes de su siguiente entrega, la compara con la versión que corregiste.
  - La libreta de errores guarda solo los errores del asistente; cómo hablarte queda en su nota y lo de cada empleado en su ficha.
  - Una conexión de un empleado solo cuenta como revisada si trae algo leído de ahí y la fecha; si no, dice por qué no y cómo se trabaja mientras. Al despertarlo se intentan todas las conexiones de la sesión.
  - Si la app niega un paso del arranque, se salta solo ese paso; las demás fuentes que aprobaste se revisan igual.
  - Tus conversaciones con la IA se leen siempre; lo que pediste tres veces o más se te propone como rutina en esa misma sesión, sin esperar al cierre.
  - La web se busca aunque otra fuente falle, se abren las páginas internas con datos y lo que se descarga se queda dentro de la carpeta.
  - Un documento leído a medias no da conclusiones: la herramienta avisa arriba cuánto falta y el asistente lee el resto antes de concluir.
  - El correo se revisa en la sesión en que das permiso, también lo enviado, y cada dato va a su tema: reclamos, elogios, condiciones que pones y lo que piden y no tienes.
  - Si te vas a media entrevista, el arranque cierra con lo que tiene, te deja el DNA y te dice qué queda; si una sesión lo encuentra sin cerrar, lo termina sin preguntarte. La entrevista te dice al empezar cuántas preguntas son.
  - El asistente no dice por qué no revisó algo si no lo comprobó, y no usa una cifra que tú marcaste como sin confirmar.
  - El estado se corrige en el momento en que contestas algo que estaba en duda; al abrir sesión revisa lo que ya sabe y aplica tus costumbres sin volver a preguntar.
  - Si le escribes de tú, te habla de tú desde el siguiente mensaje.
  - Lo que pides se entrega como lo pediste; lo que cambiaría te lo propone en una línea, y lo que no sabe te lo pregunta.
  - Cada frase de un análisis trae su número y de dónde salió, o dice qué falta y quién lo tiene.
  - Al despertar un empleado: busca en todo lo guardado, también en la ficha de cada cliente, antes de preguntarte; cuenta como pregunta también lo que te pide para después; lo que dijiste que buscas luego no te lo vuelve a pedir; pone al día la ficha cada vez que contestas; te dice en una frase por qué ese puesto, y de qué fechas buscó en el correo.
  - Si dices que un dato guardado no lo diste tú, te dice de dónde salió y con qué fecha, te pregunta si lo cambia y deja de usarlo mientras.
  - La ficha de clasificación dice a dónde va un reclamo, un elogio, una condición escrita y lo que piden y no hay.
- 1.2 · 2026-11-18 · Cambios, uno por renglón:
  - Entrevista: cliente ideal, herramientas y voz de la marca se suman a lo que solo sabe el dueño; lo que solo él sabe cuenta como lleno solo con su confirmación.
  - Entrevista: antes de cerrar se repasan las partes una por una, en una lista de comprobación, y las preguntas que quedan se gastan en lo vacío.
  - `preguntas_hechas` sale de contar en la charla, no del tope, y el estado suma `entrevista_sin_dato`.
  - Lo que se cuenta con palabras (a quién le vende, cómo es su cliente, qué lo distingue) se pregunta abierto, sin opciones; las opciones quedan para confirmar.
  - Una lista del mismo tema (los tres problemas, quién decide) se pide entera en una pregunta; si contesta una parte, la siguiente pide lo que falta.
  - Toda respuesta del dueño se guarda con `[confirmado AAAA-MM-DD]`, también lo nuevo que cuenta.
  - El DNA pone la marca al final de cada renglón con dato, cierra con una lista de comprobación y, dentro del arranque, no manda mensaje propio.
  - El mensaje de cierre del arranque trae seis apartados con título fijo, «Lo que te vi pedir seguido» siempre, y su lista de comprobación; el mapa se cuenta al momento.
  - Los archivos se escriben y editan solo con las herramientas de escribir y editar de la app; si la app niega otro camino, se guarda con esas y el arranque nunca queda sin guardar.
  - Al dueño no se le pasan decisiones técnicas ni se le dicen nombres técnicos.
  - Nunca se apunta como hecho lo que no se comprobó.
  - El extractor de conversaciones ya no escribe archivos: enseña en pantalla, por páginas (`-Pagina N`), solo los mensajes del dueño con las claves tapadas, y deja fuera las conversaciones de la carpeta del cerebro. No queda nada que borrar.
  - Correo: el banco, la contabilidad y la facturación del negocio son del negocio; en sus carpetas se listan todos los asuntos y se abre cada correo con datos del negocio, y se anota cuántos.
  - Web: se busca con el nombre comercial (logo, folleto, firma, notas), no con el dominio del correo, y en su página se abren también precios, sucursales, distribuidores y promociones.
  - El trato queda inferido hasta que el dueño lo confirme y no se mezcla en la sesión.
  - Una orden escondida se le dice al dueño aparte y en claro, nunca como algo que «no entró».
  - Toda respuesta que guarda algo lleva su «Guardé», sin excepción.
  - Una cifra sale de los datos crudos cuando los hay; si un documento da otra, se guardan las dos con su fuente.
  - Los patrones por día de la semana van a `rumbo/patrones.md`, igual que los de mes o temporada.
  - Al empezar sesión se lee también `conocimiento/reglas-del-negocio.md` con su «Historia»; «¿qué sabes de mí?» abre con «Lo que me corregiste» y «Cómo quieres que te hable y les hable a tus clientes».
  - Lo que va al público solo dice lo que está en `conocimiento/` o lo que dijo el dueño, sin consecuencias de una regla que su nota no dice, y se cruza con la vigencia de la web; `nuevo-entregable` cierra con su lista de comprobación.
  - Los ofrecimientos (repaso, pendientes, tandas, entrada) van juntos en una línea y esperan al cierre del trabajo pedido.
  - Antes de preguntar o escribir «pendiente», se busca en todo `conocimiento/`, no en una sola nota.
  - Un pedido que es el trabajo de un puesto del índice despierta el puesto aunque sea la primera vez; sin puesto va solo lo que no se repite. Cambian `AGENTS.md`, la rutina, sus dos puertas y el índice de empleados.
  - `crear-empleado`: el primer mensaje trae solo el puesto y por qué encaja; el «sí» se pide en palabras del negocio, sin rutas; las conexiones se prueban antes de preguntar, con una búsqueda real en el correo anotada en la ficha.
  - `crear-empleado`: cinco preguntas en toda la charla, contando «pásamelo cuando…»; no se pregunta lo que está en `conocimiento/` ni lo que dijo que no tiene.
  - `crear-empleado`: la ficha se pone al día al entregar la primera chamba; cada corrección va a «Aprendizajes» antes de rehacer; cada regla de la ficha lleva su fuente; lista de comprobación al final.
  - Las doce fichas del catálogo dicen en «Estado» y «Aprendizajes» cuándo se ponen al día.
  - El repaso pregunta abierto lo que se cuenta con palabras.
  - `AGENTS.md` se acortó (la lista de rutinas y frases que ya viven en las rutinas) para seguir debajo de 16 KiB.
  - Dos ejemplos de la ficha de clasificación cambian de palabras.
- 1.1 · 2026-11-18 · Cambios, uno por renglón:
  - El aviso del arranque sale siempre y primero, palabra por palabra, de tú y de usted; antes de su respuesta solo se leen archivos del cerebro.
  - El trato del primer mensaje se copia; si es formal o no se nota, de usted.
  - El inventario revisa por nombre todas las carpetas del usuario, también Imágenes.
  - Las rutas salen solo de `carpeta_personal`: sin variables del sistema y sin subir de carpeta.
  - Los archivos de paso van a `entrada/_paso/` y se borran al terminar, nunca a la carpeta temporal del sistema.
  - El correo se busca solo en las carpetas o etiquetas del negocio, y se dice con exactitud qué enseñó una búsqueda.
  - La web se busca de corto a largo, con el dominio obvio y las redes que nombran sus documentos, sin atribuirle un negocio ajeno.
  - La entrevista confirma citando la fuente, hace una pregunta por renglón, siempre ofrece «No sé» y «Luego» y repasa los temas que solo sabe el dueño antes de cerrar.
  - La ficha de clasificación trae «destinos fijos» que mandan sobre la calificación: dinero, zonas, clientes, quejas, patrones, tareas a mano, quién decide, cifras con reparto y lo que un documento ya define.
  - El DNA nunca suma datos: todo vive antes en `conocimiento/`.
  - Reglas de verdad: ni fecha ni causa que la fuente no trae, lo inferido marcado, lo que dice de sí sale contado de los archivos y nada que el dueño no eligió.
  - El cierre del arranque deja `sistema/estado.md` limpio, con `carpeta_personal` en su campo.
  - Si la app niega algo, no se reintenta ni se rodea por otro camino: se dice qué se quería y qué hay que aprobar.
  - Una corrección reemplaza el dato, deja su línea en «Historia» y se aplica en la salida siguiente.
  - Las fechas quedan como las dio el dueño en cualquier archivo, título o encabezado.
  - Lo que va a publicarse lleva todos los precios y escalones, la voz de la marca y cada dato cruzado con lo guardado.
  - Sin imágenes, el entregable trae la maqueta y las instrucciones listas para pegar en una herramienta de imágenes.
  - «¿Qué sabes de mí?» se contesta en diez renglones, con sus correcciones y preferencias primero y en el largo que él pidió.
  - Pedir a alguien despierta un empleado (punto 17 de `AGENTS.md`), con disparadores también en las puertas.
  - `crear-empleado` reescrita: preguntas antes de la ficha, cinco como mucho, ficha activa sin texto de plantilla, conexiones probadas de verdad y correcciones en la salida siguiente y en «Aprendizajes».
  - Las fichas usan la voz de la marca para lo que va a clientes, la forma nueva de anotar conexiones y dos estados: dormido y activo.
  - El índice de empleados trae la forma de «Ideas de puestos».
  - `permiso` cambia `solo-estas` por `solo-algunas`; el valor viejo vale igual.
- 1.0 · 2026-11-17 · Primera versión: arranque que revisa la compu, los conectores, las conversaciones y la web; clasificación por las 30 P; DNA al cerrar el arranque; repaso semanal; entregables en `trabajo/`; puertas para Claude Code y Codex.
