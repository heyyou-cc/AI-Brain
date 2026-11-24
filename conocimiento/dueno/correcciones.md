# Correcciones del dueño

Para qué sirve: junta en un solo lugar lo que el dueño le ha corregido al cerebro, lo que cambió en el negocio y lo que pide de forma fija, una línea por cosa, para contarlas y nombrarlas sin buscar en otras notas. De aquí salen, copiadas, las del saludo de sesión nueva y las de «qué sabes de mí» (AGENTS.md, punto 1), y de aquí sale cuándo se rehace el DNA. No reemplaza a la nota donde vive cada cosa: la regla o el dato siguen en su sitio (punto 10) y esta lista solo dice qué fue y dónde quedó.

**Qué entra, en tres tipos:**

- `corrección`: lo que te corrige a ti o a lo que hiciste, o un dato que tenías mal. También las que salen de sus conversaciones con la IA en el arranque.
- `cambio`: lo que cambia en la charla aunque nadie corrija nada: algo que se firmó, una sucursal que abrió, un servicio que se suspendió, un precio nuevo.
- `costumbre`: lo que pide de forma fija («cada lunes, las ventas de la semana por sucursal», «los reportes, siempre en una hoja»). Una costumbre se aplica sin preguntarla.

Forma, la más nueva arriba: `- AAAA-MM-DD · <corrección, cambio o costumbre> · <qué, en pocas palabras y con las suyas> · quedó en: <ruta de la nota> · DNA: <sí o no>`

«DNA: sí» si el dato aparece en el DNA vigente (la última versión en `trabajo/`); «no» si no aparece o si todavía no hay DNA.

**Pasos, en el mismo turno en que guardas la corrección, el cambio o la costumbre en su nota:**

1. **Busca la palabra vieja.** Si reemplaza algo (una cifra anterior, la persona que antes decidía, un nombre de servicio), busca ese valor viejo, tal como estaba escrito, en todo `conocimiento/`, en las fichas de `empleados/` y en el DNA vigente, y cambia cada aparición en este turno. Lo que deba quedarse como historia va a la «Historia» de su nota, marcado como historia, no suelto en el texto.
2. **Si fue un error tuyo** (inventaste, no guardaste, te saltaste una regla escrita, no un dato del negocio), escríbelo también en `sistema/golpes.md` en este turno, y «quedó en» nombra las dos rutas.
3. **Escribe la línea aquí**, con su «DNA: sí» o «DNA: no». Si la cosa cambia de sitio o la reemplaza otra, cambia su línea; no la dupliques.
4. **Si es «DNA: sí», saca en este mismo turno la versión nueva del DNA** con `sistema/rutinas/dna-del-negocio.md`, aunque sea una sola línea. No se deja para el cierre ni para el repaso.

Ejemplos de forma, no reales:

- `- 2026-11-17 · corrección · a las clientas se les habla de usted · quedó en: conocimiento/negocio/voz-de-la-marca.md · DNA: sí`
- `- 2026-11-17 · cambio · el taller del norte cierra los domingos desde este mes · quedó en: conocimiento/operacion/sucursales.md · DNA: sí`
- `- 2026-11-17 · costumbre · cada viernes, los pedidos por surtir de la semana siguiente · quedó en: conocimiento/dueno/como-trabajar-con-el.md · DNA: no`

## Correcciones

Ninguna todavía.
