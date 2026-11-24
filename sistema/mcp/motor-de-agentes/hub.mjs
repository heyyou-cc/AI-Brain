// Por que: cliente HTTP del hub para el MCP de agentes. Manda solo la llave del usuario en
// x-api-key; el hub la canjea por la sesion de esa persona y aplica su membresia y sus
// permisos (agentes / agentes_tecnico).
// Va en esta misma carpeta, sin importar nada de fuera: el motor se empaca solo con ella.
//
// Cuenta activa: con una sola cuenta se usa sola; con varias, Claude pregunta y llama
// elegir_cuenta. Vive en memoria del proceso (un proceso por conversacion de Claude).
export const HUB_API_URL = (process.env.HUB_API_URL || 'https://hub-api.heyyou.cc').replace(/\/+$/, '');
const API_KEY = (process.env.HUB_API_KEY || '').trim();

// Sin llave el servidor arranca igual: cada herramienta dice como ponerla.
const SIN_LLAVE =
  "Falta tu llave del hub. Ponla en la variable de usuario HEYYOU_HUB_KEY y reinicia tu asistente. " +
  "Windows (PowerShell): $k = Read-Host 'Pega tu llave' -AsSecureString; [Environment]::SetEnvironmentVariable('HEYYOU_HUB_KEY', [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($k)), 'User'). " +
  "Mac (zsh): read -s \"k?Pega tu llave: \"; echo \"export HEYYOU_HUB_KEY=$k\" >> ~/.zshrc; unset k, y abre una terminal nueva. " +
  "Pide tu llave a tu administrador de heyyou; no la pegues en el chat.";
if (!API_KEY) console.error("[agents-motor] " + SIN_LLAVE);

let cuentaActiva = null; // { id, name }
export const cuenta = () => cuentaActiva;
export const fijarCuenta = (c) => { cuentaActiva = c; };

// Los problemas de un borrador (422 al publicar) se listan: Claude los corrige sin adivinar.
const detalle = (json) => {
  const issues = json?.data?.issues;
  if (Array.isArray(issues) && issues.length) return '\n' + issues.map((i) => '- ' + i.path + ': ' + i.message).join('\n');
  return json?.detail ? ' — ' + json.detail : '';
};

export const callHub = async (method, path, { body, conCuenta = true } = {}) => {
  if (!API_KEY) throw new Error(SIN_LLAVE);
  const headers = { 'x-api-key': API_KEY, accept: 'application/json' };
  if (body !== undefined) headers['content-type'] = 'application/json';
  if (conCuenta) headers['x-account-id'] = (await asegurarCuenta()).id;
  let res;
  try {
    res = await fetch(HUB_API_URL + path, { method, headers, body: body !== undefined ? JSON.stringify(body) : undefined });
  } catch (e) {
    throw new Error(
      'No se pudo conectar al hub en ' + HUB_API_URL + ' (' + (e?.message ?? e) + '). ' +
      'Revisa tu internet y que la URL del hub sea la correcta (por defecto https://hub-api.heyyou.cc).',
    );
  }
  const text = await res.text();
  if (!(res.headers.get('content-type') || '').includes('application/json')) {
    throw new Error(
      'El hub respondio ' + res.status + ' en un formato inesperado. ' +
      "La URL configurada ('" + HUB_API_URL + "') probablemente no es la del backend del hub (hub-api), no la pagina.",
    );
  }
  let json;
  try {
    json = text ? JSON.parse(text) : {};
  } catch {
    throw new Error('El hub respondio algo que no es JSON valido.');
  }
  if (res.status === 401) throw new Error('La llave no es valida o fue rotada. Pide tu llave actual en el hub.');
  if (res.status === 403) throw new Error((json?.message || json?.detail || json?.error || 'Sin permiso') + ' (403).');
  if (!res.ok) throw new Error((json?.message || json?.error || 'El hub respondio ' + res.status) + detalle(json));
  return json;
};

export const listarCuentas = async () => (await callHub('GET', '/api/heychat/accounts', { conCuenta: false })).accounts ?? [];

async function asegurarCuenta() {
  if (cuentaActiva) return cuentaActiva;
  const cuentas = await listarCuentas();
  if (cuentas.length === 1) {
    cuentaActiva = { id: cuentas[0].id, name: cuentas[0].name };
    return cuentaActiva;
  }
  if (!cuentas.length) throw new Error('Tu usuario no tiene cuentas en el hub.');
  throw new Error(
    'Tienes acceso a ' + cuentas.length + ' cuentas. Pregunta con cual trabajar y llama elegir_cuenta. ' +
    'Cuentas: ' + cuentas.map((c) => c.name + ' (' + c.id + ')').join(', '),
  );
}

const ok = (data) => ({ content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] });
const fail = (e) => ({ content: [{ type: 'text', text: 'Error: ' + (e?.message ?? String(e)) }], isError: true });
export const wrap = (fn) => async (args) => {
  try {
    return ok(await fn(args));
  } catch (e) {
    return fail(e);
  }
};

export const BASE = '/api/heychat/agent-config';
export const enc = encodeURIComponent;
