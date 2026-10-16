# Casa en Orden 3.2 💜 · Diez mejoras y mini-comprobantes (versión de prueba)

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
2. Para probarla sin alterar tu app actual, crea en GitHub **otro repositorio**, por ejemplo `Casa-en-orden-v32-prueba` (GitHub Pages gratuito requiere repositorio público en la configuración habitual). Si decides actualizar tu repositorio 3.1, primero exporta un respaldo completo y comprueba que puedas abrirlo; los archivos de código se reemplazan, pero no debes eliminar los datos locales.
3. Sube **todos los archivos de esta carpeta directamente a la raíz del repositorio** (no el ZIP y no una carpeta contenedora).
4. En el repositorio abre **Settings → Pages → Deploy from a branch → main → /(root) → Save**.
5. La dirección tendrá el formato `https://TUUSUARIO.github.io/Casa-en-orden-v32-prueba/`. Abre esa dirección en Safari. Cuando termine la publicación, puedes elegir **Compartir → Agregar a pantalla de inicio → Abrir como app web**.
6. **No borres** la aplicación 1.0, 2.0 o 3.0 hasta terminar las pruebas y respaldar tus datos.

### Datos y respaldos

- Este ensayo utiliza una clave de almacenamiento diferente (`casa-en-orden-v3-1`) y una base local de comprobantes diferente, para no sobrescribir los registros ni borrar anexos de la app 3.0.
- En el primer arranque **intenta copiar** datos de la versión 3.0 si están almacenados en la misma procedencia web y no existe ya un estado de 3.1. Después la copia puede evolucionar por separado. Los comprobantes pueden necesitar una migración local: comprueba que estén presentes. En un repositorio nuevo debes **importar el respaldo**, porque cambiar la ruta de GitHub Pages puede afectar el alcance del almacenamiento de la PWA.
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
