# Configurar nube y dos integrantes en Casa en Orden 3.1

El proyecto web puede instalarse desde Safari sin Mac. Para **compartir los datos**, debes activar un backend privado. El método disponible en la versión 3.0 usa **Supabase Auth + Postgres con RLS + Storage privado**. Los pasos se pueden realizar desde un iPhone, aunque el editor SQL puede resultar incómodo; utiliza la opción «Solicitar sitio de escritorio» si hace falta.

1. Crea un proyecto nuevo en https://supabase.com/dashboard con tu cuenta. Configura una contraseña segura para la base. No introduzcas esta contraseña en la aplicación Casa en Orden.
2. Abre **SQL Editor** del proyecto y ejecuta el contenido completo de `supabase_setup.sql`. Este archivo crea hogares, membresías, invitaciones, funciones con verificación de permisos y un bucket privado para comprobantes. Confirma que no haya errores. **No ejecutes el script en una base de datos existente con otras aplicaciones**, porque podría entrar en conflicto con otras políticas.
3. En **Authentication → Providers → Email**, activa el registro por email. Se recomienda confirmar correos antes de permitir el uso. Supabase podría requerir configurar su proveedor de correo para que las invitaciones y confirmaciones se reciban sin límites; recuerda que las invitaciones de esta app son registros pendientes, no emails automáticos.
4. En **Project Settings → API**, copia la **Project URL** y la clave **anon / publishable**. Esas dos son las únicas que se escriben en Casa en Orden. Nunca uses ni compartas `service_role` o la clave secreta.
5. Abre **Casa en Orden 3.1 → Más → Familia → Configurar nube y acceso**. Guarda la URL y la clave pública. Inicia sesión o crea cuenta y confirma el correo si es necesario.
6. En tu primer iPhone crea el hogar. Al crear el hogar los datos locales actuales se copian una vez a la nube privada y se empieza a sincronizar.
7. Para compartir, introduce el correo de la persona en «Invitar integrante». **No se manda un email automáticamente**: informa a esa persona por un canal privado y pídele que se registre con ese correo, lo confirme, y pulse **Aceptar invitación** en su iPhone. La invitación expira a los 30 días.
8. En el segundo iPhone, después de aceptar, selecciona **Traer datos de la nube** (primero exporta respaldo si tiene datos locales que quiera conservar). Ambos integrantes podrán ver los mismos registros y comprobantes.
9. Opcional: la persona propietaria puede escribir el correo de un integrante ya vinculado en «Cambiar permiso» y elegir **Puede editar** o **Solo visualizar**. La base impide que un lector escriba, incluso si intenta acceder directamente al servidor.

**Importante:** una sincronización no equivale a un backup. Usa «Exportar respaldo» también. Si dos iPhone editan al mismo tiempo sobre revisiones antiguas, el servidor detecta conflicto y no sobrescribe en silencio: guarda respaldo antes de elegir manualmente cargar o sobrescribir desde uno de ellos. La app no resuelve automáticamente fusiones complejas.

**Privacidad:** los archivos se guardan en un bucket Supabase privado con políticas por hogar. El código del repositorio GitHub público no debe contener documentos, archivos JSON de backup, passwords, claves secretas ni tokens.
