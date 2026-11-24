// arranque.mjs: lanzador del motor de agentes de heyyou para el cerebro (Windows y Mac, Node 20 o mayor).
// Lo corre el asistente (Claude Code, Codex o Copilot) como servidor MCP por stdio. stdout es el canal
// del protocolo: todo lo que diga este archivo y npm va a stderr.
//
//   1. Llave: HEYYOU_HUB_KEY (entorno). Si falta: en Windows, el registro de usuario (HKCU\Environment);
//      en Mac, un `export HEYYOU_HUB_KEY=...` de ~/.zshrc, ~/.zprofile, ~/.bash_profile o ~/.profile
//      (las apps de escritorio no leen esos archivos). Se entrega al servidor como HUB_API_KEY.
//      Si no hay llave el servidor arranca igual y cada herramienta explica como ponerla.
//   2. URL: HEYYOU_HUB_URL, o por ahora la del hub de desarrollo. Cuando haya produccion
//      sera https://hub-api.heyyou.cc (basta poner HEYYOU_HUB_URL con esa direccion).
//   3. Si falta node_modules, corre una vez `npm install --omit=dev` en esta carpeta.
import { execFileSync, spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const aqui = fileURLToPath(new URL('.', import.meta.url));
const URL_DEV = 'https://heyyou-hub-api-developer.heyyou.cc';

function delRegistro(nombre) {
  if (process.platform !== 'win32') return null;
  try {
    const s = execFileSync('reg', ['query', 'HKCU\\Environment', '/v', nombre], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] });
    const m = s.match(/REG_[A-Z_]+\s+(\S.*)$/m);
    return m ? m[1].trim() : null;
  } catch {
    return null;
  }
}

function delPerfil(nombre) {
  if (process.platform !== 'darwin' && process.platform !== 'linux') return null;
  for (const f of ['.zshrc', '.zprofile', '.zshenv', '.bash_profile', '.bashrc', '.profile']) {
    try {
      const txt = readFileSync(join(homedir(), f), 'utf8');
      const re = new RegExp('^\\s*export\\s+' + nombre + '\\s*=\\s*(?:"([^"]*)"|\'([^\']*)\'|(\\S+))\\s*$', 'm');
      const m = txt.match(re);
      if (m) return (m[1] ?? m[2] ?? m[3] ?? '').trim();
    } catch {
      // el archivo no existe: se sigue con el siguiente
    }
  }
  return null;
}

const valor = (nombre) => (process.env[nombre] || delRegistro(nombre) || delPerfil(nombre) || '').trim();

// Se ignoran HUB_API_KEY y HUB_API_URL del entorno: son nombres genericos y en otras compus apuntan a otra
// cosa (por ejemplo a produccion). Aqui mandan solo HEYYOU_HUB_KEY y HEYYOU_HUB_URL.
process.env.HUB_API_KEY = valor('HEYYOU_HUB_KEY');
process.env.HUB_API_URL = valor('HEYYOU_HUB_URL') || URL_DEV;

if (!existsSync(join(aqui, 'node_modules', '@modelcontextprotocol'))) {
  console.error('[motor-de-agentes] Primera vez: instalando lo que necesita (npm install, una sola vez)...');
  const r = spawnSync('npm install --omit=dev --no-audit --no-fund', {
    cwd: aqui,
    stdio: ['ignore', 2, 2],
    shell: true,
  });
  if (r.status !== 0) {
    console.error('[motor-de-agentes] No pude instalar (npm install fallo). Revisa tu internet y que Node 20 o mayor este instalado.');
    process.exit(1);
  }
}

await import(new URL('./server.mjs', import.meta.url).href);
