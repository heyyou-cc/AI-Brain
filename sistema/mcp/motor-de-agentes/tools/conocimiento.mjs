// Por que: base de conocimiento de la cuenta (lo que el agente consulta con query_knowledge).
// Cargar/listar/borrar desde Claude, para que un dueno no-programador suba su informacion hablando.
// Reusa el RAG del clon (hub.clon_knowledge) via /agent-config/knowledge.
import { z } from 'zod';

import { BASE, callHub, enc, wrap } from '../hub.mjs';

export const registrarConocimiento = (server) => {
  server.registerTool(
    'listar_conocimiento',
    {
      title: 'Conocimiento de la cuenta',
      description:
        'Los documentos de conocimiento de la cuenta (lo que el agente puede consultar con query_knowledge), agrupados por ' +
        'documento con su docId, titulo, fuente y numero de fragmentos. Usa el docId para borrar con borrar_conocimiento.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/knowledge')).data),
  );
  server.registerTool(
    'cargar_conocimiento',
    {
      title: 'Cargar conocimiento a la cuenta',
      description:
        'Indexa un texto en la base de conocimiento de la cuenta para que el agente lo pueda consultar con query_knowledge ' +
        '(politicas, garantias, preguntas frecuentes, como funciona el negocio). Pon el contenido en "texto"; "titulo" y "fuente" ' +
        'son opcionales. Para que el agente lo use, agrega la herramienta query_knowledge a una fase y publica.',
      inputSchema: {
        texto: z.string().min(1).max(20000).describe('el contenido a indexar (texto plano)'),
        titulo: z.string().max(300).optional().describe('titulo corto del documento'),
        fuente: z.string().max(300).optional().describe('de donde salio, p. ej. "FAQ garantia"'),
      },
    },
    wrap(async ({ texto, titulo, fuente }) =>
      (await callHub('POST', BASE + '/knowledge', {
        body: { text: texto, ...(titulo !== undefined ? { title: titulo } : {}), ...(fuente !== undefined ? { source: fuente } : {}) },
      })).data),
  );
  server.registerTool(
    'borrar_conocimiento',
    {
      title: 'Borrar un documento de conocimiento',
      description: 'Borra un documento de la base de conocimiento de la cuenta por su docId (el que da listar_conocimiento). Borra todos sus fragmentos.',
      inputSchema: { docId: z.string().min(1).max(100).describe('docId de listar_conocimiento') },
    },
    wrap(async ({ docId }) => (await callHub('DELETE', BASE + '/knowledge/' + enc(docId))).data),
  );
};
