// Por que: ver y editar el BORRADOR de un agente. Editar nunca llega a un lead: eso solo pasa al
// publicar (tools/publicar.mjs). La forma del borrador es la del manifiesto de agent-master.
import { z } from 'zod';

import { BASE, callHub, enc, wrap } from '../hub.mjs';

const agentId = z.string().uuid().describe('id del agente (sale en listar_agentes)');

export const registrarAgentes = (server) => {
  server.registerTool(
    'listar_agentes',
    {
      title: 'Listar agentes',
      description: 'Agentes de agent-master de la cuenta: nombre, estado, modelo y la revision publicada (null = nunca publicado).',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/agents')).data),
  );
  server.registerTool(
    'listar_plantillas',
    {
      title: 'Listar plantillas de agente',
      description: 'Plantillas de las que sale un agente nuevo (por ejemplo prospectador).',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/templates')).data),
  );
  server.registerTool(
    'crear_agente',
    {
      title: 'Crear agente desde plantilla',
      description: 'Crea un agente copiando una plantilla. Queda en borrador: no contesta a nadie hasta publicar_agente.',
      inputSchema: {
        plantilla: z.string().describe('key de la plantilla (de listar_plantillas)'),
        nombre: z.string().min(1).max(120).describe('nombre visible del agente'),
        modelo: z.string().optional().describe("'proveedor:modelo', p. ej. openai:gpt-4.1-mini o anthropic:<modelo>. Sin valor = el de la plantilla"),
      },
    },
    wrap(async ({ plantilla, nombre, modelo }) =>
      (await callHub('POST', BASE + '/agents', { body: { templateKey: plantilla, name: nombre, model: modelo } })).data),
  );
  server.registerTool(
    'ver_borrador',
    {
      title: 'Ver borrador del agente',
      description:
        'Configuracion completa del agente en borrador: name, enabled, settings (modelo, persona, reglas), phases (con tools y mcpServers), ' +
        'transitions, bindings (numeros que atiende) y extras (calificacion, argumentos, seguimientos, plantillas, empresa, pago, agenda, ' +
        'fuente de productos). Leela SIEMPRE antes de cambiar_borrador.',
      inputSchema: { agentId },
      annotations: { readOnlyHint: true },
    },
    wrap(async ({ agentId: id }) => (await callHub('GET', BASE + '/agents/' + enc(id) + '/draft')).data),
  );
  server.registerTool(
    'cambiar_borrador',
    {
      title: 'Cambiar borrador del agente',
      description:
        'Escribe secciones del borrador con la MISMA forma que ver_borrador. Cada seccion enviada se REEMPLAZA completa ' +
        '(phases, transitions, bindings y cada extras.*): manda la lista entera ya editada, no solo lo nuevo. settings es la ' +
        'excepcion: solo cambia los campos que mandes. Lo que no mandes no se toca. Todo o nada (una transaccion). ' +
        'Nunca pongas llaves, tokens ni contrasenas: van en una conexion. No publica: despues usa revisar_borrador.',
      inputSchema: {
        agentId,
        cambios: z.record(z.unknown()).describe('subconjunto del borrador, p. ej. { "settings": { "persona": "..." } }'),
      },
      annotations: { idempotentHint: true },
    },
    wrap(async ({ agentId: id, cambios }) => (await callHub('PATCH', BASE + '/agents/' + enc(id) + '/draft', { body: cambios })).data),
  );
};
