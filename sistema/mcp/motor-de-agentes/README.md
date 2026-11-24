# Motor de agentes de heyyou

Para qué sirve: conecta tu asistente con los agentes de tu cuenta del Hub de heyyou (los que contestan a tus clientes por WhatsApp o correo) para que los configure desde el chat. Le puedes pedir cosas como «¿cómo contesta hoy mi agente de ventas?» o «hazlo más breve y que nunca dé precios sin preguntar la cantidad». El asistente cambia el **borrador**, lo revisa y, **solo cuando tú confirmas**, lo publica. Publicar es lo único que llega a tus clientes.

## Qué necesita

- Node 20 o mayor. La primera vez instala lo que le falta (una sola vez, tarda unos segundos).
- Tu llave del Hub, en la variable `HEYYOU_HUB_KEY`. Te la da tu administrador de heyyou; no la pegues en el chat. Cómo ponerla está en `LEEME.md`, sección «Motor de agentes de heyyou».
- Opcional: `HEYYOU_HUB_URL`, si quieres apuntar a otro Hub (por ahora apunta al de desarrollo).

## Cómo arranca

Tu asistente lo arranca solo con `arranque.mjs`, desde `.mcp.json`, `.vscode/mcp.json` o `.codex/config.toml`. Sin llave arranca igual y cada herramienta te dice qué falta.

## Qué le puedes pedir

| Quieres… | El asistente usa |
|---|---|
| Ver tus agentes y cómo contestan | `listar_agentes`, `ver_borrador` |
| Crear un agente nuevo desde una plantilla | `listar_plantillas`, `crear_agente` |
| Cambiar tono, reglas, fases, seguimientos, plantillas, datos de la empresa… | `cambiar_borrador` |
| Saber si el cambio está bien y qué verá el cliente distinto | `revisar_borrador` |
| Que el cambio llegue a los clientes (te pide confirmación) | `publicar_agente` |
| Ver qué se publicó y regresar a una versión anterior | `historial_publicaciones`, `restaurar_revision` |
| Ver qué herramientas o sistemas puede usar una fase | `listar_herramientas`, `listar_servidores_mcp`, `guardar_servidor_mcp` |
| Guardar la llave de un sistema (se cifra y no se vuelve a mostrar) | `listar_conexiones`, `guardar_conexion` |
| Ver los nombres exactos de las herramientas de un servidor | `listar_herramientas_servidor_mcp` |
| Conectar un API propio como herramienta del agente | `guardar_herramienta_http` |
| Cambiar de cuenta (si tienes varias) | `listar_cuentas`, `elegir_cuenta` |

## Si algo falla

- «La llave no es válida o fue rotada»: pide tu llave actual.
- «Sin permiso»: tu usuario puede ver agentes pero no cambiarlos; pídele el permiso a tu administrador.
- «No guardes secretos en la configuración»: una llave o contraseña va en una conexión, no en el agente.
- «Ese número o buzón ya lo atiende otro agente»: un número solo puede tener un agente.
- «No se pudo conectar al hub»: revisa tu internet y la dirección del Hub.
