#!/bin/bash
# extraer-conversaciones.sh
# Saca de las conversaciones guardadas de Claude Code y Codex SOLO lo que tecleo el dueno,
# tapa claves y lo imprime en pantalla, por paginas. No escribe ningun archivo.
# Las conversaciones que se tuvieron dentro de la carpeta actual (el cerebro) no salen.
# Lee el JSON con JXA (osascript), que trae el Mac.
# Uso: bash extraer-conversaciones.sh -CarpetaPersonal ruta [-Pagina N] [-Tamano 20000]
# Con -Exportacion "ruta" lee, en vez de Claude Code y Codex, la exportacion de claude.ai o de ChatGPT:
# el .zip tal cual o el conversations.json ya descomprimido. Detecta el formato solo.
# Un .zip se abre en memoria con unzip -p (o con python3 si no hay unzip); no se escribe nada.

CARPETA="$HOME"
PAGINA="1"
TAMANO="20000"
SALIDA=""
EXPORT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -CarpetaPersonal|--carpeta-personal) CARPETA="$2"; shift 2 ;;
    -Pagina|--pagina) PAGINA="$2"; shift 2 ;;
    -Tamano|--tamano) TAMANO="$2"; shift 2 ;;
    -Salida|--salida) SALIDA="$2"; shift 2 ;;
    -Exportacion|--exportacion) EXPORT="$2"; shift 2 ;;
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

//EXPORT-INICIO
function leerStdin() {
  var d = $.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile;
  var s = $.NSString.alloc.initWithDataEncoding(d, $.NSUTF8StringEncoding);
  var u = ObjC.unwrap(s);
  return (typeof u === 'string') ? u : '';
}

function epocaATexto(v, respaldo) {
  if (typeof v !== 'number' || !isFinite(v)) return respaldo;
  return new Date(Math.floor(v) * 1000).toISOString();
}

function mensajesClaude(conv) {
  var out = [];
  var ms = Array.isArray(conv.chat_messages) ? conv.chat_messages : [];
  for (var i = 0; i < ms.length; i++) {
    var m = ms[i];
    if (!m || m.sender !== 'human') continue;
    var tx = (typeof m.text === 'string') ? m.text : '';
    if (tx.trim() === '' && Array.isArray(m.content)) {
      var partes = [];
      for (var j = 0; j < m.content.length; j++) {
        var b = m.content[j];
        if (b && b.type === 'text' && typeof b.text === 'string') partes.push(b.text);
      }
      tx = partes.join('\n');
    }
    if (!esRuido(tx)) out.push({ ts: m.created_at, texto: tx });
  }
  return out;
}

function mensajesChatGPT(conv, tsConv) {
  var out = [];
  var mapa = (conv.mapping && typeof conv.mapping === 'object') ? conv.mapping : {};
  var nodos = [];
  var actual = conv.current_node;
  if (typeof actual === 'string' && mapa[actual]) {
    // rama activa: de la hoja hacia la raiz, puesta al derecho
    var vistos = {};
    while (typeof actual === 'string' && mapa[actual] && !vistos[actual]) {
      vistos[actual] = true;
      nodos.unshift(mapa[actual]);
      actual = mapa[actual].parent;
    }
  } else {
    for (var k in mapa) if (Object.prototype.hasOwnProperty.call(mapa, k)) nodos.push(mapa[k]);
    nodos.sort(function (a, b) {
      var ta = (a && a.message && a.message.create_time) || 0, tb = (b && b.message && b.message.create_time) || 0;
      return ta - tb;
    });
  }
  for (var i = 0; i < nodos.length; i++) {
    var msg = nodos[i] && nodos[i].message;
    if (!msg || !msg.author || msg.author.role !== 'user') continue;
    if (msg.metadata && msg.metadata.is_visually_hidden_from_conversation === true) continue;
    var c = msg.content || {};
    if (c.content_type && c.content_type !== 'text' && c.content_type !== 'multimodal_text') continue;
    var partes = [];
    if (Array.isArray(c.parts)) {
      for (var j = 0; j < c.parts.length; j++) {
        if (typeof c.parts[j] === 'string' && c.parts[j].trim() !== '') partes.push(c.parts[j]);
      }
    }
    var tx = partes.join('\n');
    if (esRuido(tx)) continue;
    out.push({ ts: epocaATexto(msg.create_time, tsConv), texto: tx });
  }
  return out;
}

// Devuelve la lista de conversaciones listas: { origen, f, etiqueta, msgs }, las mas nuevas primero.
function conversacionesDeExportacion(textos) {
  var items = [], desconocidas = 0;
  for (var t = 0; t < textos.length; t++) {
    var raiz;
    var crudo = textos[t].replace(new RegExp('^' + String.fromCharCode(0xFEFF)), '');
    if (crudo.replace(/\s+/g, '') === '') continue;
    try { raiz = JSON.parse(crudo); } catch (e) { continue; }
    var lista = Array.isArray(raiz) ? raiz : [raiz];
    for (var i = 0; i < lista.length; i++) {
      var c = lista[i];
      if (!c || typeof c !== 'object') continue;
      if (Array.isArray(c.chat_messages)) {
        items.push({ conv: c, origen: 'claude.ai', titulo: String(c.name || ''), ts: c.created_at || '', f: fecha(c.created_at, null) });
      } else if (c.mapping && typeof c.mapping === 'object') {
        var ts = epocaATexto(c.create_time, '');
        items.push({ conv: c, origen: 'chatgpt', titulo: String(c.title || ''), ts: ts, f: fecha(ts, null) });
      } else desconocidas++;
    }
  }
  items.sort(function (a, b) { return (b.f ? b.f.getTime() : 0) - (a.f ? a.f.getTime() : 0); });
  return { items: items.slice(0, MAX_CONV), desconocidas: desconocidas };
}
//EXPORT-FIN

function run(argv) {
  var cp = argv[0], pagina = parseInt(argv[1], 10), tam = parseInt(argv[2], 10), cerebro = normal(argv[3]);
  var modoExport = argv[4] === 'exportacion';
  if (!(pagina >= 1)) pagina = 1;
  if (!(tam >= 4000)) tam = 4000;
  var pieza = tam - 1000;

  var paginas = [], actual = '', sigue = '';
  function cerrar() { if (actual.length > 0) { paginas.push(actual); actual = ''; } }
  function agregar(bloque, esCabecera) {
    if (actual.length > 0 && actual.length + bloque.length > tam) {
      cerrar();
      if (!esCabecera) actual = sigue;
    }
    actual += bloque;
  }

  var leidas = 0, conDueno = 0, delCerebro = 0, saltadas = 0, total = 0, tope = false, desconocidas = 0;

  // Imprime una conversacion ya reducida a los mensajes del dueno.
  function emitir(origen, f0, etiqueta, msgs) {
    var num = conDueno + 1;
    var cab = '\n=== Conversacion ' + num + ' | ' + origen + ' | ' + fmtHora(f0) + ' | ' + etiqueta + ' ===\n';
    var bloques = [];
    for (var k = 0; k < msgs.length; k++) {
      var fm2 = fecha(msgs[k].ts, f0);
      var tx = tapar(msgs[k].texto.replace(/\r\n/g, '\n').trim());
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
    if (total + largo > MAX_CARACTERES) { tope = true; saltadas++; return; }
    conDueno++;
    total += largo;
    sigue = '(sigue la conversacion ' + num + ' | ' + origen + ' | ' + fmtHora(f0) + ')\n';
    agregar(cab, true);
    for (var b2 = 0; b2 < bloques.length; b2++) agregar(bloques[b2], false);
  }

  if (modoExport) {
    var textos = leerStdin().split('\n@@@SEPARADOR@@@\n');
    var r = conversacionesDeExportacion(textos);
    desconocidas = r.desconocidas;
    for (var q0 = 0; q0 < r.items.length; q0++) {
      var it = r.items[q0];
      leidas++;
      if (tope) { saltadas++; continue; }
      var ms = (it.origen === 'claude.ai') ? mensajesClaude(it.conv) : mensajesChatGPT(it.conv, it.ts);
      if (ms.length === 0) { saltadas++; continue; }
      var f0e = it.f || fecha(ms[0].ts, new Date());
      var tit = tapar(it.titulo).replace(/\s+/g, ' ').trim();
      if (tit === '') tit = '(sin titulo)';
      emitir(it.origen, f0e, 'titulo: ' + tit, ms);
    }
  } else {
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
    for (var rr = 0; rr < rs.length; rr++) archivos.push({ ruta: rs[rr], origen: 'codex' });
    for (var m = 0; m < archivos.length; m++) archivos[m].mt = io_mtime(archivos[m].ruta);
    archivos.sort(function (x, y) { return y.mt - x.mt; });
    archivos = archivos.slice(0, MAX_CONV);

    for (var q = 0; q < archivos.length; q++) {
      var a = archivos[q];
      leidas++;
      if (tope) { saltadas++; continue; }
      var res = procesar(a);
      if (res === null || res.sub || res.msgs.length === 0) { saltadas++; continue; }
      var nc = normal(res.cwd);
      if (cerebro && nc && (nc === cerebro || nc.indexOf(cerebro + '/') === 0)) { delCerebro++; continue; }
      emitir(a.origen, fecha(res.msgs[0].ts, new Date(a.mt)), 'carpeta: ' + res.cwd, res.msgs);
    }
  }
  cerrar();

  var M = paginas.length;
  var extra = tope ? ' Se alcanzo el tope de 400 000 caracteres: las mas viejas no salen.' : '';
  var resumen;
  if (modoExport) {
    resumen = 'Resumen: leyo ' + leidas + ' conversaciones de la exportacion; con mensajes del dueno: ' + conDueno + '; saltadas: ' + saltadas + '; claves tapadas en total: ' + tapadas + '.' + extra +
      (desconocidas > 0 ? ' Entradas con formato desconocido (se ignoraron): ' + desconocidas + '.' : '');
  } else {
    resumen = 'Resumen: leyo ' + leidas + ' conversaciones; con mensajes del dueno: ' + conDueno + '; de esta misma carpeta (no salen): ' + delCerebro + '; saltadas: ' + saltadas + '; claves tapadas en total: ' + tapadas + '.' + extra;
  }
  if (M === 0) return (modoExport ? 'No hay mensajes del dueno en esa exportacion.' : 'No hay conversaciones del dueno fuera de esta carpeta.') + '\n' + resumen;
  if (pagina > M) return 'No hay pagina ' + pagina + ': son ' + M + ' paginas.\n' + resumen;
  var txt = paginas[pagina - 1];
  var enPagina = txt.split('[clave tapada]').length - 1;
  var fin = (pagina < M) ? '=== Fin de la pagina ' + pagina + ' de ' + M + '. Sigue con -Pagina ' + (pagina + 1) + '. ===' : '=== Fin de la pagina ' + pagina + ' de ' + M + '. Ya no hay mas. ===';
  return '=== Pagina ' + pagina + ' de ' + M + ' | solo los mensajes del dueno, con las claves tapadas | no se escribio ningun archivo ===\n' + txt + '\n' + fin + '\n' + resumen + ' Claves tapadas en esta pagina: ' + enPagina + '.';
}
EOF

if [ -n "$EXPORT" ]; then
  if [ ! -f "$EXPORT" ]; then
    echo "No encontre el archivo de exportacion: $EXPORT"
    exit 1
  fi
  SEP=$'\n@@@SEPARADOR@@@\n'
  if [ "$(head -c 2 "$EXPORT")" = "PK" ]; then
    # .zip: se lee en memoria, sin escribir nada
    if command -v unzip >/dev/null 2>&1; then
      ENTRADAS="$(unzip -Z1 "$EXPORT" 2>/dev/null | grep -E '(^|/)conversations(-[0-9]+)?\.json$')"
      if [ -z "$ENTRADAS" ]; then
        echo 'El .zip no trae ningun conversations.json. Revisa que sea la exportacion de claude.ai o de ChatGPT.'
        exit 1
      fi
      DATOS=""
      while IFS= read -r E; do
        [ -z "$E" ] && continue
        [ -n "$DATOS" ] && DATOS="$DATOS$SEP"
        DATOS="$DATOS$(unzip -p "$EXPORT" "$E")"
      done <<< "$ENTRADAS"
    elif command -v python3 >/dev/null 2>&1; then
      DATOS="$(python3 -I -c '
import re, sys, zipfile
z = zipfile.ZipFile(sys.argv[1])
n = [i for i in z.namelist() if re.search(r"(^|/)conversations(-[0-9]+)?\.json$", i)]
if not n:
    sys.exit(3)
sys.stdout.buffer.write("\n@@@SEPARADOR@@@\n".join(z.read(i).decode("utf-8") for i in n).encode("utf-8"))
' "$EXPORT")"
      if [ $? -ne 0 ] || [ -z "$DATOS" ]; then
        echo 'El .zip no trae ningun conversations.json. Revisa que sea la exportacion de claude.ai o de ChatGPT.'
        exit 1
      fi
    else
      echo 'Para abrir el .zip hace falta unzip o python3 y esta compu no tiene ninguno. Descomprime el .zip fuera de esta carpeta y pasa el conversations.json con -Exportacion.'
      exit 1
    fi
  else
    DATOS="$(cat "$EXPORT")"
  fi
  printf '%s' "$DATOS" | osascript -l JavaScript -e "$JS" "$CARPETA" "$PAGINA" "$TAMANO" "$PWD" exportacion
else
  osascript -l JavaScript -e "$JS" "$CARPETA" "$PAGINA" "$TAMANO" "$PWD"
fi
