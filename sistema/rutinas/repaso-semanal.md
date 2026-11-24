# Rutina: repaso-semanal

Para qué sirve: quince minutos a la semana para que el cerebro no se llene de cosas viejas o dudosas, para llenar poco a poco lo que falta y para que el dueño aprenda a usar mejor la IA. El agente lo sugiere solo cuando pasaron más de siete días desde el último (AGENTS.md, punto 1), en una línea («Sugiero el repaso de la semana») y nunca en medio de otra rutina (una skill, un entregable, el arranque); el dueño también lo puede pedir. **Antes de ofrecerlo, compara fechas:** saca la fecha de hoy de la app o de la compu y ponla junto a `repaso_desde` de `sistema/estado.md`. Si hoy es anterior, no lo ofrezcas ni digas que «ya pasó una semana». Si `repaso_desde` está vacío, llénalo primero como dice su línea en el estado.

## Qué revisas, en este orden

1. **Lo que espera en `entrada/por-clasificar/`.** Vuelve a calificar cada dato con `sistema/clasificacion.md`, ahora con lo que el cerebro ya sabe. Si queda claro, guárdalo en su nota y bórralo de ahí. Si sigue dudoso, pregúntale al dueño en una línea con tu mejor apuesta como primera opción. Lo que no es del negocio se borra y queda en el registro.
2. **Hasta tres preguntas de lo que falta.** Mira en `conocimiento/_mapa.md` las P vacías o a medias y los `Sin dato:` que quedaron en las notas. Escoge las tres que más le servirían al negocio ahora y pregúntalas una por renglón y de un solo tema, siempre con «No sé» y «Luego», como en la fase `entrevista` de `sistema/rutinas/arranque.md`: lo que ya viste en un documento, un correo o una conversación, como confirmación que dice lo que viste («Vi en la lista que…, ¿sigue así?»), aunque sea algo que solo él sabe; lo que se cuenta con palabras y nada de lo leído responde (a quién le vende, qué lo distingue, cómo quiere que suene su marca), abierto y sin opciones. Lo que contesta lleva `[confirmado AAAA-MM-DD]`. No más de tres por semana. Antes de escogerlas, busca cada una en todas las notas de `conocimiento/`: si una nota ya trae la respuesta, no se pregunta. Lo que dejó en «Luego» sí se retoma aquí; lo que ya se le preguntó en esta charla y no contestó, no.
3. **Golpes repetidos.** En `sistema/golpes.md`, los que lleguen a tres veces: di cuál rutina falla y propón el cambio. Cambiar una rutina pide su «sí».
4. **Reglas que chocan.** En `conocimiento/dueno/como-hablarle.md`, `conocimiento/dueno/como-trabajar-con-el.md`, `conocimiento/reglas-del-negocio.md` y `skills/_aprendizajes.md`, busca reglas que se contradicen, que ya no aplican o que están en dos lugares. Una corrección al trabajo de una skill que quedó en las notas del dueño o en `sistema/golpes.md` se mueve a `skills/_aprendizajes.md`. Propón cómo dejarlas; borra solo con su «sí».
5. **Una idea nueva de cómo usar mejor la IA.** Una sola, hecha con lo que hizo esta semana y con su negocio (de tú: «Cada lunes me pides el corte de ventas: si me sueltas el Excel en la carpeta de entrada, te lo dejo listo antes de que preguntes»; de usted: «Cada lunes me pide el corte de ventas: si me deja el Excel en la carpeta de entrada, se lo dejo listo antes de que pregunte»). Que no repita una que ya le diste: revisa las líneas «Idea de la semana» de `sistema/bitacora.md` y apunta ahí la nueva.
6. **El DNA, si cambió algo de peso.** Mira en `conocimiento/dueno/correcciones.md` las líneas con «DNA: sí» más nuevas que el último DNA: si alguna no tiene su DNA nuevo, sácalo ahora. Si además se llenó algo de peso que no pasó por esa lista (una P que se llenó, una prioridad nueva), también vuelve a sacarlo con `sistema/rutinas/dna-del-negocio.md` y dile qué cambió.
7. **Cómo se repartieron las calificaciones.** Cuenta en `sistema/registro-del-barrido.md` los renglones de la semana por tramo, con los umbrales de `sistema/clasificacion.md`: cuántos entraron y cuántos no por afinidad con el negocio, cuántos se fueron directo a su P, cuántos a `por-clasificar` y cuántos se quedaron fuera. Apúntalo en una línea en `sistema/bitacora.md` («Calificaciones de la semana: …»). Al dueño díselo en una línea solo si algo se ve raro (por ejemplo, casi todo cae en `por-clasificar`).

Si hay ideas en `sistema/ideas-para-automatizar.md` en estado `idea` que ya se vieron tres veces, propón una, la que más tiempo ahorre, con `sistema/rutinas/proponer-automatizacion.md`, como «Sugiero dejar como rutina: …».

## Cómo se lo entregas

Primero lo que espera su decisión, como preguntas con opciones. Luego lo demás en una lista corta. Nada de reportes largos. Lo que propones hacer después (una rutina, un cambio) va como una sola sugerencia, al final: «Sugiero…» o «Puedo seguir con…», no como pregunta.

Antes de mandarlo, comprueba:

- [ ] ¿Todo va en el trato que el dueño usa? Revisaste cada verbo y cada pronombre contra el trato guardado (de usted, nada de «te», «tu», «me corregiste»; de tú, nada de «le», «su», «me corrigió»), también en las preguntas y en la sugerencia final.
- [ ] Si lo ofreciste tú, la fecha de hoy ya había llegado a `repaso_desde`.
- [ ] Ninguna línea dice que una sugerencia de rutina quedó sin respuesta o que no contestó; una idea que sigue en `idea` va, si acaso, como «Sugiero dejar como rutina: …».

## Al terminar

Guarda lo que corrigió o decidió con las reglas de siempre (AGENTS.md, puntos 3, 10 y 11). Pon al día `conocimiento/_mapa.md`. Escribe en `sistema/estado.md` `ultimo_repaso` con la fecha de hoy y `repaso_desde` con la de ocho días después, contada en un calendario, y apunta una línea en `sistema/bitacora.md`.

Si la app permite tareas programadas, el dueño puede pedir que el repaso le llegue solo cada semana. Programarlo pide su «sí» (AGENTS.md, punto 8); escribirlo aquí no lo programa.
