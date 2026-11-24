// Por que: elegir con que cuenta del hub se trabaja y ver quien contesta cada canal de esa cuenta.
import { z } from 'zod';

import { BASE, callHub, cuenta, fijarCuenta, listarCuentas, wrap } from '../hub.mjs';

export const registrarCuentas = (server) => {
  server.registerTool(
    'listar_cuentas',
    {
      title: 'Listar mis cuentas',
      description: 'Cuentas del hub a las que tienes acceso y cual esta activa. Usala primero si no sabes con que cuenta trabajar.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => ({
      activa: cuenta(),
      cuentas: (await listarCuentas()).map((c) => ({ id: c.id, nombre: c.name })),
    })),
  );
  server.registerTool(
    'elegir_cuenta',
    {
      title: 'Elegir cuenta',
      description: 'Fija la cuenta con la que se trabaja en esta conversacion. Solo acepta cuentas de listar_cuentas.',
      inputSchema: { cuentaId: z.string().describe('id de la cuenta (de listar_cuentas)') },
    },
    wrap(async ({ cuentaId }) => {
      const elegida = (await listarCuentas()).find((c) => c.id === cuentaId);
      if (!elegida) throw new Error('Esa cuenta no esta entre las tuyas. Usa listar_cuentas.');
      fijarCuenta({ id: elegida.id, name: elegida.name });
      return { activa: cuenta() };
    }),
  );
  server.registerTool(
    'ver_canales',
    {
      title: 'Quien contesta cada canal',
      description:
        'Cada canal de la cuenta (WhatsApp, Evolution, correo) con quien contesta a sus leads: agente de agent-master ' +
        '(binding publicado), clon, bot de la cuenta o una URL externa de Meta, mas avisos (dos que contestan el mismo canal, ' +
        'binding a un canal que heychat no tiene, binding que no contesta por un borrador sin publicar). Usala antes de agregar ' +
        'o cambiar bindings, y muestra los avisos tal como vienen.',
      inputSchema: {},
      annotations: { readOnlyHint: true },
    },
    wrap(async () => (await callHub('GET', BASE + '/channels')).data),
  );
};
