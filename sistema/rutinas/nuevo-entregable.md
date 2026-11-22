# Rutina: nuevo-entregable

Si el trabajo se va a repetir o es de un oficio (cotizar, cobrar, comprar, contratar, publicar), no es un entregable: usa crear-empleado.

Para qué sirve: que cada entregable (un reporte, una presentación, una página, una base de datos, un texto largo) quede en su carpeta, con lo necesario para que otra sesión u otro agente lo halle y sepa qué es sin preguntar.

## Pasos

0. **Entrega lo que pidió, como lo pidió.** Antes de armarlo, haz la lista de lo que pidió que llevara: cada parte, dato o sección que nombró (los precios, el horario, el mapa, las fotos), en esta charla o en la versión que ya aprobó. Esa lista va en el `leeme.md` («Lo que pidió que llevara») y **todo lo de esa lista va en la pieza**, con el mismo largo, las mismas partes, el mismo formato y el mismo tono. **Nunca quites algo que pidió**, aunque creas que no conviene: lo dejas y se lo propones en una línea en tu mensaje, con su porqué, como sugerencia y no como pregunta, en su trato (de tú: «Te sugiero quitar el teléfono de la página, porque…; si me dices que sí, lo quito»; de usted: «Le sugiero quitar el teléfono de la página, porque…; si me dice que sí, lo quito»). Se quita solo si dice que sí. Explicarlo en una nota del archivo no cuenta como proponérselo. Tampoco sumes partes por tu cuenta. Si te falta un dato para hacerlo como pidió, búscalo (paso 2) y, si no está, pregúntalo o márcalo `pendiente`; no lo cambies por otra cosa.
1. **La carpeta:** `trabajo/<AAAA-MM>-<tema>/`, con el año y el mes de hoy y un tema corto, en minúsculas, sin acentos, sin ñ y sin espacios (`trabajo/2026-11-pagina-de-sucursales/`). Si ya hay una carpeta de ese tema y ese mes, trabaja dentro de ella.
2. **Los datos:** saca lo que haga falta de `conocimiento/` y de `fuentes/`, empezando por `conocimiento/_mapa.md`. No inventes precios, cifras, nombres ni fechas: lo que falte va como `pendiente` en el entregable, o se pregunta si cambia el resultado. **Antes de decir que algo falta** (en el entregable, en «Lo que falta» o en una pregunta al dueño), búscalo en todo `conocimiento/` y en lo que leíste en esta sesión (documentos, correo, la web): un dato que ya leíste no falta, se usa con su marca. Si es un análisis (ventas, costos, clientes, un diagnóstico), cada frase que afirma algo lleva su número y de dónde sale, así: `(<número> · <nota o archivo>)`; si no hay número, la frase dice qué falta y quién lo tiene («falta el costo por pieza; lo tiene el proveedor»). Nada de «las ventas van bien» sin cifra. **Una cifra que salió de una suma nombra todo lo que incluye** («cobros de taller y de refacciones, de las dos sucursales»), nunca solo una de sus partes. Las fechas van como las dio el dueño, también en títulos y encabezados («marzo», no «marzo de 2027»; «el martes», no una fecha).
3. **Si es para publicar o para sus clientes** (una publicación, un folleto, una página, un mensaje):
   - lleva todos los precios y escalones que hay en `conocimiento/oferta/` para lo que anuncia (cada tamaño, paquete o nivel), no solo el primero;
   - usa la voz de la marca que vive en `conocimiento/negocio/`, no el trato que le das al dueño;
   - **no dice nada que no esté en `conocimiento/` o que no haya dicho el dueño**: ningún plazo, garantía, envío, descuento, horario, beneficio ni resultado de tu cosecha. Una regla del negocio se explica como la dice su nota, sin sumarle consecuencias: si la nota dice que pierde el precio especial, no escribas cuánto pagará de más;
   - **coteja cada dato con su fuente, palabra por palabra**, antes de entregarlo: abre la nota o el documento de donde salió y comprueba que dice eso mismo. No juntes dos datos en uno nuevo ni le sumes lugar, fecha o alcance que la fuente no trae: «abre en sábado» y «tiene técnico de guardia» no dan «técnico de guardia los sábados»;
   - antes de entregarlo, cruza cada dato (precio, horario, promoción, dirección, teléfono) con lo que el cerebro tiene, también lo marcado `[de la web: …]`. Si algo choca, como una promoción que su página da por suspendida o un precio distinto en dos notas, no lo des por vigente: díselo en la primera línea y apúntalo en «Lo que falta» del `leeme.md`.
4. **El archivo:** guárdalo en la carpeta con un nombre que diga qué es (`pagina-sucursales.html`, `corte-de-ventas.csv`). Si hace falta un programa que no está en la compu, pregunta antes de instalarlo y ofrece lo que se puede hacer sin instalar nada (AGENTS.md, punto 8). Si la app no puede hacerlo, dilo y entrega lo más cercano (AGENTS.md, punto 14); si son imágenes, como dice «Una pieza con imagen», abajo.
5. **El `leeme.md` de la carpeta**, corto:

```
# <Qué es, en una frase>

- Para quién: <el dueño, sus clientes, su equipo, un proveedor…>
- Lo que pidió que llevara: <cada cosa que nombró, o «nada en especial»>
- Versión: <1, 2…> · <AAAA-MM-DD> · <borrador / revisado por el dueño>
- De qué datos salió: <rutas de las notas de conocimiento/ y de fuentes/ que usó>
- Lo que falta: <lo pendiente, o «nada»>
- Archivos: <nombre de cada archivo y qué es>
```

6. **Su línea en `trabajo/_indice.md`**, la más nueva arriba: `- AAAA-MM-DD · <tema> · <qué es> · para <quién> · trabajo/<AAAA-MM>-<tema>/`.
7. **Antes de entregarlo, comprueba uno por uno** (AGENTS.md, punto 12):
   - [ ] El archivo abre, y el `leeme.md` y su línea del índice quedaron.
   - [ ] Cada cosa de «Lo que pidió que llevara» está en la pieza; no quitaste nada que pidió. Tiene el largo, las partes, el formato y el tono que pidió; lo que cambiarías o quitarías va propuesto en una línea en tu mensaje, no hecho ni escondido en una nota.
   - [ ] Nada de «Lo que falta» ni de tus preguntas está ya en `conocimiento/`, en lo que leíste en esta sesión o en lo que contestó en la charla: cotejaste cada renglón.
   - [ ] Cada línea de esta charla con «DNA: sí» en `conocimiento/dueno/correcciones.md` tiene ya su DNA nuevo, sacado en el mismo turno.
   - [ ] Las cifras salen de los datos crudos si los hay, y dicen de dónde salen; la que salió de una suma nombra todo lo que incluye. Si es un análisis, reléelo frase por frase: cada afirmación trae `(<número> · <de dónde>)` o dice qué falta y quién lo tiene.
   - [ ] Si este puesto o esta pieza tiene correcciones (las «Aprendizajes» de la ficha del empleado, o la versión que ya corrigió), lo abriste al lado y no repites ninguna.
   - [ ] Si va al público: todos los precios y escalones, la voz de la marca, y nada que no esté en `conocimiento/` o que no haya dicho el dueño, ni consecuencias de una regla que su nota no dice.
   - [ ] Si va al público: cotejaste cada dato con su fuente, palabra por palabra, y ninguno dice más que ella (ni lugar, ni fecha, ni alcance que la fuente no trae).
   - [ ] Si va al público: ninguna fecha, vigencia o promoción choca con lo guardado de la web. Busca en `conocimiento/` las notas `[de la web: …]` de lo que anuncias; si la web lo da por suspendido, vencido o cambiado, no va como vigente y se lo dices en la primera línea.
   - [ ] Lo escribiste con las herramientas de escribir y editar de la app, y abriste el archivo antes de decir que quedó.
   - [ ] Tu mensaje no ofrece con pregunta: lo que sigue va como una sola sugerencia, al final («Sugiero…», «Puedo seguir con…»).
   - [ ] ¿Todo va en el trato que el dueño usa? Revisaste cada verbo y cada pronombre de tu mensaje contra el trato guardado (de usted, nada de «te», «tu», «pediste»; de tú, nada de «le», «su», «pidió»). Ninguna frase copiada de esta rutina quedó en el otro trato, y no trae palabras de máquina («comando», «terminal», «parámetro», el nombre del programa si él no lo usa).
   - [ ] Cada cosa que dice de una persona o cada cuenta (cuántos clientes, cuántos pedidos) la cotejaste con su fuente: quién escribe a quién, y si cada caso contado cumple de verdad lo que dices.
   Dile al dueño dónde quedó en una línea, con su «Guardé», y apunta una línea en `sistema/bitacora.md`.

## Una pieza con imagen

Si la app no genera imágenes, dilo en la primera línea y entrega las dos cosas:

- **la maqueta**: el texto ya puesto sobre sus fotos reales de `fuentes/` (un `.html` sirve), con sus colores y su logo si los hay;
- **las instrucciones para pegar** en una herramienta de imágenes, en un `instrucciones-imagen.md` de la misma carpeta, una por pieza: qué foto usar (su ruta en `fuentes/`, o «sin foto»), qué escena se ve, el tamaño y la forma (por ejemplo, 1080 × 1080 para una publicación cuadrada, 1080 × 1920 para una historia), el texto que va encima, letra por letra, y los colores. Que se pueda copiar tal cual, sin explicar nada más.

Si la app sí genera imágenes, la imagen va en la carpeta y las instrucciones también, para repetirla.

## Una base de datos

En esta compu, una «base de datos» sin instalar nada es una carpeta de `.csv` (sacados de un `.xlsx` con `-Csv` directo a la carpeta del entregable, como dice `sistema/herramientas/_leeme.md`) más un `consultas.ps1` o una nota con las consultas en PowerShell (`Import-Csv | Where-Object | Group-Object | Measure-Object`), que solo leen y muestran, y su resultado en `.csv` y en una nota, escritos con la herramienta de escribir de la app. El `.xlsx` solo si Excel está instalado. Si el dueño quiere algo más (SQLite, Access, Google Sheets), se le explica y se pide su «sí» antes de instalar.

## Versiones

Si el dueño pide cambios o corrige algo de una pieza ya entregada, abre en ese mismo turno `sistema/rutinas/corregir-chamba.md` y síguela: primero escribe la corrección donde vive, con el alcance que dijo; luego rehaz la pieza como otro archivo (`…-v2`) y enséñala completa. La próxima pieza del mismo tipo se hace con la última versión corregida abierta al lado.

## Lo que no lleva

Sin acuerdos, fechas de entrega ni estados de proyecto: la carpeta guarda el entregable y lo que hace falta para entenderlo, nada más. Un borrador no es un envío: mandarlo o publicarlo pide su «sí» (AGENTS.md, punto 8), y lo que dice un borrador no se vuelve dato del negocio (AGENTS.md, punto 7).
