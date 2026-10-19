# Casa en Orden 3.8.4 – Correo de la cuenta activa

Actualización basada en Casa en Orden 3.8.3.

## Cambios

- **Inicio:** muestra claramente «Sesión iniciada como», con el correo de la cuenta realmente activa en Supabase, la casa actual y su rol. Si no hay sesión, indica modo local.
- **Familia y ajustes:** muestra el mismo correo y rol, separados del correo del administrador del hogar.
- **Acceso familiar privado → Mi cuenta personal:** muestra el correo de la cuenta actual y la casa/rol. Conserva «Cerrar sesión».
- **Cambiar casa:** indica qué cuenta está seleccionando el hogar.
- **Administradores:** conserva la visualización independiente de propietarios y administradores de cada casa de la versión 3.8.3.

Esta versión **no requiere ejecutar SQL nuevo** ni cambia autenticación, contraseñas, movimientos, despensa, recetas, documentos, roles o permisos. Las casas Bogotá y Cartagena se mantienen separadas.

## Instalación desde iPhone

1. En Casa en Orden exporta un respaldo completo, incluidos soportes, antes de actualizar.
2. Descomprime el ZIP de esta versión y reemplaza los archivos del repositorio de GitHub Pages de Casa en Orden. Mantén la misma ruta de publicación; no subas documentos privados ni contraseñas al repositorio.
3. Abre la aplicación con internet en Safari y comprueba la etiqueta «Versión 3.8.4». Si queda una versión anterior, actualiza Safari y vuelve a abrir la app.
4. Inicia sesión con la cuenta habitual y comprueba que el correo visible coincida con la cuenta que ingresó. Luego cambia de casa y comprueba que el correo de sesión permanece y cambia la casa/rol.
5. No borres el almacenamiento de Safari ni la aplicación de la pantalla de inicio mientras haces la prueba.

## Seguridad y verificación

- El correo mostrado proviene de `cloudConf.session.user.email` de Supabase Auth; nunca de la lista de administradores.
- Para evitar que el HTML inserte contenido no confiable, el correo se escapa antes de mostrarse.
- Esta actualización no comprueba por sí sola la revocación de permisos en el servidor ni el acceso en dos dispositivos. Prueba por separado los permisos de cada casa antes de guardar información familiar sensible.
- La prueba de navegador utilizó correos **ficticios**, sin conectarse a Supabase real. Sigue pendiente comprobarlo en Safari y con cuentas reales.
