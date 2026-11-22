# Mapa del conocimiento

Para qué sirve: dice dónde vive cada P del negocio, cuántas notas tiene cada carpeta y qué tan llena está. Es lo primero que lee un agente antes de buscar o guardar algo.

Actualizado: pendiente (el cerebro todavía no tiene notas del negocio).

| Carpeta | Qué guarda | P y secciones del DNA | Notas | Qué tan llena |
| --- | --- | --- | --- | --- |
| `dueno/` | El dueño como quien decide: su rol, su día de trabajo, qué lo mueve como empresario, cómo decide, cómo trabajar con él y cómo hablarle | secc. 3 (de 3.1 a 3.6) | 3 plantillas | vacía · 0 de 6 |
| `negocio/` | Identidad (qué es, dónde está y qué ciudades o zonas cubre), historia, cómo gana dinero, qué lo hace distinto, lo que no es, la voz de la marca | secc. 1 y 2 · P19 P21 P22 P23 P24 P25 | 0 | vacía · 0 de 6 |
| `clientes/` | A quién le vende, perfiles y segmentos, cómo se anuncia y cómo le llegan, recorrido del cliente, preguntas y quejas de siempre, objeciones, posventa (o que no hay), una ficha por cliente que regresa | secc. 4, 9 y 10 · P06 P08 P28 P29 | 0 | vacía · 0 de 4 |
| `oferta/` | Productos, precios, promociones, cómo se cotiza, contratos | secc. 8 · P09 | 0 | vacía · 0 de 1 |
| `operacion/` | Procesos, reglas no escritas, plataformas y el mapa de accesos, proveedores, socios | secc. 6 · P02 P03 P04 P10 P11 P26 | 1 plantilla | vacía · 0 de 6 |
| `equipo/` | Quién hace qué, quién decide (también lo que decide el dueño), lo que solo sabe uno, lo repetitivo, los errores de siempre | secc. 5 · P01 P18 | 0 | vacía · 0 de 2 |
| `dinero/` | Lo que cuesta y lo que entra: márgenes, costos (renta, nómina), ventas promedio con su reparto, tasas como la de cierre, fugas, métricas | P05 P16 P17 | 0 | vacía · 0 de 3 |
| `rumbo/` | Problemas, prioridades, proyectos del negocio, patrones por día de la semana, mes o temporada (aunque traigan cifras), planes, potencial, oportunidades, mapa de decisiones | secc. 12 y 13 · P07 P12 P13 P14 P15 P27 P30 | 0 | vacía · 0 de 7 |
| `reglas-del-negocio.md` | Las reglas que se cumplen o no se cumplen: precio, entrega, pago, garantía, tono, cuándo llamar al dueño, lo que nunca se dice | secc. 15 (siete tipos de regla) | 1 plantilla | vacía · 0 de 7 |
| `../empleados/` | Los puestos artificiales | secc. 11 · P20 | los lleva `empleados/_indice.md`; lo que el dueño dice que podría hacer la IA (P20) va a su sección «Ideas de puestos» | — |

Las 30 P están repartidas una sola vez: 6 en `negocio/`, 4 en `clientes/`, 1 en `oferta/`, 6 en `operacion/`, 2 en `equipo/`, 3 en `dinero/`, 7 en `rumbo/` y 1 en `empleados/`. Qué es cada P y cómo se decide a cuál va un dato: `sistema/clasificacion.md`, con sus «destinos fijos».

## Cómo se cuenta

- **Notas:** los archivos `.md` de la carpeta, sin contar su `_indice.md`. Las plantillas que siguen sin dato se cuentan como «plantilla».
- **Qué se mide en cada carpeta:** sus P. En `dueno/`, que no tiene P, las seis partes de la sección 3 (3.1 quién es, 3.2 su día real, 3.3 lo que lo mueve, 3.4 cómo piensa y decide, 3.5 cómo opera, 3.6 cómo comunicarse con él). En `reglas-del-negocio.md`, sus siete tipos de regla.
- **Una P o parte cuenta como «con dato»** si una nota de la carpeta la nombra en su línea del `_indice.md` y tiene al menos un dato `[confirmado]`, `[de documento]` o `[de la web]`. Si solo tiene `[inferido]`, cuenta como «a medias». `pendiente` y `Sin dato:` no cuentan.
- **Qué tan llena:** «con dato» entre el total. `vacía` si es 0; `poca` si es menos de la mitad; `media` si es la mitad o más; `llena` si son todas. Se escribe así: `media · 3 de 6 (+1 a medias)`.
- **Cuándo se pone al día:** cada vez que una nota nace, cambia de P o pasa de inferida a confirmada, y siempre al cerrar el arranque y el repaso. Cambia también la fecha de «Actualizado».
