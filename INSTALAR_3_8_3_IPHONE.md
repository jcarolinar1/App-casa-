# Casa en Orden 3.8.3 · Mascota Cartagena y responsables por casa

## Qué cambia

- **Cartagena**: en **Familia y ajustes** se muestra **Mascota** en lugar de **Datos del bebé**. Guarda nombre, especie, raza, edad, veterinario y notas. En Inicio verás un acceso a citas de mascota. El menú de personas queda solo para adultos; no se generan recetas humanas para mascotas.
- **Bogotá**: se conserva la ficha de bebé y el menú de adultos y bebé.
- **Ambas casas**: en Inicio y Cambiar casa se visualiza el correo y rol de propietario y administradores, siempre que haya conexión a Supabase y la nueva función SQL instalada. Esta información se facilita solo a usuarios autenticados pertenecientes a esa casa.
- Los datos ya guardados de mercado, finanzas, documentos y perfiles existentes se conservan.

## Instalación segura desde iPhone

1. Exporta el respaldo completo de Casa en Orden, incluidos documentos y comprobantes.
2. En **Supabase → SQL Editor → New query**, copia el contenido de `supabase_administradores_visibles_3_8_3.sql` y pulsa **Run**. Debe devolver la función `household_admin_contacts`.
3. Descarga y descomprime el ZIP de esta versión, luego actualiza los archivos del mismo nivel de tu repositorio de GitHub Pages. No subas tus respaldos, fotos ni contraseñas a GitHub.
4. Abre tu aplicación en Safari con internet, actualiza y confirma **3.8.3** en la barra superior.
5. Selecciona Cartagena y abre **Más → Familia y ajustes → Perfil de mascota**. Después vuelve a Inicio y revisa la tarjeta **Administración de Cartagena**.
6. Abre **Cambiar casa** y comprueba que las dos casas muestran sus respectivos correos; selecciona Bogotá y verifica **Datos del bebé**.

## Límites y seguridad

- La información de administradores se recupera de Supabase para usuarios autorizados. Si no se ha ejecutado la actualización SQL, no se mostrarán correos. No concedas acceso a personas no autorizadas.
- La consulta se actualiza con conexión; estando sin internet podría verse un dato que se descargó anteriormente y ya cambió. Antes de confirmar cambios de permisos, verifica con conexión.
- Si tienes una casa denominada de forma distinta, no se cambia automáticamente a Mascota. La versión identifica Cartagena por nombre y conserva su elección después de guardar el perfil.
- La información de mascota es un registro, no consejo veterinario. Las dietas para mascotas dependen de especie y recomendaciones profesionales.
- No borres Safari ni reinstales sin respaldo.
