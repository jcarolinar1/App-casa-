# Casa en Orden 3.6 · Documentos

Lee **GUIA_DOCUMENTOS_3_6.md** antes de la actualización. Conserva todo el resto de las funciones de 3.5. El nuevo SQL para Office/PDF es `supabase_documentos_actualizacion.sql`; ejecútalo sólo cuando la base de Casa en Orden ya esté instalada.

# Casa en Orden 3.5 · Configurar dos casas en Supabase

Las instrucciones actualizadas están en **GUIA_DOS_CASAS_IPHONE.md**. Es importante seguirlas, porque las versiones 3.1 a 3.4 usaban un permiso sin la categoría **Administrador**, mientras que 3.5 necesita permisos independientes por casa.

- Si **ya ejecutaste** `supabase_setup.sql` de 3.4, ejecuta **solo** `supabase_dos_casas_actualizacion.sql`.
- Si **no instalaste** las tablas `public.households`, `public.memberships` y `public.invitations`, ejecuta **solo** el `supabase_setup.sql` de este ZIP.
- No ejecutes dos veces el archivo de instalación completo. No pegues contraseñas ni claves `sb_secret_` en la app o en GitHub.
- Conserva `sb_publishable_` y la URL de proyecto **solo** en el formulario de la app.
- Configura primero con registros de prueba, valida dos cuentas con distintos permisos y después importa respaldos reales con cuidado.
- Cualquier integrante puede estar en dos casas con permisos distintos, y los recibos locales se almacenan separados por cuenta y casa.
- Las invitaciones se crean en la app, pero **no envían por sí mismas un email automático**; avisa al familiar para que se registre con correo verificado y acepte su invitación.

Consulta la guía completa antes de activar la sincronización en teléfonos diferentes.
