# Casa en Orden 3.8.2 — Inicio, inventario y permisos

Actualización basada en la versión 3.8.1. No necesitas volver a crear Supabase, cuentas familiares ni casas.

## Antes de actualizar

1. En cada casa, entra a Más → Copia de seguridad → Exportar respaldo, incluidos soportes.
2. Comprueba que los movimientos pendientes estén sincronizados. No borres los datos de Safari.
3. Conserva el respaldo en Archivos del iPhone, fuera de GitHub. No subas documentos privados ni claves secretas al repositorio.

## Configurar Supabase para desvincular integrantes (obligatorio)

1. Abre Supabase → proyecto Casaenorden → SQL Editor → New query.
2. Abre el archivo **supabase_desvincular_integrantes_3_8_2_iPhone.txt** incluido en el ZIP; copia todo su contenido en la consulta.
3. Pulsa Run. Espera una fila indicando que la función `remove_household_member` existe. NO ejecutes de nuevo el SQL de instalación anterior.
4. Este código **no elimina** usuarios de Supabase Auth, casas, documentos ni transacciones. Retira únicamente la pertenencia autorizada a la casa seleccionada y borra sus invitaciones anteriores de esa casa.

## Subir GitHub Pages

1. Descomprime este ZIP en Archivos.
2. Sube los archivos de la aplicación al **mismo directorio raíz** del repositorio, reemplazando `app.js`, `index.html`, `styles.css`, `sw.js` y demás archivos de igual nombre. No subas el ZIP directamente.
3. Espera a que GitHub Pages publique el cambio y abre la app en Safari con internet.
4. Comprueba el encabezado **VERSIÓN 3.8.2**. Si sigue apareciendo una versión vieja, actualiza Safari y vuelve a abrir la app. No borres almacenamiento ni desinstales mientras se comprueba el respaldo.

## Comprobar las tres mejoras

* En **Inicio**, aparecen los cinco movimientos más recientes de la casa actual y los botones «Ver todos los movimientos» y «Nuevo movimiento».
* En **Mercado → En casa**, pulsa «Se acabó»: el producto se quita de despensa y recetas, **sin crear otro producto en Compras**. El historial de agotados solo permite consultar, no reponer.
* En **Más → Familia y ajustes → Configurar nube y acceso → Ver / desvincular integrantes**, la persona propietaria verá «Desvincular» junto a administradores, editores y lectores. Confirma el correo y la casa antes de retirar el acceso.

## Seguridad y límites

* **Nadie puede desvincular al propietario** con esta acción. Solo el propietario puede quitar administradores. Administradores pueden quitar editores y lectores.
* La revocación se valida con seguridad en el servidor Supabase. La app vuelve a consultar permisos cuando está en línea y retira su copia de esa casa si detecta pérdida de acceso.
* **No se puede borrar remotamente una copia o archivo previamente descargado en otro teléfono mientras está desconectado**, ni recuperar documentos que otra persona exportó fuera de Casa en Orden.
* El SQL y la lógica se comprobaron en pruebas locales. Antes de usar datos familiares sensibles, valida con dos cuentas reales que el acceso a la casa revocada sea rechazado en Supabase.
* Las compras y pagos anteriores quedan como estaban. Los duplicados creados antes de esta versión no se borran automáticamente; revísalos y elimínalos manualmente tras hacer respaldo.

La actualización no conecta bancos ni envía dinero.
