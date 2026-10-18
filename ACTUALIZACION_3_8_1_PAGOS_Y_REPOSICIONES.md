# Casa en Orden 3.8.1 — Corrección de reposición y pago del mercado

## Qué se corrigió

- Al marcar un artículo **Comprado**, se añade a **En casa** y aparece una decisión explícita: **Pagar este producto**, **Pagar todos los pendientes** o **Seguir comprando**.
- **Comprado NO significa Pagado:** únicamente el botón **Guardar pago en Finanzas**, después de revisar el valor, método, cuenta y responsable, genera un egreso. La aplicación nunca envía dinero ni carga una tarjeta.
- Puedes registrar el pago de un producto o de varios productos juntos; el formulario contiene la lista exacta de productos que se están pagando. Si esa lista cambió mientras el formulario estaba abierto, se detiene para evitar duplicados.
- Los productos pagados se identifican como **Pagado en Finanzas** y se bloquea su casilla de compra. Corregir un pago existente se hace desde el movimiento financiero correspondiente.
- **Se acabó → Reponer** crea un nuevo ciclo de compra con ID nuevo cuando la compra anterior ya estaba pagada, conservando nombre, categoría, cantidad, unidad y último precio disponible. No reutiliza el pago anterior ni la fecha de vencimiento.
- Después de **Guardar pago**, se abre **Finanzas → Mercado → Todo el historial**, para que puedas confirmar el registro.
- Se mantiene la separación entre las casas, los permisos, documentos y las recetas de versiones anteriores.

## Instalar en GitHub desde el iPhone

1. En Casa en Orden, ve a **Más → Copia de seguridad → Exportar respaldo**. Guarda el JSON y los soportes en Archivos o iCloud.
2. Descarga el ZIP de Casa en Orden 3.8.1, descomprímelo y sube **los archivos que contiene** a la raíz de tu repositorio actual, reemplazando los nombres repetidos. No subas el ZIP como único archivo.
3. Abre tu sitio de GitHub Pages en Safari con conexión. Si tarda en actualizarse, vuelve a abrir la página o cierra y abre Safari. Debe decir **Versión 3.8.1**.
4. Usa una compra de prueba: marca **Comprado**, toca **Pagar este producto**, verifica el importe y método, pulsa **Guardar pago en Finanzas** y comprueba que aparezca en los movimientos más recientes.
5. Pasa ese producto de la despensa a **Se acabó**, elige **Reponer**, vuelve a marcar **Comprado** y registra otro pago: deben verse dos movimientos diferentes.

## Precauciones

- No borres los datos de Safari ni restaures sobre otra casa sin un respaldo verificado.
- La sincronización entre dispositivos sigue necesitando internet y debe comprobarse en ambos teléfonos antes de manejar movimientos reales compartidos.
- Las compras marcadas en versiones anteriores que sigan pendientes de pago **no se contabilizan automáticamente**: abre **Mercado → Registrar pago de los pendientes** para revisarlas. Si ya ingresaste manualmente ese gasto en Finanzas, evita registrarlo por segunda vez.
- No se requiere ejecutar SQL nuevo en Supabase.

## Estado de verificación

- Sintaxis de JavaScript revisada.
- Prueba en Chromium de formulario de pago, compra de varios productos, registro y navegación a Finanzas.
- Prueba de reposición de un producto que ya tenía un pago: se generan pagos con identificadores diferentes.
- Falta validación final del comportamiento en Safari/iOS y con sincronización real de Supabase.
