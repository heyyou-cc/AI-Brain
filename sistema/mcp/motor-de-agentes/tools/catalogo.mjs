// Por que: lo que una fase puede usar: herramientas del catalogo y servidores MCP de la cuenta.
import { z } from 'zod';

import { BASE, callHub, enc, wrap } from '../hub.mjs';

export const registrarCatalogo = (server) => {
  server.registerTool(
    'listar_herramientas',
    {
      title: 'Catalogo de herramientas',
      description: 'Herramientas que una fase puede usar (phases[].tools[].toolKey), con su descripcion y si tienen efecto (sideEffect).',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/tools')).data),
  );
  server.registerTool(
    'listar_servidores_mcp',
    {
      title: 'Servidores MCP de la cuenta',
      description: 'Servidores MCP (ERP, punto de venta, Flows...) que una fase puede colgar por nombre en phases[].mcpServers.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/mcp-servers')).data),
  );
  server.registerTool(
    'listar_recursos',
    {
      title: 'Recursos (archivos) de la cuenta',
      description:
        'Archivos que un agente puede enviar con send_resource (catálogos, imágenes, PDFs). Copia el title EXACTO a la ' +
        'instrucción de la fase (p. ej. "envía el recurso Catálogo con send_resource"). Se suben en la galería de medios del agente.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/resources')).data),
  );
  server.registerTool(
    'listar_plantillas_whatsapp',
    {
      title: 'Plantillas de WhatsApp reales de la cuenta',
      description:
        'Las plantillas de Meta (WhatsApp Cloud) de la cuenta y si el agente puede usarlas (usable, reason). Usala SIEMPRE antes de ' +
        'escribir extras.messageTemplates de channel whatsapp: copia name -> metaTemplateName, language y body EXACTOS. Nunca ' +
        'inventes un nombre: publicar lo bloquea si la plantilla no existe aprobada en la cuenta.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/whatsapp-templates')).data),
  );
  server.registerTool(
    'listar_herramientas_servidor_mcp',
    {
      title: 'Herramientas reales de un servidor MCP',
      description:
        'El hub se conecta al servidor (con su conexion) y lista sus herramientas con el nombre EXACTO. Usala SIEMPRE antes de ' +
        'escribir toolAllowList o requiredTools: copia los nombres de aqui, nunca los adivines (un nombre que no existe no se ofrece al agente).',
      inputSchema: { nombre: z.string().min(1).max(120).describe('nombre del servidor MCP de la cuenta') },
      annotations: { readOnlyHint: true },
    },
    wrap(async ({ nombre }) => (await callHub('GET', BASE + '/mcp-servers/' + enc(nombre) + '/tools')).data),
  );
  server.registerTool(
    'guardar_servidor_mcp',
    {
      title: 'Guardar servidor MCP de la cuenta',
      description:
        'Crea o actualiza (por nombre) un servidor MCP de la cuenta. URL https sin usuario ni contrasena; si pide credencial, ' +
        'va en una conexion (por nombre). Cambiarlo afecta a todos los agentes de la cuenta que lo usen.',
      inputSchema: {
        nombre: z.string().min(1).max(120),
        url: z.string().url().describe('https://...'),
        conexion: z.string().nullable().optional().describe('nombre de la conexion con la credencial, si hace falta'),
        habilitado: z.boolean().optional(),
      },
    },
    wrap(async ({ nombre, url, conexion, habilitado }) =>
      (await callHub('PUT', BASE + '/mcp-servers/' + enc(nombre), {
        body: { url, ...(conexion !== undefined ? { connection: conexion } : {}), ...(habilitado !== undefined ? { enabled: habilitado } : {}) },
      })).data),
  );
  server.registerTool(
    'listar_conexiones',
    {
      title: 'Conexiones de la cuenta',
      description: 'Credenciales guardadas (para servidores MCP, APIs o bases). Nunca muestra el secreto: solo hasSecret y cuando se uso.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/connections')).data),
  );
  server.registerTool(
    'guardar_conexion',
    {
      title: 'Guardar conexion (credencial) de la cuenta',
      description:
        'Crea o actualiza (por nombre) una credencial de la cuenta. El secreto se guarda cifrado en el hub y nunca se vuelve a mostrar; ' +
        'sin secreto se conserva el anterior. Para un servidor MCP: tipo mcp y config { header: "x-api-key" } o ' +
        '{ header: "Authorization", scheme: "Bearer" } (por omision). Despues ligala con guardar_servidor_mcp (conexion = este nombre) ' +
        'o con extras.productSource.connection. Para una base (postgres, mysql, mariadb): config { host, port (numero), database, ' +
        'user, ssl (true por omision) } y el secreto = SOLO la contrasena (usa un usuario de solo lectura). ' +
        'Despues publica el agente. El secreto lo escribe la persona misma: en la ventanita del cerebro (ver sistema/accesos/_leeme.md) o en el Hub; ' +
        'nunca se lo pidas por el chat, nunca lo inventes ni lo repitas.',
      inputSchema: {
        nombre: z.string().min(1).max(120),
        tipo: z.enum(['mcp', 'http', 'postgres', 'mysql', 'mariadb', 'mssql']),
        config: z.record(z.unknown()).optional().describe('sin secretos: header, scheme...'),
        secreto: z.string().min(1).max(8192).optional().describe('llave o token; solo de entrada'),
      },
    },
    wrap(async ({ nombre, tipo, config, secreto }) =>
      (await callHub('PUT', BASE + '/connections/' + enc(nombre), {
        body: { kind: tipo, ...(config !== undefined ? { config } : {}), ...(secreto !== undefined ? { secret: secreto } : {}) },
      })).data),
  );
  server.registerTool(
    'guardar_herramienta_http',
    {
      title: 'Guardar herramienta HTTP de la cuenta',
      description:
        'Crea o actualiza (por clave) una herramienta que hace UNA llamada HTTP a un API de la cuenta (pedidos, inventario, CRM...). ' +
        'Despues agregala a una fase (phases[].tools[].toolKey = clave) y publica. url https; los {parametros} del modelo solo en la ruta ' +
        '(p. ej. https://api.ejemplo.com/pedidos/{folio}) o en query; cada {parametro} debe estar en parametros.properties. ' +
        'Nunca pongas llaves en headers ni query: guardala con guardar_conexion y pasa su nombre en conexion.',
      inputSchema: {
        clave: z.string().regex(/^[a-z0-9_]{2,64}$/).describe('minusculas, numeros y _'),
        descripcion: z.string().min(5).max(1000).describe('para el modelo: que hace y cuando usarla'),
        parametros: z.record(z.unknown()).describe('JSON Schema de la entrada: { type: "object", properties: {...}, required: [...] }'),
        metodo: z.enum(['GET', 'POST', 'PUT', 'PATCH', 'DELETE']),
        url: z.string().url(),
        query: z.record(z.string()).optional().describe('parametros de consulta; valores pueden usar {parametro}'),
        headers: z.record(z.string()).optional().describe('sin secretos, p. ej. { Accept: "application/json" }'),
        rutaRespuesta: z.string().optional().describe('parte de la respuesta JSON que ve el modelo, p. ej. data.items'),
        conexion: z.string().nullable().optional().describe('nombre de la conexion con la llave, si el API la pide'),
        conEfecto: z.boolean().optional().describe('true si cambia algo (crear, pagar...). Por omision: solo GET es de lectura'),
      },
    },
    wrap(async ({ clave, descripcion, parametros, metodo, url, query, headers, rutaRespuesta, conexion, conEfecto }) =>
      (await callHub('PUT', BASE + '/tools/' + enc(clave), {
        body: {
          description: descripcion, inputSchema: parametros,
          httpConfig: { method: metodo, url, ...(query ? { query } : {}), ...(headers ? { headers } : {}), ...(rutaRespuesta ? { responsePath: rutaRespuesta } : {}) },
          ...(conexion !== undefined ? { connection: conexion } : {}), ...(conEfecto !== undefined ? { sideEffect: conEfecto } : {}),
        },
      })).data),
  );
};
