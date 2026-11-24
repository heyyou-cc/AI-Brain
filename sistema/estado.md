# Estado del cerebro

Para qué sirve: dice en qué va el cerebro para que cualquier sesión siga donde quedó la anterior. El agente lo lee al primer mensaje de cada sesión (AGENTS.md, punto 1) y lo escribe después de cada paso del arranque. La sesión siguiente lo toma como cierto: en cuanto algo cambia (el dueño contesta una duda, una fuente se revisa, un pendiente se resuelve), corrige esa línea en ese momento, no al final. No lo borres.

- version: 1.10
- carpeta_personal:
- ultima_sesion:
- fase_arranque: sin-empezar
- permiso: directo
- carpetas_aprobadas:
- barrido_inventario:
- barrido_leidos:
- barrido_tandas: 0
- conversaciones: sin-revisar
- conectores: sin-revisar
- web: sin-revisar
- enriquecer:
- vuelta_extra: 0
- pistas:
- tablero:
- preguntas_hechas: 0
- entrevista_sin_dato:
- arranque_cerrado:
- ultimo_repaso:
- repaso_desde:
- estilo_aprende_hasta:

## Pendientes

- Nada.

## Qué significa cada campo

- `fase_arranque`, por vueltas (`sistema/rutinas/arranque.md`, «Fases»): vuelta 1: sin-empezar → aviso → inventario → dudosos → lectura → conversaciones → tablero-1; vuelta 2: conectores → tablero-2; vuelta 3: web → enriquecer → tablero-3; luego, si salen pistas nuevas, `pistas` (con `vuelta_extra`); cierre: entrevista → cierre → listo.
- `permiso`: `directo` (el arranque no pide permiso; es el valor de fábrica). Los valores de versiones anteriores siguen valiendo si ya están escritos: `adelante` (igual que `directo`), `solo-algunas` (solo `carpetas_aprobadas`) y `no-revisar` (salta carpetas y conversaciones).
- `enriquecer`: qué pistas buscó la fase `enriquecer`, qué halló y cuáles no, o `no revisada · por qué: …`.
- `vuelta_extra`: cuántas vueltas extra por pistas nuevas lleva el arranque (0 al empezar; el tope es tres).
- `tablero`: cuándo se le enseñó el tablero de las 30 P al cerrar cada vuelta, como `vuelta 1: AAAA-MM-DD · vuelta 2: AAAA-MM-DD · vuelta 3: AAAA-MM-DD · extra N: AAAA-MM-DD` (un `extra N` por cada vuelta extra); vacío si aún no se enseñó ninguno.
- `pistas`: la lista de pistas de la vuelta extra en curso, con las ya buscadas tachadas; vacío si no hay vuelta extra.
- `carpeta_personal`: la carpeta de usuario del dueño en esta compu. De aquí salen todas las rutas fuera del cerebro: con ella escrita no se leen variables del sistema ni se sube de carpeta (AGENTS.md, punto 5). Si está vacía, el arranque la llena una vez, en este campo de arriba y nunca como renglón suelto al final; se cambia a mano solo si el negocio vive en otra carpeta.
- Al cerrar el arranque y al cerrar cada sesión, el agente relee este archivo renglón por renglón contra lo que el dueño contestó y corrige cada «sin dato», «pendiente» o «sin revisar» que ya tiene respuesta.
- `pendientes` (abajo): solo lo que de verdad espera. Lo que ya se hizo se quita; al cerrar el arranque esta lista se reescribe entera.
- `barrido_inventario`: total, y cuántos del negocio, personales, de claves y dudosos. `barrido_leidos`: leídos de los que había por leer, como «20 de 45».
- `conversaciones`: sin-revisar · página N de M (en qué página del extractor va) · `hechas, M páginas · <N> correcciones y <N> pedidos repetidos` · `sin conversaciones` (solo si el extractor corrió y lo dijo) · `no revisadas · por qué: <lo que pasó al intentarlo>`.
- `conectores`: un renglón por conector. `<conector> · revisado AAAA-MM-DD · carpetas del negocio: <cuáles> · mixtas: <cuáles, y de cada una cuántos recorrí, cuántos del negocio abrí y cuántos personales conté sin abrir> · del AAAA-MM-DD al AAAA-MM-DD · <N> del negocio, abrí <N> · leí, por ejemplo: «<un asunto>»`, o `<conector> · no revisado · por qué: <lo que pasó al intentarlo>`. Sin algo leído que citar no hay «revisado».
- `web`: `busqué: «<nombre>», «<nombre> <ciudad>» y cada forma más que probaste · abrí: <páginas> · hallé: <qué>`, o `nada suyo en internet · busqué: …`, o `no revisada · por qué: <lo que pasó al intentarlo>`. Si el dueño dice que tiene o que no tiene página, se corrige aquí en ese momento.
- En ningún campo se escribe una causa que no se comprobó: si no se miró, dice «no revisado» y el porqué real.
- `preguntas_hechas`: las preguntas que de verdad se le hicieron en la entrevista, contadas una por una en la charla (el tope es diez; el número no es el tope). `entrevista_sin_dato`: las partes del 20 % que siguen vacías, por nombre, o «nada».
- `arranque_cerrado` y `ultimo_repaso`: fechas AAAA-MM-DD.
- `estilo_aprende_hasta`: hasta qué día el agente apunta solo, en cada mensaje, cómo escribe el dueño (AGENTS.md, punto 2). Lo llena la primera sesión con su fecha más 30 días, contados en calendario; después de esa fecha solo se cambia la nota cuando él corrige.
- `repaso_desde`: el primer día en que se puede ofrecer el repaso, ocho días después del último repaso o, si no hay, del cierre del arranque (cierre el día 3 → `repaso_desde` el día 11). Se escribe una vez, al cerrar el arranque o el repaso, contando los días en un calendario, no a ojo. Para ofrecer el repaso (AGENTS.md, punto 1) solo se compara: si la fecha de hoy es anterior, no se ofrece. Si está vacío, llénalo primero con esa cuenta, desde `ultimo_repaso` o, si no hay, desde `arranque_cerrado`.
