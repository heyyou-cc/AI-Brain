#!/bin/bash
# extraer-conversaciones.sh
# Saca de las conversaciones guardadas de Claude Code y Codex SOLO lo que tecleo el dueno,
# tapa claves y lo imprime en pantalla, por paginas. No escribe ningun archivo.
# Las conversaciones que se tuvieron dentro de la carpeta actual (el cerebro) no salen.
# Lee el JSON con JXA (osascript), que trae el Mac.
# Uso: bash extraer-conversaciones.sh -CarpetaPersonal ruta [-Pagina N] [-Tamano 20000]

CARPETA="$HOME"
PAGINA="1"
TAMANO="20000"
SALIDA=""
while [ $# -gt 0 ]; do
  case "$1" in
    -CarpetaPersonal|--carpeta-personal) CARPETA="$2"; shift 2 ;;
    -Pagina|--pagina) PAGINA="$2"; shift 2 ;;
    -Tamano|--tamano) TAMANO="$2"; shift 2 ;;
    -Salida|--salida) SALIDA="$2"; shift 2 ;;
    *) shift ;;
  esac
done
[ -n "$SALIDA" ] && echo 'Aviso: este extractor ya no escribe archivos; -Salida no se usa.'

if ! command -v osascript >/dev/null 2>&1; then
  echo 'Este script necesita osascript (viene con el Mac).'
  exit 1
fi

read -r -d '' JS <<'EOF'
//IO-INICIO
ObjC.import('Foundation');
var fm = $.NSFileManager.defaultManager;
function io_existe(p) { return !!fm.fileExistsAtPath($(p)); }
function io_es_dir(p) {
  var r = Ref();
  var ok = fm.fileExistsAtPathIsDirectory($(p), r);
  return !!ok && !!r[0];
}
function io_listar(p) {
  try {
    var r = fm.contentsOfDirectoryAtPathError($(p), $());
    var a = ObjC.deepUnwrap(r);
    return a || [];
  } catch (e) { return []; }
}
function io_leer(p) {
  try {
    var s = $.NSString.stringWithContentsOfFileEncodingError($(p), $.NSUTF8StringEncoding, $());
    var u = ObjC.unwrap(s);
    return (typeof u === 'string') ? u : null;
  } catch (e) { return null; }
}
function io_mtime(p) {
  try {
    var a = fm.attributesOfItemAtPathError($(p), $());
    return ObjC.unwrap(a.objectForKey($.NSFileModificationDate)).getTime();
  } catch (e) { return 0; }
}
//IO-FIN

var MAX_CONV = 200, MAX_CARACTERES = 400000;
var PREFIJOS = ['<command-name>', '<command-message>', '<command-args>', '<local-command-stdout>', '<system-reminder>', 'Caveat:', '[Request interrupted'];
var tapadas = 0;

function tapar(t) {
  // palabra clave, hasta seis palabras de por medio, luego ":" o "es", luego el valor
  t = t.replace(/\b(contrase(?:\xf1|n|n.)as?|passwords?|claves?|pin|tokens?|llaves?)\b((?:\s+[^\s:]+){0,6}?)(\s*:\s*|\s+es\s*:?\s*)(\S+)/gi,
    function (m, a, b, c) { tapadas++; return a + b + c + '[clave tapada]'; });
  var formas = [
    /sk-[A-Za-z0-9_\-]{16,}/g,
    /gh[pousr]_[A-Za-z0-9]{20,}/g,
    /github_pat_[A-Za-z0-9_]{20,}/g,
    /AKIA[0-9A-Z]{16}/g,
    /xox[abprs]-[A-Za-z0-9\-]{10,}/g,
    /eyJ[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}\.[A-Za-z0-9_\-]{8,}/g,
    /(^|[^\d])((?:\d[ \-]?){12,18}\d)(?!\d)/g
  ];
  for (var i = 0; i < formas.length; i++) {
    if (i === formas.length - 1) {
      t = t.replace(formas[i], function (m, pre) { tapadas++; return pre + '[clave tapada]'; });
    } else {
      t = t.replace(formas[i], function () { tapadas++; return '[clave tapada]'; });
    }
  }
  return t;
}

function esRuido(t) {
  var x = t.replace(/^\s+/, '');
  if (x === '') return true;
  for (var i = 0; i < PREFIJOS.length; i++) if (x.indexOf(PREFIJOS[i]) === 0) return true;
  return false;
}

function dos(n) { return (n < 10 ? '0' : '') + n; }
function fmtFecha(d) { return d.getFullYear() + '-' + dos(d.getMonth() + 1) + '-' + dos(d.getDate()); }
function fmtHora(d) { return fmtFecha(d) + ' ' + dos(d.getHours()) + ':' + dos(d.getMinutes()); }
function fecha(ts, respaldo) {
  var d = ts ? new Date(ts) : null;
  return (d && !isNaN(d.getTime())) ? d : respaldo;
}
function normal(p) { return p ? String(p).replace(/\\/g, '/').replace(/\/+$/, '').toLowerCase() : ''; }

function caminar(dir, acc) {
  var nombres = io_listar(dir);
  for (var i = 0; i < nombres.length; i++) {
    var p = dir + '/' + nombres[i];
    if (io_es_dir(p)) caminar(p, acc);
    else if (/^rollout-.*\.jsonl$/.test(nombres[i])) acc.push(p);
  }
}

function procesar(a) {
  var res = { msgs: [], cwd: '', sub: false };
  var txt = io_leer(a.ruta);
  if (txt === null) return null;
  var lineas = txt.split('\n');
  for (var i = 0; i < lineas.length; i++) {
    var l = lineas[i];
    if (l.length < 10) continue;
    var o;
    if (a.origen === 'claude-code') {
      if (!/"type"\s*:\s*"user"/.test(l)) continue;
      try { o = JSON.parse(l); } catch (e) { continue; }
      if (o.type !== 'user') continue;
      if (o.cwd && !res.cwd) res.cwd = String(o.cwd);
      if (o.isSidechain === true || o.isMeta === true || o.isCompactSummary === true) continue;
      var c = o.message && o.message.content;
      var textos = [];
      if (typeof c === 'string') textos.push(c);
      else if (Array.isArray(c)) {
        for (var j = 0; j < c.length; j++) {
          if (c[j] && c[j].type === 'text' && typeof c[j].text === 'string') textos.push(c[j].text);
        }
      }
      for (var k = 0; k < textos.length; k++) {
        if (!esRuido(textos[k])) res.msgs.push({ ts: o.timestamp, texto: textos[k] });
      }
    } else {
      if (!/"type"\s*:\s*"(session_meta|user_message)"/.test(l)) continue;
      try { o = JSON.parse(l); } catch (e) { continue; }
      var p = o.payload || {};
      if (o.type === 'session_meta') {
        if (p.cwd && !res.cwd) res.cwd = String(p.cwd);
        if (p.source && typeof p.source !== 'string' && JSON.stringify(p.source).indexOf('subagent') >= 0) res.sub = true;
      } else if (o.type === 'event_msg' && p.type === 'user_message') {
        if (typeof p.message === 'string' && !esRuido(p.message)) res.msgs.push({ ts: o.timestamp, texto: p.message });
      }
    }
  }
  return res;
}

function run(argv) {
  var cp = argv[0], pagina = parseInt(argv[1], 10), tam = parseInt(argv[2], 10), cerebro = normal(argv[3]);
  if (!(pagina >= 1)) pagina = 1;
  if (!(tam >= 4000)) tam = 4000;
  var pieza = tam - 1000;
  var archivos = [];
  var dClaude = cp + '/.claude/projects';
  var ds = io_listar(dClaude);
  for (var i = 0; i < ds.length; i++) {
    var sub = dClaude + '/' + ds[i];
    if (!io_es_dir(sub)) continue;
    var fs = io_listar(sub);
    for (var j = 0; j < fs.length; j++) {
      var p = sub + '/' + fs[j];
      if (/\.jsonl$/.test(fs[j]) && !io_es_dir(p)) archivos.push({ ruta: p, origen: 'claude-code' });
    }
  }
  var rs = [];
  caminar(cp + '/.codex/sessions', rs);
  for (var r = 0; r < rs.length; r++) archivos.push({ ruta: rs[r], origen: 'codex' });
  for (var m = 0; m < archivos.length; m++) archivos[m].mt = io_mtime(archivos[m].ruta);
  archivos.sort(function (x, y) { return y.mt - x.mt; });
  archivos = archivos.slice(0, MAX_CONV);

  var paginas = [], actual = '', sigue = '';
  function cerrar() { if (actual.length > 0) { paginas.push(actual); actual = ''; } }
  function agregar(bloque, esCabecera) {
    if (actual.length > 0 && actual.length + bloque.length > tam) {
      cerrar();
      if (!esCabecera) actual = sigue;
    }
    actual += bloque;
  }

  var leidas = 0, conDueno = 0, delCerebro = 0, saltadas = 0, total = 0, tope = false;
  for (var q = 0; q < archivos.length; q++) {
    var a = archivos[q];
    leidas++;
    if (tope) { saltadas++; continue; }
    var res = procesar(a);
    if (res === null || res.sub || res.msgs.length === 0) { saltadas++; continue; }
    var nc = normal(res.cwd);
    if (cerebro && nc && (nc === cerebro || nc.indexOf(cerebro + '/') === 0)) { delCerebro++; continue; }
    var num = conDueno + 1;
    var f0 = fecha(res.msgs[0].ts, new Date(a.mt));
    var cab = '\n=== Conversacion ' + num + ' | ' + a.origen + ' | ' + fmtHora(f0) + ' | carpeta: ' + res.cwd + ' ===\n';
    var bloques = [];
    for (var k = 0; k < res.msgs.length; k++) {
      var fm2 = fecha(res.msgs[k].ts, f0);
      var tx = tapar(res.msgs[k].texto.replace(/\r\n/g, '\n').trim());
      var titulo = '\n### ' + fmtHora(fm2) + '\n\n';
      if (tx.length <= pieza) { bloques.push(titulo + tx + '\n'); }
      else {
        for (var s = 0; s < tx.length; s += pieza) {
          bloques.push((s === 0 ? titulo : '\n### (sigue el mensaje)\n\n') + tx.substring(s, s + pieza) + '\n');
        }
      }
    }
    var largo = cab.length;
    for (var b = 0; b < bloques.length; b++) largo += bloques[b].length;
    if (total + largo > MAX_CARACTERES) { tope = true; saltadas++; continue; }
    conDueno++;
    total += largo;
    sigue = '(sigue la conversacion ' + num + ' | ' + a.origen + ' | ' + fmtHora(f0) + ')\n';
    agregar(cab, true);
    for (var b2 = 0; b2 < bloques.length; b2++) agregar(bloques[b2], false);
  }
  cerrar();

  var M = paginas.length;
  var resumen = 'Resumen: leyo ' + leidas + ' conversaciones; con mensajes del dueno: ' + conDueno + '; de esta misma carpeta (no salen): ' + delCerebro + '; saltadas: ' + saltadas + '; claves tapadas en total: ' + tapadas + '.' + (tope ? ' Se alcanzo el tope de 400 000 caracteres: las mas viejas no salen.' : '');
  if (M === 0) return 'No hay conversaciones del dueno fuera de esta carpeta.\n' + resumen;
  if (pagina > M) return 'No hay pagina ' + pagina + ': son ' + M + ' paginas.\n' + resumen;
  var txt = paginas[pagina - 1];
  var enPagina = txt.split('[clave tapada]').length - 1;
  var fin = (pagina < M) ? '=== Fin de la pagina ' + pagina + ' de ' + M + '. Sigue con -Pagina ' + (pagina + 1) + '. ===' : '=== Fin de la pagina ' + pagina + ' de ' + M + '. Ya no hay mas. ===';
  return '=== Pagina ' + pagina + ' de ' + M + ' | solo los mensajes del dueno, con las claves tapadas | no se escribio ningun archivo ===\n' + txt + '\n' + fin + '\n' + resumen + ' Claves tapadas en esta pagina: ' + enPagina + '.';
}
EOF

osascript -l JavaScript -e "$JS" "$CARPETA" "$PAGINA" "$TAMANO" "$PWD"
