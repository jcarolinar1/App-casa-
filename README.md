# Casa en Orden 3.6 · Documentos

Lee **GUIA_DOCUMENTOS_3_6.md** antes de la actualización. Conserva todo el resto de las funciones de 3.5. El nuevo SQL para Office/PDF es `supabase_documentos_actualizacion.sql`; ejecútalo sólo cuando la base de Casa en Orden ya esté instalada.

# CASA EN ORDEN 3.5 · DOS CASAS Y ADMINISTRADORES

Lee primero **LEEME_DOS_CASAS.md**.

# Casa en Orden 3.5 💜 · Dos casas y administradores independientes (versión de prueba)


**Novedad principal:** en Inicio → **Preparar modo sin internet** podrás guardar los archivos básicos de la app para entrar después desde el icono de iPhone sin conexión. Mercado, despensa, finanzas, agenda, comprobantes locales y versión imprimible funcionan localmente. La lectura automática de recibos y la generación avanzada de PDF pueden necesitar archivos previamente descargados, y la nube siempre necesita conexión. Lee `PRUEBA_SIN_INTERNET.md`.

Aplicación web instalable en iPhone desde Safari, diseñada para funcionar como PWA. **No es una app de la App Store ni actualiza automáticamente la instalada**. Mantiene la identidad morada de Casa en Orden 3.0.

## Diez mejoras y mini-comprobantes incluidas

1. **Vista previa de PDF**: se puede elegir mes o año, apartados (gráficos, comparación, movimientos, métodos, soportes), y diseño **colorido** o **económico**.
2. **Resumen financiero**: ingresos, egresos e inversiones separados; disponible orientativo; comparación con el mes anterior, gráficos por categoría, método de pago y responsable.
3. **Soportes ordenados**: cada movimiento puede tener foto o PDF; el informe señala movimientos sin soporte. Al descargar desde «PDF con anexos», intenta incorporar el documento original y advierte si no puede hacerlo.
4. **Calendario único**: aseo, pagos y citas. El calendario imprimible diferencia actividades por colores. Citas, pagos y vencimientos de despensa se pueden exportar como `.ics` para Calendario de iPhone.
5. **Mercado + despensa**: producto agotado → salir de la despensa → reponer en mercado (opcional), historial de agotados y lista imprimible. Fecha de vencimiento y días de aviso por producto.
6. **Menús semanales**: adultos y bebé por separado; comidas editables, recetas con preparación y cantidades orientativas por porción en la versión imprimible, y lista de ingredientes faltantes. Se descuentan alimentos de la despensa solo al confirmar cuánto se usó.
7. **Historial de cambios**: agrega, modifica o retira registros y muestra el responsable identificado por la cuenta familiar conectada o por el nombre configurado para ese iPhone. Permite consultar/restaurar estados previos guardados localmente.
8. **Avisos anticipados**: 0, 1, 3 o 7 días para citas, pagos y productos con vencimiento. Los avisos dentro de la PWA aparecen al abrirla; para avisos del sistema exporta el archivo al Calendario del iPhone.
9. **Privacidad y respaldos**: estados previos guardados automáticamente en el dispositivo (hasta ocho instantáneas, limitadas por espacio); exportación de respaldo **completo** JSON con soportes; nube Supabase opcional con autenticación, permisos y almacenamiento privado (requiere configuración y pruebas entre dispositivos).
10. **Cierre mensual**: ingreso, gasto, inversión, mercado, cuentas por pagar, tareas de aseo y número de comprobantes. Puedes reabrir y actualizar el cierre al corregir un movimiento.

## Instalar y probar SIN reemplazar la versión anterior

1. En el iPhone abre **Archivos**, localiza el ZIP descargado, tócala para descomprimirlo y abre la carpeta.
2. Crea en GitHub **otro repositorio**, por ejemplo `Casa-en-orden-v31-prueba` (GitHub Pages gratuito requiere repositorio público en la configuración habitual).
3. Sube **todos los archivos de esta carpeta directamente a la raíz del repositorio** (no el ZIP y no una carpeta contenedora).
4. En el repositorio abre **Settings → Pages → Deploy from a branch → main → /(root) → Save**.
5. La dirección tendrá el formato `https://TUUSUARIO.github.io/Casa-en-orden-v31-prueba/`. Abre esa dirección en Safari. Cuando termine la publicación, puedes elegir **Compartir → Agregar a pantalla de inicio → Abrir como app web**.
6. **No borres** la aplicación 1.0, 2.0 o 3.0 hasta terminar las pruebas y respaldar tus datos.

### Datos y respaldos

- Este ensayo utiliza una clave de almacenamiento diferente (`casa-en-orden-v3-1`) y una base local de comprobantes diferente, para no sobrescribir los registros ni borrar anexos de la app 3.0.
- En el primer arranque **intenta copiar** datos de la versión 3.0 si están almacenados bajo el mismo origen web de GitHub Pages. Después cada versión mantiene sus cambios locales independientes. El traspaso de comprobantes es una copia local que puede requerir esperar un momento. Comprueba que estén presentes.
- **Haz un respaldo completo** en la versión vieja ANTES de empezar. Copias automáticas locales no sustituyen respaldos en Archivos/iCloud; podrían perderse al limpiar datos del navegador, y no guardan por separado las fotos/PDF.
- Las cuentas y métodos de pago son registros manuales: no hay conexión bancaria real.
- Los ejemplos vienen con movimientos ficticios que pueden borrarse tras probar la app.

### Informes PDF

En **Más → Finanzas → Vista previa y PDF** ajusta el mes, período, componentes y estilo. Selecciona:
- **Descargar PDF con anexos**: requiere acceso a internet para cargar `pdf-lib` desde jsDelivr. Intenta insertar las páginas de los comprobantes PDF y las fotos compatibles, y avisa si no pudo incluir alguno. Confirma siempre el resultado descargado.
- **Imprimir / PDF Safari**: sirve para imprimir en A4, elegir Guardar en Archivos, o imprimir con AirPrint. Las imágenes se incluyen cuando es posible, pero los PDF adjuntos no se agregan como páginas desde esta opción.

Los informes de menú, calendario y mercado se generan mediante Safari y pueden guardarse como PDF. Para archivos PDF confidenciales evita imprimirlos en una impresora compartida sin supervisión.

### Familia y sincronización

La versión de prueba funciona localmente desde el primer momento. Para que **dos personas vean y editen los mismos datos** se necesita configurar un proyecto privado en Supabase: lee `CONFIGURAR_NUBE.md` y ejecuta `supabase_setup.sql`. La conexión **no se activa por sí sola** en esta nueva versión, aun si configuraste la nube en la versión 3.0. Las invitaciones y permisos dependen de la autenticación y de las políticas RLS; deben validarse con dos cuentas antes de confiar en ellos.

### Limitaciones por verificar en tu iPhone

- No se han validado las alertas push con la PWA cerrada: la alternativa preparada es exportar a Calendario y activar las alertas allí.
- No se ha verificado la sincronización efectiva en dos iPhone ni la exportación de PDF con soportes reales de distintos formatos; realiza esas pruebas antes de guardar documentación importante.
- Los menús del bebé son solo sugerencias para un bebé de 8 meses. Confirma alimentos introducidos y alergias; no ofrecer miel antes de los 12 meses y evita texturas de riesgo de atragantamiento.
- Los gráficos, comparaciones y saldos se basan en movimientos que las personas registran manualmente, no en movimientos bancarios comprobados.



## Novedad de la versión 3.2 — mini-comprobantes junto a movimientos

Desde **Más → Finanzas → Vista previa y PDF**, el informe incluye de forma predeterminada una ficha compacta por movimiento. A la derecha aparece **la miniatura de su fotografía** o, en el PDF descargado, **la primera página del comprobante PDF original** cuando ese archivo puede incorporarse. Si falta un soporte verás **Sin soporte** junto al movimiento.

Opciones del informe:

- **Incluir comprobantes** activada (predeterminado).
- **Miniatura junto a cada movimiento** activada (predeterminado).
- **Anexos completos al final** desactivada (predeterminado); puedes activarla para adjuntar las páginas originales a tamaño completo.
- **Morado y colorido** o **Económico para imprimir**.

**Importante:** la vista previa y la impresión directa desde Safari muestran fotografías pequeñas; los PDFs subidos se identifican con un icono. Para colocar la primera página real del PDF como miniatura usa el botón **Descargar PDF con miniaturas**. Esta opción necesita cargar el generador PDF con internet. Los archivos siguen siendo privados en el almacenamiento local o en la nube privada si la configuras, **no** se suben a GitHub. La integración depende del formato: si un comprobante está dañado o protegido, se mostrará una advertencia. Comprueba el documento exportado antes de utilizarlo para fines formales.

**Conservación de datos:** se mantiene la misma clave de almacenamiento local que en 3.1 para permitir una actualización sobre el mismo sitio sin perder los movimientos. Antes de subir nuevos archivos al repositorio, exporta un respaldo completo desde la aplicación actual. Si usas otro repositorio, los datos locales no se transfieren automáticamente entre dominios/rutas distintos; importa un respaldo cuando proceda. No elimines comprobantes originales hasta verificar la copia.


## Novedad de la versión 3.3 — Foto del recibo y autocompletado asistido

En **Más → Finanzas → Nuevo movimiento** (ingreso, egreso o inversión):

1. Elige el tipo de movimiento y, en el formulario, selecciona **Adjuntar foto o PDF**. Puedes tomar o elegir una foto del recibo, según las opciones disponibles en Safari.
2. Con una imagen compatible de hasta 4 MB, la app intenta reconocer localmente **valor, fecha, comercio, método de pago y categoría**, y rellenar esos campos. El tipo de movimiento, la cuenta y el responsable se mantienen bajo tu control.
3. **Revisa y corrige** el contenido: un recibo borroso, datos de factura, precios de artículos o varios importes pueden confundir el reconocimiento. **Nada se guarda hasta que pulses Guardar.**
4. La imagen queda adjunta al movimiento y conserva su miniatura en el informe PDF. Los PDF se pueden adjuntar, pero en esta versión **no se autocompletan a partir de PDF**.

**Dependencia:** el lector requiere conexión la primera vez (descarga Tesseract.js y modelos de español desde un proveedor externo). El reconocimiento, una vez cargado, se ejecuta en el navegador y no envía deliberadamente la foto a un servicio de OCR. Puede volver a requerir conexión para cargar el motor. Si falla, se puede registrar manualmente con el archivo adjunto.

**Despliegue seguro:** antes de reemplazar los archivos del repositorio publicado, descarga el **respaldo completo con soportes**. Para probar sin afectar la aplicación habitual, usa otro repositorio y configura GitHub Pages; al usar un origen diferente los datos no aparecerán allí hasta restaurar el respaldo. **No subas recibos, respaldos ni información privada a un repositorio público.**

**Estado de pruebas:** se realizaron pruebas automatizadas del formulario y del analizador de texto; la precisión real del reconocimiento de fotografías, el guardado local de archivos en iOS y el PDF resultante deben verificarse en tu iPhone.

### Administrar un comprobante desde el movimiento

En **Más → Finanzas → Movimientos**, pulsa **Administrar comprobante** para ver la foto ampliada o abrir el PDF y para **reemplazar** o **quitar** únicamente el soporte. Si un registro no tiene archivo, el botón **Adjuntar comprobante** permite añadir uno. Quitar el comprobante conserva la fecha, el importe y los demás datos del movimiento. Cuando existe una copia descargada o sincronizada, no se borra automáticamente.

## Versión 3.4 · Trabajo sin internet (modo local)

**Qué sí funciona sin internet tras la primera preparación en Safari con conexión:** abrir la aplicación, consultar y modificar mercado, despensa, menús y recetas, agenda, pagos, finanzas e inversiones; agregar fotos o archivos PDF a movimientos; consultar soportes ya guardados localmente; exportar un respaldo y generar documentos con **Imprimir / PDF Safari**. Todo se guarda en el **iPhone**, sin publicarse en el repositorio.

**Qué debes preparar:** abre una vez Casa en Orden 3.4 en GitHub Pages con internet; en Inicio pulsa **Preparar modo sin internet → Preparar modo sin internet**. Espera la confirmación. Después prueba **modo avión**, cierra la PWA y ábrela de nuevo desde su icono. No borres los datos de Safari y exporta periódicamente un respaldo completo.

**Limitaciones importantes:** para hacer sincronización familiar/nube y enviar datos al servidor necesitarás conexión. El lector OCR de facturas necesita descargar el motor y los datos del idioma; aunque se pueden preparar desde el botón **Preparar lector de recibos**, Safari puede limpiar sus archivos y **no se garantiza su funcionamiento sin internet**. Si no se puede leer, la foto sigue adjunta y puedes completar a mano los campos antes de Guardar. Para generar PDFs avanzados con la primera página de PDF incrustada, el generador externo necesita haber sido descargado y conservado en caché. La app abre la **vista imprimible de Safari** como alternativa sin conexión: muestra las fotos en miniatura, pero no incrusta la primera página de los PDFs adjuntos. Los calendarios o menús en la app son locales: las alertas externas de iPhone deben configurarse en Calendario.

**Seguridad de los datos:** las copias locales no son respaldo remoto. Evita borrar Safari, limpiar datos de sitios o desinstalar antes de exportar el respaldo completo con soportes. Abrir otro repo/URL puede cambiar el origen web y hacer que no encuentres los datos locales anteriores. No subas fotografías privadas, respaldos ni recibos a GitHub.

**Actualización:** reemplaza en la raíz de GitHub Pages los archivos del paquete 3.4 (no subas el ZIP). Mantén tu mismo repositorio y dominio para conservar el almacenamiento local; primero exporta respaldo completo. Este paquete es una versión de prueba y no modifica tu repositorio por sí solo.

## NOVEDAD 3.5: Selector de DOS CASAS con administradores independientes

Lee primero **`GUIA_DOS_CASAS_IPHONE.md`**. Se añadió el botón **🏠 Cambiar casa** en el encabezado de todas las pantallas y la posibilidad de crear/seleccionar Casas independientes. Cada casa tiene copia local distinta por cuenta autenticada y hogar, permisos independientes (propietario, administrador, editor y lector) y actualización opcional con Supabase. Las nuevas casas comienzan vacías para no mezclar información.

**Si ya ejecutaste el esquema 3.4 en Supabase, ejecuta SOLO `supabase_dos_casas_actualizacion.sql`. Si no instalaste las tablas `households` y `memberships`, ejecuta el `supabase_setup.sql` de este paquete completo.** No ejecutes a ciegas un SQL sobre un proyecto con tablas ajenas. Guarda respaldo antes. No se han probado los permisos con dos cuentas reales en tu proyecto.


## Novedad 3.7: carpeta Privado protegida

Código numérico exclusivo por casa y usuario en este iPhone, con cifrado AES-GCM y PBKDF2. Ver `GUIA_CODIGO_PRIVADO_3_7.md`. **Face ID no está habilitado.** La membresía por casa depende de la sincronización y las políticas RLS de Supabase.
