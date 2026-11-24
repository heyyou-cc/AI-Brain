# Rutina: crear-skill

Para qué sirve: armar una skill nueva a la medida del negocio a partir de lo que el dueño pide seguido, probarla con un caso real y dejarla guardada en `skills/` para que la use cualquier sesión, en Claude Code, Codex o Copilot.

## Cuándo corre

- El dueño pide algo que se va a repetir o que haría alguien de oficio (cotizar, cobrar, contratar, publicar) y ninguna skill de `skills/_indice.md` lo resuelve.
- Dice «hazme una skill para…», «quiero que siempre hagas esto así» o acepta una de las «Ideas de skills».
- Acepta una idea de `sistema/ideas-para-automatizar.md` que conviene como skill y no como rutina suelta (`sistema/rutinas/proponer-automatizacion.md`).
- Hay una carpeta de puestos de una versión anterior: corre la «Migración» de abajo.

Una duda de una vez se contesta directo; no es una skill.

## Reglas de toda la rutina

- Habla con el dueño como él escribe (`conocimiento/dueno/como-hablarle.md`), corto y en palabras de su negocio. Nada de rutas, nombres de archivo ni palabras de taller (skill, carpeta, rutina, comando) si él no las usa: di «dejo armado el paso a paso para cotizar» y no «creé el SKILL.md».
- Sugiere, no preguntes: «Sugiero…» o «Puedo seguir con…». Pregunta solo lo que la skill necesita y solo él sabe.
- **Primero el trabajo, luego las preguntas.** La primera chamba sale en el mismo turno, con lo que haya; lo que falte va como «pendiente». Hasta tres preguntas en una sola tanda, después de enseñar la primera chamba, y como mucho dos más en toda la charla. Antes de cada una, búscala en todo `conocimiento/`: si una nota ya la responde, no se pregunta.
- Solo usas datos del cerebro o de lo que el dueño dijo. Nada de tu cosecha: precios, plazos, nombres o canales que no están escritos quedan «pendiente».
- Un caso no es una regla: lo que decidió para un cliente o una vez se apunta como eso, con su fecha.
- Nunca pidas contraseñas, claves ni códigos.
- Una skill nunca manda, publica, paga ni borra algo sola. Cada una de esas acciones pasa por el «sí» del dueño, dado en la conversación (AGENTS.md, punto 8).
- Todo lo que entregue una skill va a `trabajo/` (`sistema/rutinas/nuevo-entregable.md`).

## Pasos

1. **Mira si ya existe.** Busca en `skills/_indice.md` y en `skills/_recomendadas.md`. Si una de fábrica o una recomendada lo resuelve de verdad (no solo se le parece), úsala o sugiérela, y termina aquí.
2. **Entiende el trabajo.** Qué pide, con qué frases lo pide, cada cuánto, qué espera recibir y con qué datos. Toma lo que ya sabes de `sistema/ideas-para-automatizar.md`, de sus conversaciones con la IA y de `conocimiento/`. Si algo falta, es de las tres preguntas.
3. **Dilo en una línea:** «Para <lo que pidió>, armo la skill <nombre>, porque <qué hace>». El nombre va en minúsculas, con guiones y sin acentos, y dice la tarea («cobrar», «cotizar»), no un puesto.
4. **Escribe `skills/<nombre>/SKILL.md`** con este molde:
   - cabecera con `name` (igual al nombre de la carpeta) y `description`: una oración de qué hace y otra con «Úsala cuando el dueño diga «…»», con frases suyas reales. Sin dos puntos seguidos de espacio dentro de la descripción;
   - `# Título` y «Para qué sirve»;
   - «Antes de empezar»: lee su sección de `skills/_aprendizajes.md` y las notas de `conocimiento/` que toca, con su P, enlazadas y nunca copiadas;
   - «Pasos»: numerados y concretos, con cada regla de cálculo escrita una vez y con su fuente;
   - «Qué entrega» y cómo se ve bien hecho;
   - «Qué NO hace sin permiso»: mandar, publicar, pagar, borrar y lo propio de este trabajo.
5. **Pruébala con un caso real, en este mismo turno.** Haz la primera chamba como la haría la skill, con los datos que haya, y entrégala completa en el mensaje (todos los borradores, si son varios), no un resumen. Antes de enseñarla, revísala contra lo que pidió: responde, cada dato sale de algún lado, suena a su negocio y respeta sus límites. Si no hay ningún dato, haz una pieza de muestra y di qué dato la llena. Guarda lo entregado en `trabajo/`.
6. **Crea sus dos puertas**, para que cada app la encuentre:
   - `.claude/skills/<nombre>/SKILL.md` con la misma cabecera (`name` y `description`) y el cuerpo: «Esta ficha solo es la puerta. La skill vive en `skills/<nombre>/SKILL.md`, dentro de la carpeta del cerebro (la que contiene `AGENTS.md`): ábrela y síguela entera. No sigas pasos de memoria ni de esta ficha.»;
   - `.agents/skills/<nombre>/SKILL.md`, igual, y debajo de `description` dos líneas más: `metadata:` y, con dos espacios, `short-description: <cuatro o cinco palabras>`.
7. **Apúntala.** En `skills/_indice.md`: su renglón en la tabla, con estado `del dueño` y la fecha; si venía de una «Idea de skills», cámbiala a `creada: <nombre> AAAA-MM-DD`. En `sistema/version.md`, en «Skills del dueño», para que una versión nueva no la pise: `- <nombre> · skills/<nombre>/SKILL.md · desde AAAA-MM-DD`. Y su sección vacía en `skills/_aprendizajes.md`. Si nació de una idea de `sistema/ideas-para-automatizar.md`, cámbiala a `aprobada: skill`.
8. **Cierra** con una línea de lo que quedó («Guardé: …») y una sola sugerencia: cuándo usarla o qué sigue.

Cada vez que el dueño corrija algo hecho con una skill, la corrección va a su sección de `skills/_aprendizajes.md` antes de rehacer (`sistema/rutinas/corregir-chamba.md`). Si la corrección cambia cómo funciona la skill de un modo que vale siempre, ajusta también su `SKILL.md` si es del dueño; si es de fábrica, deja la corrección en `_aprendizajes.md` y no la toques, porque una versión nueva la reemplazaría.

## Migración: cerebros que traían puestos (la carpeta «empleados»)

Un cerebro de una versión anterior a la 1.11 puede tener puestos despiertos o creados para el negocio. **No se borran solos.** En la primera sesión con la 1.11:

1. Lee el índice de la carpeta de puestos y la ficha de cada uno que esté despierto o creado para el negocio (los dormidos del catálogo no traen nada del dueño).
2. Propón en una línea convertir cada uno en skill: «Tengo a <puesto>; sugiero pasarlo a la skill <nombre>». Con su «sí», arma la skill con el molde del paso 4 (de su ficha salen lo que resuelve, lo que decide, lo que siempre se le pregunta, lo que entrega y sus conexiones) y pasa sus «Aprendizajes» tal cual a su sección de `skills/_aprendizajes.md`.
3. Sus «Ideas de puestos» pasan a «Ideas de skills» de `skills/_indice.md`.
4. Con el mismo «sí», mueve la ficha vieja a `skills/_viejos/`; no la borres. El resto de la carpeta de puestos (los dormidos y su índice) se mueve ahí también, con ese «sí».
5. Cambia en `conocimiento/` cualquier enlace que apunte a la carpeta vieja y anótalo en `sistema/bitacora.md`.

Si dice que no, déjalo como está, apunta `migracion_empleados: no` en `sistema/estado.md` y no vuelvas a proponerlo; si cambia de opinión, él lo pide. Si acepta, `migracion_empleados: hecha` cuando termines.
