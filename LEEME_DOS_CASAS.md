# Casa en Orden 3.5 · Dos casas y administradores independientes

## ¿Cómo funciona?

La misma app permite administrar varias casas, por ejemplo **Casa 1** y **Casa 2**, con un botón **🏠 Cambiar casa** en la parte superior. Cada casa conserva por separado ingresos, egresos, inversiones, cuentas, mercado, despensa, pagos, calendario, menú, historial y referencias a comprobantes. La copia local queda identificada por usuario y casa. La app no duplica automáticamente los movimientos de una casa en otra.

Los permisos se asignan **por casa**. Ejemplo: Ana puede ser propietaria/administradora de Casa 1 y editora de Casa 2; Luis puede ser administrador de Casa 2 y lector de Casa 1. Cada casa se crea con una persona propietaria inicial (`owner`). **Solo esa persona propietaria puede designar o retirar administradores (`admin`)**. Los administradores pueden editar e invitar participantes de su propia casa. Editores registran cambios; lectores solo consultan. Ni administradores ni propietarios de una casa reciben acceso automático a otra.

## Antes de actualizar

1. **Exporta un respaldo completo con recibos desde la app actual**, y guárdalo en Archivos/iCloud. No publiques el respaldo en GitHub.
2. Descomprime el ZIP y comprueba que los archivos están en la raíz del repositorio de prueba, no dentro de una carpeta adicional.
3. **No borres** tus archivos/datos anteriores de Safari ni elimines la app instalada hasta comprobar que la prueba funcione.

## Configurar Supabase (un solo proyecto para ambas casas)

Tienes dos situaciones posibles, elige **solo una**:

- Si **ya ejecutaste** `supabase_setup.sql` de Casa en Orden 3.4 con resultado satisfactorio y en Supabase existe la tabla `public.households`, ejecuta **solo** `ACTUALIZAR_SUPABASE_3_5.sql` desde SQL Editor → New query → Run. Es una migración que amplía roles y añade consulta de integrantes, sin borrar registros.
- Si **todavía NO ejecutaste** el archivo `supabase_setup.sql` (solo ejecutaste el SQL español anterior con `hogares` / `integrantes_hogar`), ejecuta **solo** el `supabase_setup.sql` que viene con 3.5. Crea las tablas `households`, `memberships`, `invitations` y el bucket privado. No necesitas ejecutar después la migración.

**No ejecutes ambos scripts seguidos** y no pegues ninguna contraseña, `service_role` o clave `sb_secret_` en GitHub. Usa únicamente la URL del proyecto y la clave pública `sb_publishable_` en la configuración privada de la app.

## Uso desde el iPhone

1. Abre la app 3.5 → **Más → Familia y ajustes → Configurar nube y acceso**. Guarda la URL y la clave pública de Supabase en tu propio dispositivo. Crea una cuenta/inicia sesión con correo confirmado.
2. **Crear casa:** escribe «Casa 1» y toca **＋ Crear casa**. Se crea vacía y su creadora queda propietaria. Repite el proceso escribiendo «Casa 2». Si ya tenías una casa en la nube, no la vuelvas a crear: usa **Ver mis casas** para elegirla.
3. Abre **🏠 Cambiar casa** en cualquier pantalla: toca **Entrar** en Casa 1 o Casa 2. Si no se ha descargado en ese iPhone, entra con conexión y pulsa **⬇ Traer datos nube**. No se importa el contenido de otra casa.
4. **Elegir administrador:** selecciona primero la casa deseada → **Gestionar permisos** → **Invitar integrante** con su correo. La otra persona crea/verifica su cuenta y pulsa **Aceptar invitación**. Como propietaria, escribe su correo en «Cambiar permiso de integrante existente» y elige **Administrador de esta casa** → **Asignar permiso**. Repite en la otra casa si quieres otro administrador.
5. **Comprobar:** registra un movimiento de prueba en Casa 1, cambia a Casa 2 y verifica que no aparezca allí. Vuelve a Casa 1 para confirmar que se conserva. Prueba una cuenta de editor y de lector.

## Sin internet

Si una casa **ya se descargó** en ese iPhone, puedes abrir su copia local sin internet y cambiar entre casas descargadas. Para iniciar una sesión nueva, crear una casa, aceptar invitaciones, invitar administradores y sincronizar, necesitas conexión. Si hay cambios pendientes, el cambio de casa queda bloqueado hasta sincronizarlos para no mezclar registros. Usa siempre respaldos completos como protección.

## Lo que NO se ha probado todavía

El código JavaScript pasa verificación sintáctica y una prueba de cambio entre dos casas con almacenamiento local simulado. No se hizo una prueba de inicio de sesión real ni de políticas SQL sobre tu proyecto Supabase; tampoco una prueba de extremo a extremo en Safari del iPhone. No afirmamos que haya quedado publicado o sincronizado hasta que lo compruebes. El cambio del repositorio lo haces tú; este archivo no altera tu cuenta ni tu app existente.
