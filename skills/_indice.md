# Skills

Para qué sirve: las pericias (skills) que el asistente ya sabe hacer para este negocio: cada una es un paso a paso escrito para un trabajo que se repite (cotizar, cobrar, contestar clientes, ordenar la semana). El asistente las usa solo, sin que el dueño diga «skill», en cuanto pide algo que encaja. Lo que el dueño les corrige vive en `_aprendizajes.md`; las de terceros que se pueden instalar, en `_recomendadas.md`.

## Reglas de todas las skills

- Cada skill vive en `skills/<nombre>/SKILL.md` y tiene sus puertas en `.claude/skills/<nombre>/` y `.agents/skills/<nombre>/`, para que Claude Code, Codex y Copilot la encuentren.
- Antes de usar una, el asistente lee su sección de `skills/_aprendizajes.md` y las notas de `conocimiento/` que ella nombra. Enlaza el conocimiento; nunca lo copia.
- Una skill nunca manda, publica, paga ni borra nada sola. Cada una de esas acciones pasa por el «sí» del dueño, dado en la conversación.
- Lo que entrega va a `trabajo/`, con `sistema/rutinas/nuevo-entregable.md`.
- Si pide algo que se repite y ninguna skill lo resuelve, se arma una a la medida con `sistema/rutinas/crear-skill.md`.

## Las skills

Estados: `disponible` (de fábrica, todavía sin estrenar), `en uso desde AAAA-MM-DD` y `del dueño` (la creó para este negocio; una versión nueva nunca la pisa).

| Skill | Para qué sirve | Notas que consulta | Estado |
| --- | --- | --- | --- |
| [cotizar](cotizar/SKILL.md) | Armar cotizaciones con las reglas de precio y marcar lo que se sale | P09, P05, REG | disponible |
| [responder-clientes](responder-clientes/SKILL.md) | Borradores para las preguntas, dudas y quejas de los clientes | P09, P04, P28, REG | disponible |
| [cobrar](cobrar/SKILL.md) | Mensajes de cobranza y la lista de a quién tocarle | REG, P16, P17 | disponible |
| [contenido-para-redes](contenido-para-redes/SKILL.md) | Ideas, textos y plan semanal para redes | P06, P22, P24 | disponible |
| [propuesta-comercial](propuesta-comercial/SKILL.md) | Propuesta para un cliente: problema, alcance, precio y siguiente paso | P09, P08, P23, P24 | disponible |
| [prospectar](prospectar/SKILL.md) | Buscar clientes nuevos y escribir el primer mensaje | P08, P09, REG | disponible |
| [dar-seguimiento](dar-seguimiento/SKILL.md) | Retomar a quien preguntó precio y no contestó | P08, P09, REG | disponible |
| [investigar-competencia](investigar-competencia/SKILL.md) | Qué hacen los competidores y qué decidir con eso | P22, P25, P15 | disponible |
| [revisar-numeros](revisar-numeros/SKILL.md) | Revisar ventas, márgenes y gastos de un Excel | P05, P16, P17 | disponible |
| [minuta-de-junta](minuta-de-junta/SKILL.md) | Acuerdos, responsables y fechas de una junta | P01, P07, P18 | disponible |
| [documentar-un-proceso](documentar-un-proceso/SKILL.md) | Convertir lo que alguien hace en un paso a paso | P02, P04, P26 | disponible |
| [plan-de-la-semana](plan-de-la-semana/SKILL.md) | Ordenar la semana: qué importa, qué delegar y qué soltar | P13, P07, P31 | disponible |
| [contratar](contratar/SKILL.md) | Vacante, anuncio, entrevista y comparación de candidatos | P01, P05, P26 | disponible |
| [aprender-ia](aprender-ia/SKILL.md) | Tutor de IA con ejemplos del propio negocio y siguiente paso | P31, P26, P03 | disponible |
| crear-skill (rutina: `sistema/rutinas/crear-skill.md`) | Armar una skill nueva a la medida a partir de lo que el dueño pide seguido | `skills/` | disponible |

## Ideas de skills

Aquí caen, antes de ser skill, las tareas que el dueño dice que podría hacer la IA (la P20) y las que alguien del negocio hace a mano cada semana, con la skill que más ayudaría. El asistente la lee primero al elegir skill, y el cierre del arranque la usa para sus ideas de primeros usos. Si el dueño pide una de estas tareas, se sigue `sistema/rutinas/crear-skill.md`.

Forma: `- AAAA-MM-DD · <la tarea> · quién la hace hoy y cada cuánto · skill que ayudaría: <de la tabla o nueva> · <marca> · en qué va: idea`

Ejemplo de forma, no una idea real: `- 2026-11-17 · contestar por mensaje si un pedido ya está listo · la encargada, toda la tarde · skill que ayudaría: responder-clientes · [confirmado 2026-11-17] · en qué va: idea`

Cuando se estrena o se crea la skill, «en qué va» cambia a `en uso: <skill> AAAA-MM-DD` o `creada: <skill> AAAA-MM-DD`. La tarea en sí vive en `conocimiento/equipo/`; aquí va solo la idea, con el enlace.

Nada todavía.

## Skills del dueño

Las que el dueño crea (o convierte de un puesto de una versión anterior) con `sistema/rutinas/crear-skill.md` van en la tabla de arriba con estado `del dueño`, y también en `sistema/version.md`, en «Skills del dueño». Las fichas viejas de una migración esperan en `skills/_viejos/`.
