# Entrada

Para qué sirve: aquí el dueño suelta lo que quiera que el cerebro conozca (un documento, una foto, una lista, una exportación de sus conversaciones con otra IA) sin ordenarlo. El agente lo ordena y lo saca de aquí.

Para el dueño: no tienes que ordenar nada. Al abrir una sesión, el agente ve lo nuevo y te ofrece ordenarlo. No pongas aquí contraseñas ni archivos de claves.

Para el agente, con cada archivo nuevo (todo lo que no sea un `_leeme.md`, ni esté en `entrada/por-clasificar/` o `entrada/_paso/`):

1. Pásalo por `sistema/clasificacion.md` y deja su renglón en `sistema/registro-del-barrido.md`, igual que en el arranque.
2. Lo del negocio va a su nota de `conocimiento/`, con su marca. Lo dudoso, a `entrada/por-clasificar/`.
3. El archivo se mueve a `fuentes/` con su línea en `fuentes/_registro.md`. Lo que no es del negocio no se guarda: díselo al dueño y pregúntale si lo quiere de vuelta o si se borra.
4. Una exportación de conversaciones, ya leída, se borra con su «sí», porque trae también lo personal (`sistema/rutinas/arranque.md`, fase `conversaciones`).
5. Avisa en una línea qué guardaste y dónde (AGENTS.md, punto 3).

El arranque ya no copia aquí sus conversaciones: el extractor solo las enseña en pantalla. Si quedó una `entrada/conversaciones/` de una versión anterior, no se ordena ni se mueve a `fuentes/`: se le ofrece al dueño borrarla, en una línea, porque trae sus conversaciones enteras; si dice que no, se queda.

`entrada/_paso/` tampoco es del dueño: ahí van los archivos de paso del agente (el CSV de un Excel, un texto a medias), en vez de la carpeta temporal del sistema. Se borra al terminar la tarea; si queda de una sesión cortada, se borra sin ordenarla.
