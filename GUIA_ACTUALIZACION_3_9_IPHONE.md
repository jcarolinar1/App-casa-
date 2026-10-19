# Casa en Orden 3.9 — Instalación desde iPhone

## Antes de reemplazar archivos

1. Abre cada casa (Cartagena y Bogotá) en la aplicación actual y exporta un **respaldo completo**, incluidos documentos y comprobantes. Guárdalos en **Archivos → iCloud Drive** o en otro lugar fuera de Safari.
2. No borres los datos de Safari, no desinstales la aplicación y no cambies la URL del repositorio.
3. Anota los códigos de las carpetas privadas. La app no puede recuperarlos por sí sola.

## Configurar nombres de los integrantes en Supabase

1. Entra al proyecto **Casaenorden** → **SQL Editor → New query**.
2. Abre `supabase_nombres_integrantes_3_9_iPhone.txt`, copia y pega el contenido completo.
3. Pulsa **Run** y verifica que aparezca `Nombres de integrantes instalados` y `rls_activo=true`.
4. Este código crea una tabla nueva y dos funciones seguras para asignar nombres. No elimina hogares ni permisos.
5. Los nombres se guardan por casa. El propietario o administrador puede asignarlos desde **Configuración → Acceso familiar privado → Ver integrantes → Nombre para mostrar → Guardar nombre**. El correo se conserva solo como identificador para invitaciones y administración.

## Subir Casa en Orden 3.9 a GitHub

1. Descarga y descomprime `Casa_en_Orden_3_9_PERSONALIZADA_iPhone.zip`.
2. Desde tu repositorio de GitHub, sustituye los archivos de la app por los nuevos en la raíz donde está `index.html`.
3. Espera a que GitHub Pages despliegue los cambios.
4. Abre tu enlace habitual en Safari con internet y refresca; si la aplicación instalada mantiene la versión anterior, abre el enlace en Safari primero para actualizar los archivos en caché.
5. Confirma que ya **no aparece** la franja con el número de versión.

## Pruebas recomendadas

- **Mercado:** agota un producto de prueba; en «Historial de agotados», los nombres repetidos se agrupan y muestran cuántas veces se agotaron.
- **Configuración:** elige entre Morado, Azul, Verde, Rosa e Índigo. El color se guarda en ese dispositivo.
- **Presupuestos:** elige Semanal, Quincenal, Mes calendario, 30 días, Trimestral, Personalizado o Sin fecha de cierre.
- **Informes:** accede desde **Más → Configuración → Informes y cierres**. Los controles de PDF ya no están en Finanzas.
- **Miembros:** asigna nombres a administrador, editor y lector y revisa cómo se muestran en cada casa. El correo de inicio de sesión seguirá visible en «Mi cuenta», para saber cuál cuenta está conectada.
- **Copias semanales:** en **Configuración → Copia de seguridad → Copias semanales**, pulsa «Crear copia ahora». Debe aparecer en la lista junto a la fecha y número de archivos. La app vuelve a crear otra cuando pasan siete días y se abre o permanece activa. Guarda además respaldos exportados fuera del iPhone.
- **Agenda:** para llevar citas al Calendario de iPhone, pulsa «Pasar al Calendario (.ics)» e importa el archivo. No se actualiza automáticamente el Calendario de iOS si cambias una cita en Casa en Orden.

## Limitaciones importantes

**Sincronización automática con Calendario:** una web instalada desde GitHub Pages no dispone de los permisos de escritura en Calendario de una aplicación iOS nativa. Para una sincronización verdaderamente automática y bidireccional necesitaremos convertir Casa en Orden en una app nativa con permisos de Calendario o conectar un servicio de calendario compatible. La opción .ics es manual.

**Copias semanales:** las copias automáticas se guardan en **IndexedDB en este iPhone** cuando la aplicación está activa o se abre tras siete días. No se pueden realizar mientras la PWA está completamente cerrada. El sistema podría borrar ese almacenamiento; por eso es fundamental **exportar respaldos a Archivos/iCloud** y preparar una solución con almacenamiento remoto protegido si quieres respaldos independientes del teléfono.

**Seguridad:** no publiques documentos privados, contraseñas, claves de Supabase `service_role` ni `sb_secret_` en GitHub. Prueba los nombres y permisos de cada casa con dos cuentas reales antes de compartir datos delicados.
