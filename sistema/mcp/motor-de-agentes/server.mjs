// Por que: server MCP (stdio) Agents Motor by Heyyou (agentes del hub heyyou). Le deja a un Claude (Claude Desktop o
// Claude Code) configurar los agentes de agent-master de su cuenta conversando: ver y editar el
// borrador, revisarlo, publicarlo y restaurar revisiones. No hay pantalla de configuracion: esto es.
// ESM standalone: corre solo con su carpeta y sus dependencias, sin nada del resto del cerebro.
//
// Auth: SOLO la API key del usuario (x-api-key, ver hub.mjs). Lo que la persona no
// puede hacer en el hub tampoco lo puede hacer el asistente: leer pide `agentes`, cambiar o publicar
// pide `agentes_tecnico`. La llave solo alcanza las rutas de configuracion de agentes y la lista de cuentas.
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

import { registrarGuia } from './guia.mjs';
import { HUB_API_URL } from './hub.mjs';
import { registrarAgentes } from './tools/agentes.mjs';
import { registrarCatalogo } from './tools/catalogo.mjs';
import { registrarConocimiento } from './tools/conocimiento.mjs';
import { registrarCuentas } from './tools/cuentas.mjs';
import { registrarPublicar } from './tools/publicar.mjs';

const server = new McpServer({ name: 'agents-motor-heyyou', title: 'Agents Motor by Heyyou', version: '0.1.0' });

registrarCuentas(server);
registrarAgentes(server);
registrarPublicar(server);
registrarCatalogo(server);
registrarConocimiento(server);
registrarGuia(server);

await server.connect(new StdioServerTransport());
console.error('[agents-motor] listo (stdio) contra ' + HUB_API_URL);
