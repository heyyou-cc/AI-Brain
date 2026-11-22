# Rutina: corregir-chamba

Para qué sirve: que cada corrección del dueño a algo ya entregado quede escrita donde se lee la próxima vez que se hace ese trabajo, antes de rehacerlo, y que la versión nueva le llegue completa en el mismo mensaje.

## Cuándo corre

En cuanto el dueño corrige o pide cambiar algo que ya le entregaste: la pieza de un empleado (un borrador, una cotización, una publicación, un reporte, una página), un entregable de `trabajo/` o un texto que le diste en la charla. Vale aunque sea de forma («así no», «quítale el saludo», «mejor en lista», «menos formal», «sin tantas cifras») y aunque lo diga de pasada al pedir otra cosa. Corre en ese mismo turno, aunque la rutina que hizo la pieza (`crear-empleado`, `nuevo-entregable`) la hayas leído al principio de la charla: la que se abre al corregir es esta.

Si además corrige un dato o una regla del negocio, ese dato va también a su nota (AGENTS.md, puntos 3 y 10). Si además es un error tuyo (inventaste, no guardaste, rompiste una regla escrita), va también a `sistema/golpes.md`, en ese turno.

## Pasos, en este orden y en la misma respuesta

1. **Primero la ficha, antes de rehacer nada.** Busca qué empleado hizo la pieza: su línea en `trabajo/_indice.md`, el `leeme.md` de su carpeta o la charla. Abre su ficha en `empleados/` y escribe la corrección en «Aprendizajes», la más nueva arriba, con la forma que trae la ficha: `- AAAA-MM-DD · <lo que corrigió, con sus palabras> · desde hoy: <qué se hace distinto> · versión corregida: trabajo/<carpeta>/<archivo>`. Si ahí decía «Ninguno todavía», quítalo. Luego lee la ficha entera, de arriba abajo, y cambia todo lo que choque con la corrección: «Qué decide solo» (también la regla de cálculo, si la corrección cambia qué se suma o qué se resta), «Qué siempre le pregunta al dueño», «Qué entrega», «Cuándo trabaja» y las frases de «Cómo pedirle trabajo». Ninguna parte puede seguir diciendo lo de antes.
   - **En ese mismo turno**, sigue los pasos de `conocimiento/dueno/correcciones.md`: busca la palabra vieja (el valor o el nombre de antes) en todo `conocimiento/`, en las fichas de `empleados/` y en el DNA vigente y cámbiala donde aparezca; escribe su línea con «DNA: sí» o «DNA: no»; y, si es sí, saca el DNA nuevo. Si pidió «de usted» con sus clientes, ninguna nota puede seguir diciendo «de tú».
   - Si ningún empleado hizo la pieza, la corrección va a `conocimiento/dueno/como-trabajar-con-el.md`, con «aplica a: <ese tipo de trabajo>».
   - Si la pieza salió de una rutina que el dueño aceptó (las de «Rutinas del dueño» en `sistema/version.md`), la corrección va a esa rutina (`sistema/rutinas/proponer-automatizacion.md`, «Si acepta una rutina»).
2. **Con el alcance que dijo, ni más ni menos.** Apunta lo que dijo, no lo que tú deduces de ello. Si limitó la corrección a un cliente, un producto, un lugar o una vez, se apunta así, con ese límite; no la vuelvas regla para todos ni le sumes casos que no nombró. Si dijo que algo solo aplica en un lugar, no agregues qué pasa en los demás ni a dónde se manda a la gente. Si dijo «siempre», «nunca» o «de ahora en adelante», vale para todo ese trabajo. Lo de un solo cliente va también a su ficha de `conocimiento/clientes/`. Lo de «solo esta vez» no se apunta: se rehace y ya.
3. **Rehazla ahora y enséñala completa.** Guarda la versión nueva como otro archivo en la misma carpeta (`…-v2`), sin pisar la que él ya vio o editó; sube la versión en su `leeme.md`, cambia su línea en `trabajo/_indice.md` y pon su ruta en la línea del paso 1. Tu mensaje trae una línea con qué cambió y luego la pieza entera, no un resumen ni solo la parte que cambió; si son dos o más borradores, van todos, completos. Si era un texto de la charla sin archivo, va entero en el mensaje. No la prometas para después.
4. **Cómo le hablas a él es otra cosa.** A `conocimiento/dueno/como-hablarle.md` va solo lo que corrige de cómo le escribes a él en la charla (tus respuestas, tus avisos), nunca lo que corrige de la pieza, aunque suene a gusto suyo. Si una misma frase toca las dos cosas, cada parte va a su lugar.
5. **Antes de la siguiente entrega de ese trabajo**, hoy o cualquier otro día, relee «Aprendizajes» de la ficha (o la regla de cómo trabajar con él), abre la última versión corregida y compara la nueva contra cada renglón; si repite algo ya corregido, arréglalo antes de enseñarla. **Una corrección de forma se cumple en la siguiente pieza:** si pidió «una o dos frases», cuenta las frases de la nueva; si pidió «sin emojis» o «en lista», búscalos; no la enseñes hasta que cuadre. Si se te escapa, además es un golpe tuyo: va a `sistema/golpes.md` (si ya está, súmale una vez).

Lo de un empleado se guarda sin preguntar: no preguntes si vale para siempre, en su ficha vale para ese puesto. Repite hasta que diga que está bien, tres intentos como mucho; si no llega, deja en la ficha lo que falta. No le cuentes cómo guardaste nada: la única excepción es la línea de «Guardé».

## Antes de mandar la versión nueva, comprueba uno por uno

Abre la ficha y la carpeta de la pieza; no lo contestes de memoria.

- [ ] La corrección está en «Aprendizajes» de la ficha del empleado que hizo la pieza (o en cómo trabajar con él, con su «aplica a»), con su fecha, sus palabras y la ruta de la versión nueva, y la escribiste antes de rehacer. «Aprendizajes» ya no dice «Ninguno todavía».
- [ ] Ninguna parte de la ficha sigue diciendo lo de antes, ni ninguna otra nota: buscaste en todas lo que contradice la corrección y lo cambiaste en este turno.
- [ ] La corrección tiene su línea en `conocimiento/dueno/correcciones.md`, con su fecha, dónde quedó y «DNA: sí» o «no», y la palabra vieja ya no aparece fuera de «Historia».
- [ ] La versión nueva cumple cada corrección de forma, contada (frases, renglones, emojis).
- [ ] Si su línea dice «DNA: sí», el DNA nuevo ya salió en este turno.
- [ ] Quedó con el alcance que dijo: ni regla para todos de algo que dijo para un caso, ni casos o lugares que no nombró.
- [ ] A cómo hablarle no fue nada de la pieza; solo, si la hubo, una corrección de cómo le escribes a él.
- [ ] La versión nueva es otro archivo, su `leeme.md` y su línea del índice la nombran, y tu mensaje la trae completa (todos los borradores, si son varios).
- [ ] ¿Todo va en el trato que el dueño usa? Revisaste cada verbo y cada pronombre contra el trato guardado (de usted, nada de «te», «tu», «me corregiste»; de tú, nada de «le», «su», «me corrigió»). Sin rutas ni palabras de taller fuera del «Guardé», y el mensaje cierra con su «Guardé».
