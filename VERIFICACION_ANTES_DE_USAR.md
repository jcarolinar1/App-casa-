# Prueba rápida de Casa en Orden 3.3

1. **Finanzas**: añade un ingreso y un egreso con cuenta, método, responsable y soporte; comprueba el saldo.
2. **Inversión**: crea una inversión y verifica que figure separada del gasto y del ingreso.
3. **PDF**: entra en Vista previa, cambia el período, desactiva gráficos, cambia a impresión económica. Genera una copia colorida y revisa páginas y anexos.
4. **Mercado**: abre En casa, marca un alimento como Se acabó; confirma que ya no está en despensa y que aparece en el mercado si elegiste reposición.
5. **Menú**: genera 7 días, cambia una receta, imprime menú de adultos y bebé y confirma que aparezcan ingredientes e instrucciones.
6. **Calendario**: registra una cita, una factura y una tarea. Comprueba el calendario; exporta los avisos a Calendario de iPhone e importa el `.ics`.
7. **Historial**: configura el nombre de este teléfono en Familia; modifica un producto; entra al historial y restaura una instantánea (haz respaldo antes).
8. **Cierre mensual**: guarda el cierre y verifica ingresos, gastos, inversiones, mercado, pagos y tareas; reabre y comprueba que puedes corregirlo.
9. **Respaldos**: exporta una copia JSON completa y verifica que se guardó en Archivos.
10. **Familia (solo si se configura nube privada)**: registra dos cuentas con distintos correos, invita al segundo participante, prueba lectura/escritura autorizada y también que el rol de solo lectura no pueda guardar.

Las pruebas deben hacerse primero con datos ficticios, sin comprobantes personales. La versión antigua permanece instalada.


## Verificar miniaturas de la 3.2

1. Registra un movimiento con foto y otro con PDF de una sola página.
2. Abre Finanzas → Vista previa y PDF y verifica que **Miniatura junto a cada movimiento** esté activada y **Anexos completos** desactivada.
3. Comprueba que los movimientos sin archivo muestren «Sin soporte».
4. Descarga el PDF con miniaturas y revisa que la foto esté pequeña al lado de su gasto y la primera página PDF aparezca en miniatura al lado del suyo.
5. Prueba la opción Anexos completos activada; debe incluir al final las páginas originales. Desactívala y comprueba que desaparezcan las páginas adicionales.
6. Prueba «Económico para imprimir» y comprueba saltos entre páginas sin cortar tarjetas.
7. Confirma que la aplicación anterior y los datos/soportes previos siguen accesibles antes de usar la actualización con registros importantes.


## Comprobar la lectura automática de recibos (3.3)

1. En **Finanzas → Nuevo movimiento**, elige **Egreso** y añade una foto nítida de un recibo ficticio o sin datos personales.
2. Espera el mensaje de reconocimiento. Comprueba que **valor, fecha, comercio, método y categoría** se hayan sugerido correctamente cuando estén presentes.
3. Cambia manualmente un campo y comprueba que no vuelva a sobrescribirse; pulsa **Guardar** y verifica que el movimiento aparece con el importe elegido.
4. Prueba también con un PDF: debe quedar adjunto y debe indicar que el autocompletado es solo para fotos.
5. Prueba **Cancelar** tras reconocer una imagen: no debe añadirse un movimiento.
6. Exporta un PDF mensual con miniaturas y comprueba que el recibo está junto al movimiento.
7. Prueba un recibo borroso: debe permitir completar los campos manualmente, nunca asumir cifras dudosas.

No uses documentación financiera importante hasta confirmar todas estas pruebas en Safari de tu iPhone.

## Alcance de la comprobación técnica de 3.3 (16/10/2026)

- Sintaxis de `app.js` y `ocr.js` validada con Node.js.
- Analizador de texto probado con ejemplos de montos, IVA, subtotales y fechas; se corrigieron casos en que el comercio podía confundirse con una fecha o un subtotal.
- Interfaz ensayada en Chromium con **almacenamiento simulado** y **lectura OCR simulada**: se verificaron sugerencias en los campos, corrección manual, cancelación, guardado del registro con soporte, edición, visualización y eliminación del archivo sin borrar el movimiento. Estas pruebas confirman la lógica de la interfaz, pero **no prueban** el motor OCR real, el almacenamiento nativo del iPhone ni la publicación en GitHub Pages.
- En el navegador de pruebas el acceso directo a páginas locales estuvo bloqueado; tampoco se pudo probar físicamente Safari/iOS. Los recibos reales pueden requerir ajustes si la calidad de la imagen dificulta la lectura. Antes de usar datos personales, ensaya con un recibo de prueba sin información privada.
