# Casa en Orden 3.5 · Dos casas en una sola aplicación 💜

**Versión de prueba.** La app 3.5 no modifica GitHub ni Supabase por sí sola. Conserva el diseño morado, finanzas, comprobantes, mercado, despensa, agenda y modo sin conexión. Antes de desplegarla, crea un **respaldo completo con fotografías y PDFs**, preferiblemente también una copia en Archivos/iCloud del iPhone. No borres la versión 3.4.

## Las dos casas

- En cualquier pantalla pulsa **🏠 Cambiar casa**. Elige Casa principal o Casa familiar (los nombres los defines tú). Puedes crear otras casas si tienes permiso; no hay un límite obligatorio de dos.
- **Cada casa tiene sus propias finanzas, ingresos, egresos, inversiones, compras, despensa, citas, tareas, presupuestos, recibos y PDF.** Las cuentas de dinero también son independientes por casa.
- **Propietario:** quien crea una casa. Conserva la facultad de nombrar o quitar administradores de esa casa.
- **Administrador:** puede registrar cambios y enviar invitaciones en la casa que administra; puede gestionar permisos de editores y lectores, pero no cambiar al propietario ni a otros administradores.
- **Editor:** puede registrar movimientos y tareas de su casa.
- **Solo consulta:** puede ver su casa pero no cambiar sus datos. Nota: la protección fuerte depende de Supabase online; trabajar desconectado no permite verificar un cambio de permisos reciente.
- Una misma persona puede ser **administrador de Casa principal y lector de Casa familiar**. Otra persona puede administrar Casa familiar sin administrar la primera.
- Para que más de un teléfono comparta la información, hay que configurar Supabase y comprobar RLS. Los datos locales de un nuevo teléfono no aparecen automáticamente solo por abrir GitHub Pages.

## Instalación paso a paso desde iPhone

1. **Respalda Casa 3.4** antes de actualizar y guarda una copia del ZIP anterior.
2. Prepara la estructura de Supabase en **SQL Editor**:
   - Si **ya ejecutaste** el `supabase_setup.sql` de la versión 3.4, ejecuta **solo** el archivo `supabase_dos_casas_actualizacion.sql` de esta versión 3.5. Este script es una actualización, no borra casas ni movimientos.
   - Si **nunca ejecutaste** `supabase_setup.sql`, ejecuta **solo** el `supabase_setup.sql` incluido aquí (incluye la actualización final de roles). No ejecutes los dos códigos repetidos.
   - Si no sabes cuál se ejecutó, verifica primero en **Table Editor** que existan `households`, `memberships` e `invitations`; las tablas `hogares` / `integrantes_hogar` del código inicial NO sustituyen a estas.
3. Sube los archivos descomprimidos del ZIP **directamente a la raíz** de tu repositorio de pruebas (misma ruta para conservar su almacenamiento local). No subas fotos ni respaldos de movimientos a GitHub.
4. Abre la app en Safari, ve a **Más → Familia y ajustes → Configurar nube y acceso**, e introduce la **Project URL** y tu clave pública `sb_publishable_...`. **Nunca** pongas una clave `sb_secret_` o `service_role` en la aplicación ni en GitHub.
5. Inicia sesión con tu correo confirmado. Crea una casa con el nombre que prefieras. La casa nueva comienza vacía **para evitar mezclar historiales**. Si quieres pasar los datos anteriores, exporta respaldo desde 3.4 y haz una importación controlada en la casa que corresponda, después de verificar el contenido.
6. Pulsa **🏠 Cambiar casa → Crear otra casa** y crea la segunda.
7. En **Familia y ajustes**, selecciona la casa y pulsa **Configurar nube y acceso**. Introduce el correo del integrante, invítalo y pídele que inicie sesión con ese mismo correo verificado en su móvil y pulse **Aceptar invitación**. La app no manda un correo de invitación por sí sola.
8. Una vez que el familiar aparezca como integrante de esa casa, escribe su correo en **Cambiar permiso**, elige **Administrador de esta casa** y pulsa **Asignar permiso**. Repite en la otra casa si quieres permisos distintos.
9. En el segundo teléfono, inicia sesión, selecciona la casa y elige **Traer datos nube**. Haz copia de cualquier dato local que ya tenga ese teléfono antes de descargar.
10. Verifica con **dos cuentas reales** que Casa 1 no muestra movimientos de Casa 2 y que un usuario lector no puede modificarla. La sincronización entre teléfonos requiere internet.

## Sin conexión

Después de abrir la app con conexión y pulsar **Preparar modo sin internet**, podrás alternar entre casas **que ya hayan sido descargadas en ese iPhone**. Si hay cambios locales pendientes de sincronizar, el selector no te dejará pasar a otra casa hasta resolverlos, para evitar confundir datos. Esto es deliberado. No se pueden aceptar invitaciones, crear casas ni comprobar nuevos permisos sin conexión.

## Límites y precauciones

- **Actualización no verificada con dos teléfonos reales.** Se realizan pruebas de código y navegación local; RLS y permisos requieren probarse con dos cuentas de tu propio proyecto Supabase.
- Si un familiar cambia un dato simultáneamente desde otro teléfono, puede aparecer un **conflicto de sincronización**. Exporta respaldo y revisa ambos antes de decidir qué conservar; no se fusionan automáticamente.
- Los datos y recibos se guardan en el iPhone y opcionalmente en Supabase. Si Safari limpia su almacenamiento, podrías perder datos locales no sincronizados. Haz respaldos periódicos.
- Recomendación: configura las dos casas **primero con datos de prueba**. Después migra de forma controlada los registros reales que correspondan a cada una.
