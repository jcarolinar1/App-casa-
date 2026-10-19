# Casa en Orden 3.9

Aplicación web instalable para iPhone, con dos casas independientes, finanzas, préstamos, mercado, recetas, agenda y documentos.

## Novedades

- Historial de agotados agrupado por producto, sin nombres duplicados.
- Nombres visibles por casa para administradores, editores y lectores (requiere SQL `supabase_nombres_integrantes_3_9.sql`).
- Inicio sin banners de prueba ni textos antiguos, manteniendo el estado de conexión.
- Informes en Configuración.
- Colores Morado, Azul, Verde, Rosa y Noche en este dispositivo.
- Presupuesto de mercado con duración configurable (incluye mes calendario y sin cierre).
- Copia local con adjuntos aproximadamente cada siete días, cuando la aplicación está abierta. Hasta tres versiones, separadas por hogar.
- Agenda exportable en formato `.ics` para importar al Calendario del teléfono; la sincronización automática no está implementada para iOS web.

## Archivos

- `index.html`, `app.js`, `styles.css`, `sw.js`, `manifest.webmanifest`: aplicación.
- `supabase_nombres_integrantes_3_9_iPhone.txt`: ejecutar en Supabase una sola vez para habilitar nombres compartidos por casa.
- `GUIA_ACTUALIZACION_3_9_IPHONE.md`: pasos de actualización y pruebas.

La versión no ha sido instalada en el GitHub del usuario. Requiere pruebas reales de Safari, Supabase y copias locales en el iPhone.


## 3.9.1 — Nombre visible de la sesión
En Inicio, Configuración y Cambiar casa se muestra el nombre asignado para la casa actual, no el correo. En Mi cuenta se conserva el correo para verificar la identidad. Para registrar el nombre, instala `supabase_nombres_integrantes_3_9.sql` si aún no lo ejecutaste y entra a Configuración > Acceso familiar privado > Ver / desvincular integrantes > Nombre para mostrar > Guardar nombre.
