# Prueba en iPhone: Casa en Orden 3.4 sin internet

1. Abre la aplicación **en Safari con Wi-Fi** desde tu propia dirección de GitHub Pages. Espera a que termine de cargar.
2. En **Inicio** → **Preparar modo sin internet** → **✓ Preparar modo sin internet**; espera la confirmación.
3. Antes de cortar la conexión, exporta desde la aplicación el **respaldo completo con soportes** a Archivos.
4. Activa **Modo avión**, apaga Wi-Fi y datos móviles. Cierra Casa en Orden y ábrela desde la pantalla de inicio.
5. Confirma que puedes abrir Mercado, Despensa, Agenda, Pagos y Finanzas. Registra un movimiento de prueba de $1.000, adjunta una foto y guarda. Comprueba que aparece en la lista.
6. Abre **Finanzas → Vista previa y PDF**. Usa **🖨️ Imprimir / PDF Safari** y comprueba la vista previa sin internet. Las fotografías aparecen pequeñas junto a los movimientos; los soportes PDF aparecen identificados, no incrustados como imagen en esta alternativa.
7. Cierra y vuelve a abrir la aplicación todavía en modo avión: el movimiento de prueba debe seguir registrado.
8. Vuelve a conectarte. Si usas sincronización familiar de Supabase, revisa las diferencias antes de sincronizar; **no se ha probado resolución automática de conflictos**.

**No esperes que funcionen sin red:** nube compartida, autenticación, lectura OCR si no hay todos sus recursos en caché y descarga PDF avanzada si la biblioteca externa falta. La foto se puede adjuntar sin leerla automáticamente. Safari puede borrar datos del sitio si el dispositivo necesita almacenamiento.
