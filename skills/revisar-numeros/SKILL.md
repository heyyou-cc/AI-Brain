---
name: revisar-numeros
description: Revisa ventas, márgenes, gastos o flujo desde un Excel, un CSV o lo que el dueño pegue, y dice qué ve y qué conviene decidir. Úsala cuando el dueño diga «revisa mis ventas», «cómo voy este mes», «dónde se me va el dinero», «saca el margen de…», «hazme un reporte de…» o «qué dicen estos números».
---

# Revisar números

Para qué sirve: leer las cifras del negocio completas, sacar lo que importa y decir de dónde sale cada número.

## Antes de empezar

Lee la sección de esta skill en `skills/_aprendizajes.md` y las notas que toca:

- `conocimiento/dinero/` (P05 presupuestos, P16 performance, P17 pérdidas): lo que ya se sabe de costos, métricas y fugas.
- `conocimiento/oferta/` (P09): costos y precios por producto.
- `conocimiento/reglas-del-negocio.md`: márgenes mínimos y reglas de cobro.
- `conocimiento/rumbo/patrones.md` (P14): lo que se repite por día, mes o temporada.

## Pasos

1. Lee el archivo completo con `sistema/herramientas/leer-documento.ps1` o `.sh`, como dice `sistema/herramientas/_leeme.md`. Si avisa que cortó, lee el resto antes de concluir nada.
2. Di qué incluye cada cifra y de qué fechas es. Si los datos están incompletos, dilo y pregunta.
3. Calcula lo que pidió, y si no pidió algo en concreto: ventas totales y por producto, canal o periodo; margen por producto; flujo con lo que hay; gastos que crecieron sin motivo; días o meses que se repiten.
4. Cada frase lleva su número y de dónde salió (archivo y columna), o dice qué falta y quién lo tiene.
5. Cierra con tres cosas que mirar o decidir.
6. Lo que dura va a `conocimiento/dinero/` con su marca. El reporte va a `trabajo/`.

## Qué entrega

Un reporte corto, con la cuenta a la vista, en `trabajo/`.

## Qué NO hace sin permiso

- Mover, pagar o cobrar dinero.
- Recomendar despidos, recortes o deudas.
- Concluir con un archivo leído a medias, ni mezclar las finanzas personales del dueño con las del negocio.
