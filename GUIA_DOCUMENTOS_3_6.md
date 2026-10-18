# Casa en Orden 3.6 · Documentos (iPhone)

## ¿Qué incluye?

Desde **Más → Documentos** encontrarás carpetas tipo **Familia**, **Casa**, **Vacaciones** y **Privado**; también puedes crear carpetas compartidas nuevas. Toca **Agregar archivo** para importar fotos, PDF, Word, Excel, texto o CSV (hasta **5 MB por archivo**), escribe el nombre y escoge la carpeta. Las fotos también pueden tomarse con la cámara del iPhone desde **Agregar foto**. Se puede buscar, abrir, descargar, cambiar el nombre/carpeta o quitar un documento. No es un sistema de OCR ni completa automáticamente estos documentos.

- **Compartidos por casa**: fotos y archivos con sus metadatos ligados solo a la casa actualmente seleccionada. En una casa conectada con Supabase, miembros con rol propietario, administrador o editor pueden añadir/cambiar documentos. El lector solamente consulta. Al activarse la sincronización, la app intenta subir los archivos al bucket **privado** `casa-supports`, y las personas de esa misma casa pueden abrirlos desde su sesión. Para que Word, Excel y texto se permitan en Storage, ejecuta el SQL `supabase_documentos_actualizacion.sql` DESPUÉS de configurar el esquema de Casa en Orden. **No** permite verlos a miembros de otra casa, según las políticas RLS de Supabase.
- **Privado**: metadatos almacenados en `localStorage` con clave distinta por cuenta y casa, y archivo guardado localmente en IndexedDB. **No se sincronizan con Supabase ni se comparten con integrantes**. No equivale a almacenamiento cifrado; otras personas con acceso al mismo iPhone o a los datos internos de Safari pueden acceder. En modo local sin cuenta, Privado es *privado de ese dispositivo*, no de un usuario autenticado.
- **Sin internet**: documentos YA guardados en el iPhone se pueden abrir sin conexión. Para descargarlos en otro teléfono, sincronizar o invitar personas se necesita conexión. La PWA no garantiza retención de IndexedDB si se borran datos del sitio, Safari libera almacenamiento o se reinstala desde un origen diferente.
- **Respaldos**: «Familia y ajustes → Exportar respaldo» incorpora fotos/documentos de la casa y tu carpeta Privado. **El respaldo JSON contiene tus archivos sin cifrar.** Guárdalo en Archivos/iCloud de forma segura y no lo envíes por chat o a GitHub. Para respaldos muy grandes (>28 MB), el importador actual no está preparado; exporta archivos originales aparte.

## Actualizar en GitHub Pages

1. Haz primero un **respaldo completo** de la versión que tienes, incluidos los comprobantes.
2. Si no has creado aún las tablas de Supabase, primero configura `supabase_setup.sql` y la actualización de dos casas según la guía 3.5. **No vuelvas a ejecutar todo el esquema** si ya existe.
3. En el SQL Editor de tu proyecto, ejecuta `supabase_documentos_actualizacion.sql` para ampliar formatos admitidos por `casa-supports`, manteniendo el bucket privado.
4. Sube **los archivos de aplicación descomprimidos** a la raíz del mismo repositorio de prueba (por ejemplo `index.html`, `app.js`, `styles.css`, `sw.js`, etc.). No subas documentos personales ni copias de respaldo a GitHub.
5. Abre desde Safari con conexión para que actualice su caché; entra en **Más → Documentos**. Guarda una foto de prueba en Casa principal y otra en Casa familiar. Cambia de casa y comprueba que no se mezclen. Prueba Privado y exporta el respaldo.
6. Comprueba los documentos desde un segundo teléfono **antes** de considerarlo una copia compartida confiable; ni la sincronización de archivos Office ni el comportamiento sin red en iPhone han sido validados en dispositivos reales aquí.

## Avisos

- Evita poner documentos financieros, médicos, identificaciones o datos sensibles en GitHub. Usa solamente el almacenamiento de la aplicación.
- La eliminación de un documento de la lista no garantiza borrar copias previamente descargadas, respaldadas o subidas a Supabase Storage; se necesita gestión de esas copias. No la uses como sistema de custodia de documentación importante sin respaldos originales.
- La categoría Privado **no está cifrada** y no se replica a otros dispositivos. El nombre `Privado` significa que no se comparte automáticamente con los integrantes del hogar, no que esté protegida ante quien maneje físicamente el dispositivo.
