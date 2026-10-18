# Casa en Orden 3.7: Privado con código cifrado

### Qué significa «dos casas con su propio acceso»

Cada hogar tiene integrantes y roles independientes en Supabase; una persona puede pertenecer a ambos y otra solo a uno. **No existe una contraseña compartida para toda la casa**: cada persona utiliza su cuenta y se autoriza por membresía y reglas RLS. La app local debe sincronizarse y probarse con dos cuentas reales antes de confiar en ella.

### Bloquear Documentos → Privado

1. Abre **Más → Documentos → Privado**.
2. Pulsa **Crear código y proteger**; crea un PIN numérico de 8 a 12 cifras y confírmalo. El PIN será exclusivo del **usuario y casa en ese iPhone**.
3. Los documentos antiguos de Privado se migran a archivos cifrados **AES-GCM**. Se cifra también la lista de nombres. No elijas códigos fáciles de adivinar. Si falta algún archivo anterior, la migración no continúa.
4. Al cerrar la carpeta, usa **Bloquear Privado**. Para abrirla otra vez necesitarás el PIN. Se bloquea también al cambiar de casa o cerrar sesión; tras más de 90 segundos fuera de pantalla (o cerrar la página) se bloquea.
5. Los archivos nuevos se cifran al guardarlos y solo se descifran al abrirlos o exportarlos después de introducir el PIN.

### Limitaciones y seguridad

- **Face ID todavía no está habilitado**: una PWA de GitHub Pages no puede invocar Face ID directamente. Para una opción biométrica real se requiere WebAuthn/passkeys con soporte en Safari y pruebas adicionales.
- Este PIN **no es** el acceso a Supabase: protege documentos privados guardados **localmente**, no los datos compartidos de cada casa. No se sincroniza la carpeta Privado ni la llave cifrada.
- Si olvidas el PIN, no hay método de recuperación automática. El código no se guarda; **no lo compartas**.
- Realiza un respaldo completo antes de actualizar. Para exportar respaldos con una bóveda configurada, primero desbloquea Privado. Los respaldos guardan los archivos cifrados y el verificador de la bóveda; el resto de datos del hogar en el archivo JSON **no se cifran**.
- Puede haber copias anteriores sin cifrar (descargas, respaldos 3.6, otras ubicaciones). Debes proteger o eliminar manualmente esas copias. Safari puede borrar almacenamiento local y entonces los documentos se pierden si no tienes respaldo.
- En teléfonos compartidos hay otros riesgos (permisos de Safari, sesiones abiertas, archivos descargados). La seguridad completa de cada casa requiere permisos RLS validados en Supabase.

### Actualización segura

No cargues datos sensibles ni copias de respaldo a un repositorio público. Descarga una copia de respaldo de 3.6, sube solo el código a un **repositorio de prueba**, abre la versión 3.7 desde Safari con HTTPS y comprueba PIN, cifrado, bloqueo, cambios de casa, respaldo y restauración. Para carpeta Privado no se requiere una migración SQL adicional.
