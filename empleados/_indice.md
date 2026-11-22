# Empleados

Aquí viven los puestos de este negocio: un catálogo de ejemplos para empezar, los que ya se despertaron, los que se crearon a la medida y las ideas de puestos.

## Catálogo de ejemplos

Estas catorce fichas son ejemplos de puestos que un negocio suele tener. Sirven de inspiración y punto de partida; no son la lista cerrada de lo que este negocio puede tener. Todas nacen dormidas. Cuando el dueño pide una tarea que se va a repetir, algo que hace un oficio o algo que ya está en «Ideas de puestos», aunque no diga «empleado» (AGENTS.md, punto 17), la rutina [crear-empleado](../sistema/rutinas/crear-empleado.md) elige el puesto que de verdad resuelve lo que pidió y lo ajusta a este negocio; si ninguno lo resuelve, crea uno nuevo, con nombre de oficio y su ficha hecha con el molde de esa rutina, y le suma aquí su renglón. Los estados son dormido y activo.

| Puesto | Qué le quita al dueño | Estado |
| --- | --- | --- |
| [Asistente personal](asistente-personal.md) | El resumen diario de correo y agenda, y los borradores de respuesta | dormido |
| [Cotizador](cotizador.md) | Cotizar con sus reglas de precio y escalar lo que no le toca | dormido |
| [Vendedor](vendedor.md) | Dar seguimiento a quien pidió precio y desapareció | dormido |
| [Prospectador](prospectador.md) | Buscar clientes nuevos y redactar el primer mensaje | dormido |
| [Customer Success](customer-success.md) | Contestar las preguntas de siempre con un borrador listo | dormido |
| [Community Manager](community-manager.md) | Ideas y textos para redes | dormido |
| [Creador de contenido](creador-de-contenido.md) | Imágenes y piezas de campaña, si la app puede | dormido |
| [Constructor de sitios](constructor-de-sitios.md) | Páginas y cambios a la web | dormido |
| [Analista](analista.md) | Reportes y tableros desde Excel o su sistema | dormido |
| [Controller](controller.md) | Márgenes, flujo de efectivo y fugas del negocio | dormido |
| [Auxiliar administrativo](auxiliar-administrativo.md) | Facturas, documentos y papeleo | dormido |
| [Director de marketing](director-de-marketing.md) | Ventas y publicidad del día anterior, embudo y campañas | dormido |
| [Encargado de compras](encargado-de-compras.md) | Qué pedir, cuánto y cuándo, sin pedir doble ni quedarse sin | dormido |
| [Inteligencia competitiva](inteligencia-competitiva.md) | Saber qué hace la competencia y qué decidir con eso | dormido |

## Otros ejemplos

Más ideas de puestos, todavía sin ficha. Tampoco es una lista cerrada: si el dueño pide uno de estos, o un puesto que no está en ninguna lista, `crear-empleado` lo crea con su molde, le suma su renglón a la tabla de arriba y, si estaba aquí, lo quita de esta lista.

- Director Comercial
- Director de Operaciones
- Clon del CEO
- Project Manager
- Encuestador
- Capacitador
- Auxiliar Contable
- Editor de video
- Estratega de YouTube
- Diseñador de presentaciones
- Comprador de medios
- Recepcionista

## Ideas de puestos

Aquí caen, antes de ser un puesto, las tareas que el dueño dice que podría hacer la IA (la P20 de `sistema/clasificacion.md`) y las que alguien del negocio hace a mano cada semana, con el puesto de IA que más ayudaría. La rutina `crear-empleado` la lee primero al elegir puesto, y el cierre del arranque la usa para sus ideas de primeros usos. Si el dueño pide una de estas tareas, se sigue `crear-empleado`, aunque no hable de un empleado.

Forma: `- AAAA-MM-DD · <la tarea> · quién la hace hoy y cada cuánto · puesto que ayudaría: <ficha del catálogo o uno nuevo> · <marca> · en qué va: idea`

Ejemplo de forma, no una idea real: `- 2026-11-17 · contestar por mensaje si un pedido ya está listo · la encargada, toda la tarde · puesto que ayudaría: Customer Success · [confirmado 2026-11-17] · en qué va: idea`

Cuando se despierta o se crea el puesto, «en qué va» cambia a `despertado: <puesto> AAAA-MM-DD`. La tarea en sí vive en `conocimiento/equipo/`; aquí va solo la idea, con el enlace.

## Ideas

Nada todavía.
