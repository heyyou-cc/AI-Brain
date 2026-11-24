// Por que: revisar, publicar y restaurar. Publicar y restaurar SI llegan a los leads (agent-master
// usa la revision nueva en segundos), por eso piden confirmado=true despues de preguntarle a la persona.
import { z } from 'zod';

import { BASE, callHub, enc, wrap } from '../hub.mjs';

const agentId = z.string().uuid().describe('id del agente (sale en listar_agentes)');
const confirmado = z.literal(true).describe('true solo despues de que la persona confirmo en la conversacion');

export const registrarPublicar = (server) => {
  server.registerTool(
    'revisar_borrador',
    {
      title: 'Revisar borrador antes de publicar',
      description: 'Problemas que impedirian publicar (issues; incluye nombres de herramientas MCP que el servidor no tiene, con los nombres reales), ' +
        'avisos que no lo impiden (warnings, p. ej. un servidor MCP que no contesto) y que secciones cambiaron (changed). Usala antes de publicar_agente.',
      inputSchema: { agentId },
      annotations: { readOnlyHint: true },
    },
    wrap(async ({ agentId: id }) => (await callHub('GET', BASE + '/agents/' + enc(id) + '/check')).data),
  );
  server.registerTool(
    'publicar_agente',
    {
      title: 'Publicar agente',
      description:
        'Publica el borrador como revision nueva: desde ese momento el agente contesta asi a los leads. Antes: revisar_borrador, ' +
        'explicale a la persona que cambia y pidele confirmacion. Si no hay cambios responde unchanged; si hay problemas los lista.',
      inputSchema: { agentId, confirmado, nota: z.string().max(500).optional().describe('que cambio y por que (queda en el historial)') },
      annotations: { destructiveHint: true },
    },
    wrap(async ({ agentId: id, nota }) =>
      (await callHub('POST', BASE + '/agents/' + enc(id) + '/publish', { body: nota ? { note: nota } : {} })).data),
  );
  server.registerTool(
    'historial_publicaciones',
    {
      title: 'Historial de publicaciones',
      description: 'Revisiones publicadas del agente, la mas nueva primero; served = la que se usa hoy.',
      inputSchema: { agentId, limite: z.number().int().min(1).max(100).optional() },
      annotations: { readOnlyHint: true },
    },
    wrap(async ({ agentId: id, limite }) =>
      (await callHub('GET', BASE + '/agents/' + enc(id) + '/revisions' + (limite ? '?limit=' + limite : ''))).data),
  );
  server.registerTool(
    'restaurar_revision',
    {
      title: 'Restaurar una revision',
      description:
        'Vuelve el agente a como estaba en una revision vieja (reemplaza el borrador y lo publica como revision nueva). ' +
        'Lo que se agrego despues se pierde del borrador. Pide confirmacion diciendo el numero de revision.',
      inputSchema: { agentId, revision: z.number().int().min(1), confirmado },
      annotations: { destructiveHint: true },
    },
    wrap(async ({ agentId: id, revision }) =>
      (await callHub('POST', BASE + '/agents/' + enc(id) + '/restore', { body: { revision } })).data),
  );
};
