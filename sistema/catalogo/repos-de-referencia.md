Para qué sirve: lista de proyectos abiertos que NO se instalan en el cerebro; el agente solo se los sugiere al dueño cuando tiene un problema que encaja. Datos revisados el 2026-11-23; las estrellas son aproximadas y pueden haber cambiado.

## Cómo usa esto el agente

- Sugiere, nunca instala por su cuenta. Solo menciona uno cuando el dueño tiene un problema que encaja, y uno a la vez.
- Antes de proponerlo explica en llano qué pide: si necesita servidor, llaves de pago, un teléfono conectado o a alguien que sepa de computadoras.
- Si el dueño dice que sí, instalar o probar es trabajo aparte con su propio «sí» (AGENTS.md, punto 8); esta lista no autoriza nada.
- Si la dificultad es alta o hay riesgo, dice que conviene que lo monte alguien que sepa.
- Si dudas de que un dato siga vigente, lo dices y compruebas en la página del proyecto antes de afirmarlo.

## Que la IA use mi teléfono o mi navegador

### ARTEMIS
- **URL:** https://github.com/google/artemis
- **Lo mantiene:** Google (Apache-2.0, ~18 mil estrellas).
- **Le resuelve:** que la IA maneje un teléfono Android con instrucciones en español: abrir apps, tocar, llenar cosas.
- **Dificultad:** media.
- **Requisito o riesgo:** Python 3.12 o más nuevo, y un teléfono con depuración USB o un emulador. Trae conexión (MCP) para Claude Code. Solo Android. Puede marcar como hechos pasos que no hizo: hay que revisar el resultado.

### mobile-use (minitap-ai)
- **URL:** https://github.com/minitap-ai/mobile-use
- **Lo mantiene:** minitap-ai (Apache-2.0, ~3.4 mil estrellas).
- **Le resuelve:** lo mismo que ARTEMIS, pero también en iPhone.
- **Dificultad:** media.
- **Requisito o riesgo:** necesita una llave de un modelo de IA de pago.

### browser-use
- **URL:** https://github.com/browser-use/browser-use
- **Lo mantiene:** browser-use (MIT, ~122 mil estrellas).
- **Le resuelve:** que la IA navegue páginas, llene formularios y haga trámites repetidos en la web.
- **Dificultad:** media.
- **Requisito o riesgo:** necesita llave de un modelo de IA (cuesta por uso). Que la IA llene formularios en cuentas reales es riesgoso: probar primero con algo sin consecuencias.

## Trabajar con agentes en proyectos

### everything-claude-code
- **URL:** https://github.com/affaan-m/everything-claude-code
- **Lo mantiene:** Affaan M. (MIT, ~310 mil estrellas).
- **Le resuelve:** una configuración completa de Claude Code ya armada, con muchas habilidades, agentes y reglas.
- **Dificultad:** media.
- **Requisito o riesgo:** la prensa la atribuye a un ganador de un hackathon de Anthropic; no está confirmado. Trae mucho: puede chocar con las reglas del cerebro, así que se prueba aparte, no encima.

### superpowers
- **URL:** https://github.com/obra/superpowers
- **Lo mantiene:** obra.
- **Le resuelve:** un método de habilidades para planear, probar y revisar antes de dar algo por hecho.
- **Dificultad:** baja.
- **Requisito o riesgo:** licencia sin verificar.

### spec-kit
- **URL:** https://github.com/github/spec-kit
- **Lo mantiene:** GitHub.
- **Le resuelve:** trabajar por especificación: escribir primero qué se quiere y luego construirlo, ideal para proyectos con código.
- **Dificultad:** media.
- **Requisito o riesgo:** pensado para quien desarrolla software.

### BMAD-METHOD
- **URL:** https://github.com/bmad-code-org/BMAD-METHOD
- **Lo mantiene:** bmad-code-org.
- **Le resuelve:** un equipo de agentes con roles (analista, arquitecto, desarrollador) para proyectos grandes.
- **Dificultad:** media.
- **Requisito o riesgo:** pensado para desarrollo de software; licencia sin verificar.

### wshobson/agents
- **URL:** https://github.com/wshobson/agents
- **Lo mantiene:** wshobson.
- **Le resuelve:** una colección de plugins, agentes y comandos listos para Claude Code.
- **Dificultad:** baja.
- **Requisito o riesgo:** licencia sin verificar; revisar qué instala antes de aceptar.

## Automatizar sin programar

### n8n
- **URL:** https://github.com/n8n-io/n8n
- **Lo mantiene:** n8n.
- **Le resuelve:** que una cosa pase sola cuando otra ocurre (llega un pedido, se llena un formulario) uniendo más de 400 aplicaciones.
- **Dificultad:** media.
- **Requisito o riesgo:** licencia «fair-code», no es abierta del todo. Necesita un servidor propio o su nube de pago.

### activepieces
- **URL:** https://github.com/activepieces/activepieces
- **Lo mantiene:** activepieces (MIT en su parte comunitaria).
- **Le resuelve:** lo mismo que Zapier, con unos 400 conectores para agentes de IA (MCP).
- **Dificultad:** media.
- **Requisito o riesgo:** servidor propio o su nube; parte de las funciones son de pago.

## Juntar información de la web

### firecrawl
- **URL:** https://github.com/firecrawl/firecrawl
- **Lo mantiene:** firecrawl (AGPL-3.0).
- **Le resuelve:** convertir páginas web en texto limpio para que la IA las lea, por ejemplo para revisar a la competencia.
- **Dificultad:** baja con su servicio.
- **Requisito o riesgo:** el servicio fácil es de pago por API; la licencia AGPL pesa si se monta propio y se ofrece a terceros.

## Clientes y ventas

### twenty
- **URL:** https://github.com/twentyhq/twenty
- **Lo mantiene:** twentyhq.
- **Le resuelve:** un CRM abierto: lista de clientes, ventas en proceso y seguimiento, sin pagar licencia por usuario.
- **Dificultad:** media.
- **Requisito o riesgo:** se monta con Docker en un servidor. Licencia sin verificar.

## Voz y llamadas

### pipecat
- **URL:** https://github.com/pipecat-ai/pipecat
- **Lo mantiene:** pipecat-ai.
- **Le resuelve:** un agente de voz que contesta llamadas del negocio.
- **Dificultad:** alta.
- **Requisito o riesgo:** hay que programar y pagar servicios de voz y de modelo; conviene que lo monte alguien que sepa. Licencia sin verificar.

## Video

### remotion
- **URL:** https://github.com/remotion-dev/remotion
- **Lo mantiene:** remotion-dev.
- **Le resuelve:** hacer videos con código: plantillas que se repiten con otros datos (un video por producto, por ejemplo).
- **Dificultad:** media.
- **Requisito o riesgo:** en algunos casos pide licencia de empresa de pago; revisar antes de usarlo con fines comerciales.

## Memoria y juntas

### khoj
- **URL:** https://github.com/khoj-ai/khoj
- **Lo mantiene:** khoj-ai.
- **Le resuelve:** un asistente que contesta con los documentos propios del dueño, que se puede alojar en su propia máquina.
- **Dificultad:** media.
- **Requisito o riesgo:** licencia sin verificar. Si se aloja solo, los documentos no salen de su equipo.

### Meetily
- **URL:** https://github.com/Zackriya-Solutions/meeting-minutes
- **Lo mantiene:** Zackriya-Solutions (MIT).
- **Le resuelve:** transcribir y resumir juntas en su computadora sin mandar el audio a ningún servicio.
- **Dificultad:** baja.
- **Requisito o riesgo:** pide una computadora con algo de potencia; avisar a los participantes que se graba.

## Conectar más herramientas

### servidores MCP de referencia
- **URL:** https://github.com/modelcontextprotocol/servers
- **Lo mantiene:** el proyecto Model Context Protocol.
- **Le resuelve:** conectar a la IA con archivos, bases de datos y otras herramientas por medio de conectores estándar.
- **Dificultad:** baja a media.
- **Requisito o riesgo:** cada conector da acceso a algo real: instalar solo los que se necesiten y con el «sí» del dueño. Son ejemplos de referencia, no productos listos.
