-- Casa en Orden 3.6: ampliar formatos permitidos para Documentos de la casa.
-- Ejecutar ÚNICAMENTE después de instalar supabase_setup.sql de la app.
-- Mantiene bucket PRIVADO y políticas existentes. NO crea un bucket público.
DO $$ BEGIN
 IF NOT EXISTS(SELECT 1 FROM storage.buckets WHERE id='casa-supports') THEN
   RAISE EXCEPTION 'No existe el bucket privado casa-supports. Ejecuta primero supabase_setup.sql y el ajuste de dos casas.';
 END IF;
END $$;
UPDATE storage.buckets
SET public=false,
    file_size_limit=5242880,
    allowed_mime_types=ARRAY[
      'application/pdf','image/jpeg','image/png','image/webp','image/heic','image/heif',
      'application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'text/plain','text/csv'
    ]
WHERE id='casa-supports';
-- ¡No tocar RLS! Los miembros de otra casa no deben leer estos archivos.
-- PRIVADO: estos documentos solo se almacenan localmente en el iPhone.
