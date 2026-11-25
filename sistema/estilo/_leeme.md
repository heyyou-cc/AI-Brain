# La voz que se aprende sola

Para qué sirve: hace que el asistente le hable al dueño como el dueño habla y piensa, y que esa forma se afine sola mientras más platican, sin que nadie se acuerde de apuntarla. Corre en Claude Code, Codex y Copilot (si Codex no confía en la carpeta o no se aprobaron sus alarmas con `/hooks`, vale la regla escrita de AGENTS.md, punto 2; en Copilot la voz llega en el siguiente `sessionStart` o `postToolUse`, porque Copilot descarta lo que imprime al recibir el mensaje).

## Cómo funciona

1. **Escucha.** Con cada mensaje del dueño, la alarma `sistema/alarmas/al-recibir.sh` guarda el texto tal cual en `muestras.jsonl` (tapa números largos y llaves antes de guardar). Los comandos con diagonal, como `/arranque`, no cuentan.
2. **Afina.** Cuando junta 6 mensajes nuevos (25 después de `estilo_aprende_hasta`, en `sistema/estado.md`), lanza en segundo plano `sistema/alarmas/destilar-voz.sh`. Ese ayudante le pasa a Claude la nota de hoy, los mensajes nuevos y los últimos ya vistos, con las reglas de `instrucciones-destilar.md`, y recibe la nota afinada. La plática no se detiene: el ayudante tarda unos segundos y trabaja aparte.
3. **Revisa antes de guardar.** La nota nueva entra solo si trae todas sus partes y conserva, letra por letra, cada línea `[confirmado ...]` (lo que el dueño pidió con palabras). Si no, la nota queda como estaba, los mensajes regresan a la fila y el motivo queda en `destilado.log`.
4. **Habla.** Al primer mensaje de cada sesión, y cada vez que la nota cambió, la alarma le pasa al asistente la voz vigente. Así una sesión abierta cambia de tono a media plática, sin reiniciar. En los demás mensajes le recuerda solo el trato y la regla de largo, que es lo primero que se le olvida.

## Qué aprende

- Cómo escribe: trato, muletillas, largo, cómo une las ideas, cómo pide y cómo cierra.
- Cómo piensa y explica: si usa comparaciones o ejemplos y de qué mundo, si va de lo concreto a lo general, qué quiere primero en una respuesta.
- Cada rasgo lleva cuántas veces se vio y cuándo. Lo visto una vez entra con cuidado; lo que deja de verse se corrige.
- Copia su forma, nunca sus faltas de ortografía. No aplica a código, a notas ni a mensajes para sus clientes (esa es la voz de su marca, en `conocimiento/negocio/`).

## Archivos

- `instrucciones-destilar.md`: las reglas del ayudante. Se pueden ajustar.
- `muestras.jsonl`: mensajes en fila para la siguiente afinada.
- `vistas.jsonl`: los últimos 60 ya estudiados, para ver qué se repite.
- `historial/`: las últimas 10 versiones de la nota antes de cada afinada. Para volver atrás, copia una sobre `conocimiento/dueno/como-hablarle.md`.
- `destilado.log`: una línea por afinada, buena o mala.

Lo que el dueño escribe se queda en esta compu, dentro de esta carpeta. Para afinar, el ayudante usa la misma cuenta de Claude del dueño, con un modelo mediano (`ESTILO_MODELO`, por omisión `sonnet`); cada afinada cuesta lo de un mensaje corto.

## Probar

- Sin gastar: `sh sistema/alarmas/probar.sh` revisa que guarde, tape números y pase la voz.
- De verdad: `sh sistema/alarmas/destilar-voz.sh` afina en ese momento con lo que haya en la fila.
