Para qué sirve: lista de habilidades (skills) que el agente le puede sugerir al dueño según lo que sabe de su negocio, con qué hace cada una, cómo se instala, si cuesta y de dónde sale. Revisado por investigación el 2026-11-23; lo que no se pudo abrir va marcado «sin verificar».

## Cómo usa esto el agente

- Sugiere de una a tres que encajen con lo que vio del negocio en `conocimiento/` (qué vende, a quién, qué hace cada semana). No lee la lista entera en voz alta.
- Por cada una dice en una línea qué ganaría el dueño, en cosas de su negocio, sin nombres técnicos. Si cuesta dinero, lo dice antes de ofrecerla.
- Instala solo con el «sí» del dueño (AGENTS.md, punto 8). Antes de instalar, comprueba qué hay ya en la sesión (punto 14): si la habilidad o el conector ya están, no se instala otra vez. También antes de instalar, lee el `SKILL.md` y los scripts que trae; si piden internet, claves, mandar algo o gastar, díselo al dueño en una línea antes de su «sí».
- Si el dueño dice que no, queda anotado en una línea en la sección «No las quiere», al final de este catálogo, y no se vuelve a sugerir.
- **Las de documentos de Anthropic (docx, pptx, xlsx, pdf) no se copian dentro del cerebro:** se instalan desde su origen, para que se actualicen solas y no queden versiones viejas aquí.
- Cuando no hay comando abajo, el paso es «instalar desde la carpeta del repo»: bajar la carpeta de la habilidad desde la URL y ponerla en las habilidades de la app, con el «sí» del dueño.
- Lo que sale de una habilidad sigue las reglas del cerebro: lo generado se guarda en `trabajo/` y nada se manda a un cliente sin que el dueño lo vea.

## Contenido e imagen

### Higgsfield (anuncios, fotos de producto, video, kit de marca)
- **Qué hace:** genera anuncios en video, fotos de producto, miniaturas, la misma cara de marca en todo y un kit de marca, con IA de imagen y video.
- **Sorprende a:** tiendas con producto físico, restaurantes, marcas personales, quien vende por redes y nunca tuvo fotógrafo ni editor.
- **Instalación:** `/plugin marketplace add higgsfield-ai/skills` y luego `/plugin install higgsfield@higgsfield`; o `npx skills add higgsfield-ai/skills`. Piden el programa `higgsfield` y entrar con `higgsfield auth login`.
- **Cuesta:** sí, créditos de pago de Higgsfield. Pedir el «sí» del dueño antes de cada generación.
- **Fuente:** https://github.com/higgsfield-ai/skills (MIT, v0.14.0, 9 habilidades: higgsfield-generate, higgsfield-soul-id, higgsfield-product-photoshoot, higgsfield-brandkit, higgsfield-marketplace-cards, higgsfield-websites, higgsfield-faceless-video, higgsfield-video-explainer, higgsfield-youtube-thumbnail).
- **Nota:** el cerebro ya trae su propia rutina para esto, `sistema/rutinas/higgsfield.md`; si el dueño lo pide, se sigue esa.

### canvas-design (Anthropic)
- **Qué hace:** hace piezas gráficas (carteles, imágenes de diseño) a partir de una idea.
- **Sorprende a:** quien necesita cartelitos, promos o imágenes sueltas sin diseñador.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### theme-factory (Anthropic)
- **Qué hace:** aplica un estilo de colores y letras ya armado a presentaciones, documentos y páginas.
- **Sorprende a:** quien quiere que todo lo que manda se vea parejo sin rehacerlo a mano.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### brand-guidelines (Anthropic)
- **Qué hace:** aplica las reglas de una marca (colores, letras, tono) a lo que se produce. Viene pensada para la marca de Anthropic; sirve de modelo para escribir la del dueño.
- **Sorprende a:** negocios con marca propia que quieren que todo salga con su imagen.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### content-research-writer (ComposioHQ)
- **Qué hace:** ayuda a escribir artículos o publicaciones investigando y citando fuentes mientras se redacta.
- **Sorprende a:** quien publica en blog, boletín o redes y se queda en blanco.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola. Sin verificar el detalle de lo que pide.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

### youtube-transcript y article-extractor (tapestry-skills-for-claude-code)
- **Qué hacen:** sacan el texto de un video de YouTube o de un artículo web para resumirlo, aprender de él o usarlo como base.
- **Sorprende a:** quien sigue a competidores, cursos o noticias de su sector y no tiene tiempo de verlos.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí solas. Sin verificar el detalle de lo que piden.
- **Fuente:** https://github.com/michalparkola/tapestry-skills-for-claude-code

### notebooklm-skill
- **Qué hace:** conecta con NotebookLM de Google para preguntarle a un conjunto de documentos y obtener respuestas con fuente.
- **Sorprende a:** quien tiene manuales, contratos o capacitaciones largas y quiere preguntarles cosas.
- **Instalación:** instalar desde la carpeta del repo. Sin verificar los pasos exactos ni qué cuenta pide.
- **Cuesta:** sin verificar.
- **Fuente:** https://github.com/PleasePrompto/notebooklm-skill

## Ventas

### Ventas (knowledge-work-plugins, Anthropic)
- **Qué hace:** redacta mensajes de primer contacto (draft-outreach), prepara una llamada con un cliente (call-prep), investiga a una empresa (account-research), ayuda a contestar objeciones (handle-objection), revisa a la competencia (competitive-intelligence), repasa el pipeline (pipeline-review) y hace pronósticos de venta (forecast).
- **Sorprende a:** negocios que venden a otras empresas, vendedores, quien cotiza y da seguimiento a mano.
- **Instalación:** instalar desde la carpeta del repo. Algunos conectores (CRM, correo, calendario) son opcionales.
- **Cuesta:** la habilidad no; los conectores dependen de lo que el dueño ya pague.
- **Fuente:** https://github.com/anthropics/knowledge-work-plugins (Apache-2.0)

### lead-research-assistant (ComposioHQ)
- **Qué hace:** busca y ordena posibles clientes que encajen con lo que el negocio ofrece.
- **Sorprende a:** quien vende servicios o mayoreo y no sabe a quién tocarle la puerta.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola. Sin verificar de dónde saca los datos.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

### competitive-ads-extractor (ComposioHQ)
- **Qué hace:** junta los anuncios que corre la competencia para ver qué dicen y cómo venden.
- **Sorprende a:** quien anuncia en redes y quiere ideas de lo que ya funciona en su ramo.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola. Sin verificar de dónde saca los anuncios.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

## Marketing

### Marketing (knowledge-work-plugins, Anthropic)
- **Qué hace:** crea contenido (content-creation), arma un plan de campaña (campaign-plan), revisa que todo suene a la marca (brand-review), compara con la competencia (competitive-brief), escribe series de correos (email-sequence), revisa el posicionamiento en Google (seo-audit) y arma reportes de resultados (performance-report).
- **Sorprende a:** quien hace su propio marketing sin equipo.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** la habilidad no; los conectores dependen de lo que el dueño ya pague.
- **Fuente:** https://github.com/anthropics/knowledge-work-plugins (Apache-2.0)

### marketingskills (Corey Haines)
- **Qué hace:** 53 habilidades de marketing, entre ellas textos de venta (copywriting), redes (social), correos en frío (cold-email), precios (pricing), ofertas (offers), regalos para captar clientes (lead-magnets), lanzamientos (launch), mensajes de texto y WhatsApp (sms), fichas de competidores (competitor-profiling) y plan de marketing (marketing-plan).
- **Sorprende a:** casi cualquier negocio que vende por internet o por WhatsApp.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no.
- **Fuente:** https://github.com/coreyhaines31/marketingskills (MIT)

### domain-name-brainstormer (ComposioHQ)
- **Qué hace:** propone nombres de dominio para una página o proyecto nuevo.
- **Sorprende a:** quien va a abrir tienda en línea o un proyecto aparte.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola; comprar el dominio sí cuesta y pide el «sí» del dueño.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

## Documentos

Las de Anthropic de esta sección no se copian dentro del cerebro: se instalan desde su origen.

### docx, pptx, xlsx, pdf (Anthropic)
- **Qué hacen:** crean y editan documentos de Word (docx), presentaciones (pptx), hojas de cálculo de Excel (xlsx) y PDF.
- **Sorprende a:** casi todos: cotizaciones, propuestas, reportes y hojas de cálculo con fórmulas salen ya hechos.
- **Instalación:** instalar desde la carpeta del repo de cada una.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### doc-coauthoring (Anthropic)
- **Qué hace:** guía para escribir un documento largo entre los dos: ideas, borrador, revisión.
- **Sorprende a:** quien tiene que escribir manuales, propuestas o procedimientos y no sabe por dónde empezar.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### internal-comms (Anthropic)
- **Qué hace:** redacta avisos, resúmenes y boletines internos para el equipo con formato parejo.
- **Sorprende a:** dueños con equipo que mandan los mismos avisos cada semana.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### Productividad y legal (knowledge-work-plugins, Anthropic)
- **Qué hacen:** productividad: tareas y seguimiento; legal: revisar contratos y cláusulas. Sin verificar el detalle de sus habilidades.
- **Sorprende a:** quien firma contratos con proveedores o clientes y no tiene abogado a la mano. No sustituye a un abogado.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí solas.
- **Fuente:** https://github.com/anthropics/knowledge-work-plugins (Apache-2.0)

## Finanzas

### Finanzas (knowledge-work-plugins, Anthropic)
- **Qué hace:** explica por qué una cifra salió distinta de lo esperado (variance-analysis) y cuadra dos listas de movimientos, por ejemplo banco contra ventas (reconciliation).
- **Sorprende a:** quien hace su corte de caja o de mes a mano.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola. Sin verificar que encaje con la práctica mexicana (IVA, SAT): probar con un caso real antes de confiar.
- **Fuente:** https://github.com/anthropics/knowledge-work-plugins (Apache-2.0)

### invoice-organizer (ComposioHQ)
- **Qué hace:** ordena facturas y recibos en carpetas y listas.
- **Sorprende a:** quien junta facturas en el correo o en el celular para su contador.
- **Instalación:** instalar desde la carpeta del repo.
- **Cuesta:** no por sí sola.
- **Nota:** sin verificar que maneje facturas mexicanas (CFDI). Probar con una factura de ejemplo antes de confiar en ella.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

## Atención a clientes

### Atención a clientes (knowledge-work-plugins, Anthropic)
- **Qué hace:** ordena los mensajes de clientes por urgencia (ticket-triage), redacta respuestas (draft-response), arma artículos de ayuda con las preguntas repetidas (kb-article) y prepara el caso cuando un cliente se queja fuerte (customer-escalation).
- **Sorprende a:** quien contesta las mismas dudas por WhatsApp o correo todo el día.
- **Instalación:** instalar desde la carpeta del repo. Los conectores (correo, mensajería) son opcionales.
- **Cuesta:** la habilidad no; los conectores dependen de lo que el dueño ya pague.
- **Nota:** las respuestas son borradores: no se mandan sin que el dueño las vea.
- **Fuente:** https://github.com/anthropics/knowledge-work-plugins (Apache-2.0)

## Para crear tus propias habilidades

### skill-creator (Anthropic)
- **Qué hace:** ayuda a escribir, probar y mejorar una habilidad propia a partir de algo que el dueño hace seguido.
- **Sorprende a:** quien ya tiene una rutina fija y quiere que salga igual cada vez.
- **Instalación:** instalar desde la carpeta del repo. Dentro del cerebro, las rutinas propias se arman con `sistema/rutinas/proponer-automatizacion.md`; esta es un complemento, no su reemplazo.
- **Cuesta:** no.
- **Fuente:** https://github.com/anthropics/skills/tree/main/skills

### awesome-claude-skills (lista de ComposioHQ)
- **Qué es:** una lista grande de habilidades hechas por la comunidad. Sirve para buscar ideas, no para instalar todo.
- **Instalación:** no se instala; se consulta y se instala una por una con el «sí» del dueño. Cada una trae su propia licencia: revisar antes de usar.
- **Cuesta:** depende de cada una.
- **Fuente:** https://github.com/ComposioHQ/awesome-claude-skills

## No las quiere

Una línea por habilidad que el dueño rechazó, con la fecha y sus palabras. Mientras esté aquí, no se vuelve a sugerir.

- Ninguna por ahora.
