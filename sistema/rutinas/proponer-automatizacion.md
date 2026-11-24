# Rutina: proponer-automatizacion

Para qué sirve: ver lo que se repite en el negocio, apuntarlo como idea y proponérselo al dueño, ya sea como rutina o como automatización. Armar cualquiera de las dos pide su «sí».

## Rutina o automatización

- **Rutina:** un método escrito que el agente sigue cuando el dueño se lo pide («haz el corte de ventas»). Vive en `sistema/rutinas/<nombre>.md` y no corre sola.
- **Automatización:** algo que pasa solo cuando ocurre algo (llega un correo, se cumple una fecha, entra un pedido), sin que nadie lo pida. Necesita que la app tenga conectado lo que hace falta y permita tareas programadas, o una herramienta aparte.

Casi siempre conviene empezar por la rutina: cuando ya salió bien varias veces, se propone volverla automática.

## Cuándo proponerla

- Viste lo mismo tres veces: en sus conversaciones con la IA, en sus correos, en sus archivos (tres cortes de ventas, tres cotizaciones iguales, el mismo aviso cada mes).
- El dueño dice que pasa seguido: «cada lunes…», «cada que entra un pedido…», «a fin de mes siempre…».
- El dueño pregunta qué se podría automatizar: lee `sistema/ideas-para-automatizar.md` y lo que sepas de su semana en `conocimiento/`.
- En el arranque: lo que pidió tres veces o más va siempre en el mensaje de cierre, como «Sugiero dejar como rutina: …», todo junto en esa línea (`sistema/rutinas/arranque.md`, fase `cierre`). Si ya lo sugeriste al terminar de leer sus conversaciones, en el cierre no se repite.

Primero termina lo que pidió. La sugerencia va cuando el trabajo terminó (si corre una rutina, en su cierre), en una línea, y una a la vez; nunca en el primer mensaje ni en medio de otra rutina o de una skill. La única excepción es la del arranque, que las nombra todas juntas. Si ya dijo que no, no insistas: queda como `descartada`.

**Nunca le digas que no contestó**, que algo «quedó sin respuesta» ni «lo que te sugerí» (de usted: «lo que le sugerí») de una sugerencia de rutina. Si dudas de si ya se la mandaste, sugiérela otra vez, como si fuera la primera, y ya.

Si lo que se repite es trabajo de un oficio («cada semana alguien tiene que contestar…»), no es una rutina suelta: es una skill (AGENTS.md, punto 17, `skills/_indice.md` y `sistema/rutinas/crear-skill.md`).

## Cómo apuntarla

Agrégala a `sistema/ideas-para-automatizar.md` con la forma de ese archivo. Di de dónde salió (lo dijo él o lo viste tú, y dónde) y marca como cálculo tuyo el tiempo que ahorra.

## Cómo proponerla

Una línea con lo que gana el negocio, como sugerencia y no como pregunta, al final del mensaje y en el trato del dueño. De tú: «Cada lunes me pides el corte de ventas del Excel. Te sugiero dejarlo escrito como rutina para que salga siempre igual; te ahorraría como media hora a la semana. Si me dices que sí, lo escribo»; de usted: «Cada lunes me pide el corte de ventas del Excel. Le sugiero dejarlo escrito como rutina para que salga siempre igual; le ahorraría como media hora a la semana. Si me dice que sí, lo escribo». Va sin signo de pregunta.

**Al sugerirla no apuntas nada.** La idea sigue en `idea`; no escribas «propuesta», «sugerida» ni «sin respuesta» en ningún archivo en el turno en que la mandas. **Lo que conteste se apunta en el turno en que llega su respuesta**, con sus palabras y la fecha, en «Contestó» de la idea. «En qué va» pasa a `aprobada` solo si dice que la deje fija o que se haga cada vez («sí, cada lunes», «déjala así», «que salga así cada semana»), y a `descartada` con un «no». **Pedir la pieza no es aprobar la rutina:** si contesta «prepárame el resumen del lunes» o «hazme la de esta semana», haces esa pieza y la apuntas como pedido: en «Contestó», «pidió la pieza del AAAA-MM-DD, no la rutina», y la idea sigue en `idea`. Si dudas, sigue en `idea`.

Antes de mandarla, comprueba:

- [ ] Va como sugerencia, en una línea, al final del mensaje, sin signo de pregunta.
- [ ] Revisaste cada verbo y cada pronombre contra el trato guardado del dueño: de usted, nada de «te», «tu», «pediste», «quieres»; de tú, nada de «le», «su», «pidió».
- [ ] En este turno no escribiste en ningún archivo que se la propusiste.
- [ ] Ninguna idea pasó a `aprobada` sin que dijera que la deje fija o que se haga cada vez («sí, cada lunes», «déjala así»); un pedido de la pieza de esta vez se hizo, se apuntó como pedido y la dejó en `idea`.
- [ ] El mensaje no dice que no contestó, que algo quedó sin respuesta ni «lo que te sugerí».

## Si acepta una rutina

Acepta solo si dijo que la deje fija o que se haga cada vez («sí, cada lunes», «déjala así»); pedir la pieza de esta vez no cuenta.

1. Escríbela en `sistema/rutinas/<nombre>.md` (nombre corto, en minúsculas, sin acentos ni espacios). Lleva: para qué sirve en la primera línea; qué necesita para empezar (enlaza las notas de `conocimiento/`, no las copies); los pasos en el orden en que se hicieron de verdad, nada de pasos imaginados; qué revisa el dueño antes de que salga (si manda algo a un cliente o cuesta dinero, siempre); cómo se ve un buen resultado (enlaza uno aprobado en `trabajo/` si lo hay); y las líneas de `sistema/golpes.md` que la tocan.
2. Escribe sus dos puertas, cortas, que solo apuntan a la rutina:
   - `.claude/skills/<nombre>/SKILL.md` (Claude Code), con `name` y `description` arriba entre guiones;
   - `.agents/skills/<nombre>/SKILL.md` (Codex), con `name`, `description` y `metadata.short-description`.
   Copia la forma de las puertas de `arranque` y cambia el nombre, la descripción y la ruta. La app te pedirá permiso para escribir ahí: es normal.
3. Agrega la rutina a la lista «Rutinas» del dueño en `sistema/version.md`, para que una versión nueva del cerebro no la pise.
4. Márcala `sin probar` en la primera línea hasta que se use una vez siguiéndola al pie de la letra y salga bien. Cambia la idea a `armada` con la fecha.
5. Cada corrección del dueño al resultado va a la rutina, no a las reglas generales. Si falla tres veces por lo mismo, propón reescribirla en vez de seguir parchándola.

## Si acepta una automatización

- No armes nada sin su «sí»: una tarea que corre sola siempre pasa por él (AGENTS.md, punto 8).
- Comprueba qué tienes en esta sesión. El agente solo ve los correos o mensajes que revisa cuando se lo piden; no vigila nada solo. Si la app no tiene conectado lo que hace falta o no permite tareas programadas, dilo claro y deja la idea en `aprobada`, con lo que falta.
- Si la automatización le manda algo a un cliente, que al principio lo deje listo para que el dueño lo revise, sin mandarlo. Cuando haya salido bien varias veces, él decide si ya puede mandarlo solo.
- Al armarla, cambia la idea a `armada` con la fecha y di dónde vive y cómo se apaga.
