# Rutina: dna-del-negocio

Para qué sirve: armar el documento DNA del negocio con las quince secciones del DNA de heyyou, juntando lo que ya está guardado en `conocimiento/`, con cada dato marcado y sin inventar lo que falta. Sale siempre al cerrar el arranque; el repaso semanal lo vuelve a sacar si cambió algo de peso, y el dueño lo puede pedir cuando quiera.

El DNA es una foto: la verdad sigue en `conocimiento/`. **El DNA nunca suma datos:** todo lo que dice ya está en una nota, y nada vive solo en el DNA. Si el dueño corrige algo del DNA, la corrección va a la nota de `conocimiento/` (con su línea en «Historia») y el DNA se vuelve a sacar; no se corrige solo el documento. **El DNA al día va atado a la lista de correcciones:** cada corrección, cambio o costumbre deja su línea en `conocimiento/dueno/correcciones.md` con «DNA: sí» o «DNA: no», y cada línea con «sí» saca en ese mismo turno una versión nueva con estos pasos, después de cambiar la nota. No esperes al cierre ni al repaso.

## Pasos

1. Lee `conocimiento/_mapa.md` y, con él, las notas de cada carpeta. Lee también `skills/_indice.md` para la sección 11. **El DNA nunca incluye lo privado:** no abras ninguna carpeta `_privado` para armarlo; donde una nota diga «(hay datos en privado)», escribe «hay datos en privado» sin el dato; y lo que `datos_en_privado` del estado marque «por decidir» queda fuera hasta que el dueño conteste. Dentro del arranque, el DNA se arma después de la pregunta de privacidad y de mover lo que él diga.
2. Crea la carpeta con `sistema/rutinas/nuevo-entregable.md`: `trabajo/<AAAA-MM>-dna-del-negocio/`, con el documento `dna-del-negocio.md` y su `leeme.md`. Si ya existe la de este mes, saca una versión nueva (`dna-del-negocio-v2.md`) y apúntala en el `leeme.md`; las de meses pasados no se tocan.
3. Llena la plantilla de abajo, sección por sección:
   - cada dato lleva, al final de su renglón, la marca que trae de su nota (`[confirmado AAAA-MM-DD]`, `[de documento: …]`, `[de la web: …]`, `[inferido: …]`) y el enlace a la nota de donde sale; el enlace no reemplaza la marca. Así se ve un renglón: `- Atiende de lunes a sábado, de 9 a 7 [de documento: horarios.pdf] · [horario](../../conocimiento/operacion/sucursales.md)`. Si la nota no trae marca, pónsela primero en la nota (lo que contó o confirmó el dueño: `[confirmado AAAA-MM-DD]`, con el día en que lo dijo; lo de un archivo: `[de documento: archivo]`) y luego cópiala aquí; si no sabes de dónde salió, `[inferido: …]`;
   - una cifra va como está en su nota: si hay dos (la que sale de los datos crudos y la que da un documento), van las dos, cada una con su fuente;
   - lo que no está guardado se escribe `pendiente`, nunca se rellena. Antes de escribirlo, busca el dato en todas las notas, no solo en la carpeta de la sección: si un documento ya lo definió (qué es un buen mes, una meta), está guardado y no es pendiente;
   - si al armarlo te acuerdas de un dato que no está en ninguna nota (lo leíste o lo dijo el dueño), primero lo guardas en su nota con su marca, según `sistema/clasificacion.md`, y luego lo pones aquí con su enlace;
   - las fechas van como están en la nota, sin completar años ni volver días en fechas; no le agregues fecha ni causa a un dato;
   - en las partes de análisis (2.5, 2.7, 2.8, 2.9, 6.5, 12 y 13) puedes poner tu lectura, marcada `[inferido: de qué notas sale]`, pero nunca un precio, cifra, nombre o fecha que no esté en `conocimiento/`;
   - la sección 3 lleva solo lo que el dueño contó (la frontera del dueño, paso 5 de `sistema/clasificacion.md`): nada de sus archivos ni de tu lectura;
   - nada de claves, números de cuenta ni datos personales, aunque estén en alguna nota por error (si lo ves, sácalo de la nota y avísale).
4. Arriba del documento, un resumen de tres líneas: cuántas partes quedaron con dato, cuántas a medias (solo inferido) y cuántas pendientes, contadas una por una en el documento, no a ojo, y las tres pendientes que más rendiría llenar.
5. **Antes de entregarlo, comprueba renglón por renglón:**
   - [ ] Cada renglón con dato termina con una de las cuatro marcas. Cuenta los renglones con dato y los que traen marca: tienen que dar lo mismo. Un enlace o la palabra «dato» no son marca.
   - [ ] Lo que el dueño contó o confirmó lleva `[confirmado AAAA-MM-DD]`, con su fecha.
   - [ ] Cada dato tiene su enlace a una nota que de verdad lo dice.
   - [ ] Lo que falta dice `pendiente`, sin marca ni relleno.
   - [ ] El resumen de arriba sale de contar en el documento.
   - [ ] Si esta versión sale por una corrección o un cambio, el dato ya está en su nota, con su línea en «Historia»; el valor viejo no aparece en ninguna parte del DNA nuevo (búscalo por su palabra), y su línea en la lista de correcciones dice «DNA: sí».
   - [ ] El documento quedó y su línea está en `trabajo/_indice.md` (AGENTS.md, punto 12).
   - [ ] ¿Todo va en el trato que el dueño usa? Revisaste cada verbo y cada pronombre del mensaje en que se lo entregas contra el trato guardado (de usted, nada de «te», «tu», «me dijiste»; de tú, nada de «le», «su», «me dijo»), sin frases copiadas de esta rutina en el otro trato.
6. Si corre dentro del arranque, no le mandes mensaje aparte: lo dice el apartado «Tu DNA» del mensaje de cierre (`sistema/rutinas/arranque.md`, fase `cierre`). Si no, dile al dueño dónde quedó y, al final, sugiérele en una línea mandarlo a heyyou, sin preguntarlo.
   - **Que sepa qué es heyyou.** El dueño puede no saberlo. La primera vez que lo nombras con este dueño (busca «heyyou» en `sistema/bitacora.md`; si no sale, es la primera), di en media línea qué es y para qué le sirve mandarlo: heyyou es quien le instaló este asistente, y con el DNA conoce su negocio sin volver a preguntarle lo mismo. Apunta en la bitácora que ya se lo explicaste.
   - **No ofrezcas lo que no puedes.** Antes de sugerirlo, mira si en esta sesión hay forma de mandarlo (un conector de correo que pueda enviar). Si la hay, sugiere mandarlo tú. Si no, sugiere dejarlo listo para que lo mande él y dile dónde quedó el archivo; nunca digas «se lo mando» si desde aquí no se puede. Ejemplo neutro: «Sugiero mandarle este DNA a heyyou, quien instaló este asistente, para que conozca el negocio sin volver a preguntar lo mismo; queda en <dónde> para mandarlo».
   - Solo con su «sí»: pregúntale por dónde (el correo o el WhatsApp de su contacto en heyyou) y, si la app puede mandar, manda solo ese archivo; si no puede, dile la ruta para que lo mande él. No mandes nada más. Apunta en el `leeme.md` si se mandó, cuándo y a quién.

## Plantilla

Copia esta estructura al documento. Junto a cada parte va de qué carpeta sale.

```
# DNA del negocio · <nombre del negocio o pendiente>

Sacado el AAAA-MM-DD de conocimiento/. Versión N. Marcas: [confirmado] lo dijo el dueño · [de documento] · [de la web] · [inferido] · pendiente.

Resumen: …

## 1. Wiki del negocio (conocimiento interno)          ← negocio/
1.1 Fórmula de identidad
1.2 Manifiesto de identidad
1.3 Lo que no somos

## 2. DNA empresarial                                   ← negocio/, dinero/, rumbo/
2.1 Qué hace el negocio, en la práctica
2.2 Historia y contexto
2.3 Cómo gana dinero
2.4 Cómo entrega valor
2.5 Cómo pierde dinero
2.6 Qué lo hace distinto
2.7 Qué lo hace vulnerable
2.8 Qué limita su crecimiento hoy
2.9 Las tres automatizaciones que más rendirían en 90 días

## 3. El dueño (solo lo que él contó)                   ← dueno/
3.1 Quién es
3.2 Su día real
3.3 Lo que lo mueve
3.4 Cómo piensa y decide
3.5 Cómo opera
3.6 Cómo comunicarse con él

## 4. Clientes                                          ← clientes/
4.1 Cliente ideal
4.2 Otros segmentos
4.3 Lo que quieren, lo que necesitan y lo que creen necesitar
4.4 Lo que sienten en cada momento
4.5 Las preguntas que siempre hacen
4.6 Las objeciones de siempre y cómo se responden

## 5. Equipo y lo que solo sabe uno                     ← equipo/
5.1 Quién hace qué
5.2 De quién depende el negocio (si falta una persona)
5.3 Lo que se sabe sin estar escrito
5.4 Trabajo repetitivo por puesto
5.5 Errores de siempre por puesto

## 6. Radiografía de la operación                       ← operacion/, rumbo/
6.1 Lo que funciona y no se toca
6.2 Lo que no funciona y desde cuándo
6.3 Lo manual y repetitivo
6.4 Lo crítico y frágil
6.5 Lo que el dueño no alcanza a ver
6.6 Lo que hoy no se puede medir

## 7. Las 31 P                                          ← según conocimiento/_mapa.md
P01 Personas · P02 Procesos · P03 Plataformas · P04 Protocolos · P05 Presupuestos · P06 Publicidad · P07 Proyectos · P08 Prospectos · P09 Productos · P10 Proveedores · P11 Partners · P12 Problemas del negocio · P13 Prioridades · P14 Patrones · P15 Predicciones · P16 Performance · P17 Pérdidas · P18 Poder · P19 Propósito · P20 Pericias (skills) · P21 Propiedad intelectual · P22 Posicionamiento · P23 Promesas · P24 Pruebas · P25 Percepción · P26 Productividad · P27 Planeación · P28 Postventa · P29 Permanencia · P30 Potencial · P31 Problemas del dueño
(una parte por P, con sus datos marcados o «pendiente»; la definición de cada P está en sistema/clasificacion.md)

## 8. Cómo se cotiza                                    ← oferta/
8.1 Datos que se piden antes de cotizar
8.2 Cómo se calcula el precio
8.3 Cómo se ve una cotización formal
8.4 Hasta dónde puede llegar quien cotiza sin el dueño
8.5 Tiempos de respuesta
8.6 Contratos y acuerdos

## 9. La historia del cliente, contada por él            ← clientes/
(cada momento del recorrido del cliente, desde que tiene la necesidad hasta que vuelve a comprar; solo con lo guardado)

## 10. Historias por puesto                              ← equipo/
(por cada puesto del equipo: qué hace, qué necesita, qué lo atora)

## 11. Pericias (skills)                              ← skills/_indice.md
(las skills en uso y las que más le servirían, marcadas [inferido]; las de fábrica y las que creó el dueño)

## 12. Mapa de decisiones                                ← dueno/, rumbo/, sistema/decisiones.md
(comerciales · operativas · financieras · de equipo · estratégicas: quién decide, con qué información, con qué reglas)

## 13. Oportunidades                                     ← rumbo/
13.1 Automatizar en 30 días
13.2 Crecimiento que no se aprovecha
13.3 Herramientas que se pueden conectar
13.4 Posicionamiento

## 14. Instrucciones para un asistente del negocio      ← todo lo anterior
(un texto listo para pegar en un asistente que atienda a sus clientes: quién es el negocio, qué vende, cómo cotiza, cómo habla, qué nunca hace y cuándo pasa el caso al dueño; solo con datos confirmados o de documento, y lo que falte marcado pendiente)

## 15. Reglas del negocio                                ← reglas-del-negocio.md
(precio y descuento · entregas y fechas · crédito y pago · garantía y devolución · tono y marca · cuándo llamar al dueño · lo que nunca se dice ni se promete)
```
