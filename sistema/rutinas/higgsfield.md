# Rutina: higgsfield

Para qué sirve: hacer con IA anuncios, videos, fotos de producto, kits de marca, miniaturas y una cara de marca fija, usando los datos del negocio guardados en `conocimiento/`, y pidiendo el «sí» del dueño antes de gastar créditos. `sin probar`

## Cuándo se usa

El dueño pide un anuncio, un video de su producto, fotos de producto, un kit de marca, una miniatura para sus videos o una cara de marca que se repita en sus anuncios. También cuando el agente la sugiere (ver `skills/_recomendadas.md`) y él dice que sí.

## Antes de nada: qué hay en esta sesión

Comprueba qué tienes (AGENTS.md, punto 14); no supongas.

- **Conector oficial de Higgsfield:** `https://mcp.higgsfield.ai/mcp`. Se agrega en la app como conector personalizado y se autoriza con la cuenta de Higgsfield del dueño.
- **Habilidades oficiales o programa `higgsfield`:** `/plugin marketplace add higgsfield-ai/skills` y `/plugin install higgsfield@higgsfield`, o `npx skills add higgsfield-ai/skills`; luego `higgsfield auth login`. Fuente: https://github.com/higgsfield-ai/skills
- **Si no hay ninguno:** dile al dueño en dos líneas cómo conectarlo (el conector de arriba, o instalar las habilidades) y para. Conectar o instalar pide su «sí» (AGENTS.md, punto 8).
- **Cuesta dinero:** Higgsfield pide suscripción de pago. La cuenta gratis deja marca de agua y no permite uso comercial: avísale antes de que genere algo para vender.

## Qué datos usa

Toma de `conocimiento/` lo que ya está guardado: marca, productos, precios, promesas, pruebas y público. **Nunca pongas en el encargo una afirmación que no esté ahí** (un precio, una garantía, un «el mejor»). Si falta un dato que el anuncio necesita, anótalo como pendiente y pregúntaselo, o déjalo fuera.

## Pasos

1. **Elige el modo** según lo que pidió:
   - Anuncio en video (Marketing Studio): `ugc` (alguien que habla del producto), `ugc_how_to` (cómo se usa), `ugc_unboxing` (lo abre), `product_showcase` (lo muestra), `product_review` (lo reseña), `tv_spot` (estilo comercial) y `virtual_try_on` (probárselo puesto).
   - Fotos de producto: `product_shot`, `lifestyle_scene`, `hero_banner`, `social_carousel`, `ad_creative_pack` y `restyle`.
   - Misma cara en todo (Soul ID): se entrena con 5 a 20 fotos de la persona; pide permiso a quien salga en las fotos.
   - Kit de marca (brandkit), miniaturas para videos y video sin cara.
2. **Arma el encargo:** de dónde sale (la URL del producto o sus fotos), formato y medida (9:16, 1:1 o 16:9), duración, lo que no debe cambiar («el producto idéntico a mis fotos») y el tono de la marca según `conocimiento/negocio/`.
3. **Dile al dueño qué va a generar**, con qué modelo y cuántos créditos aproximados, y espera su «sí». Cuesta dinero: sin «sí», no se genera. Modelos que nombra Higgsfield (pueden cambiar): imagen Nano Banana 2 y Pro, Soul V2, Flux 2, GPT Image, Seedream y Recraft (SVG); video Veo 3.1, Kling 3.0 y Seedance; audio Seed Audio. Consumos de referencia, sin verificar oficialmente: Kling 3.0 cerca de 7 créditos por 5 segundos a 720p; Veo 3.1 Fast cerca de 16 por 4 segundos. Di siempre que son aproximados y que la cuenta del dueño muestra el cobro real.
4. **Primero una toma corta de prueba**, y la enseñas. Solo con su visto bueno, la versión final.
5. **Guarda lo generado** en `trabajo/<AAAA-MM>-<tema>/` con una nota corta de qué se pidió (modo, fuente, medida, modelo) y qué salió. Si el dueño corrige algo, la corrección va a esta rutina o a la nota de marca, no solo al archivo.

## Límites que hay que decirle

- Salen clips sueltos, sin música ni edición: para juntarlos hace falta un editor.
- Los créditos de la suscripción caducan al fin del ciclo.
- Lo generado puede cambiar un detalle del producto: compara con sus fotos antes de publicar.
- Nada se publica ni se manda a un cliente sin que el dueño lo vea (AGENTS.md, punto 8).

## Cinco ideas que sorprenden

Sugiere una a la vez, la que encaje con lo que sabes de su negocio.

1. Un anuncio con voz de cliente (UGC) de su producto estrella, sacado solo de la URL de su tienda.
2. Una sesión de fotos de producto sin fotógrafo: el producto en una mesa de cocina, en la calle, en un banner.
3. Un kit de marca completo: colores, letras y ejemplos de uso, a partir de lo que ya tiene.
4. La misma cara de marca en todos sus anuncios, entrenada con unas cuantas fotos.
5. Miniaturas para sus videos de YouTube, todas con el mismo estilo.

## Cómo se ve un buen resultado

El producto se reconoce igual que en sus fotos, no dice nada que `conocimiento/` no respalde, tiene la medida que pidió y el dueño dijo «sí» antes del gasto. Cuando haya uno aprobado, enlázalo aquí.
