# Casa en Orden 3.8 — Mercado conectado con Finanzas

## Mejoras

- En **Mercado → Lista de compras** aparece el bloque «Mercado y finanzas» con el total de pagos registrados durante el mes en la casa seleccionada y el número de artículos comprados pero aún no pagados.
- Al marcar **Comprado**, el artículo se agrega a **En casa** (despensa), **sin contabilizar ningún egreso todavía**.
- Al pulsar **Registrar pago**, se presenta un resumen con los artículos comprados pendientes de pagar. La persona debe confirmar el importe realmente abonado, fecha, cuenta, método y responsable. Puede adjuntar foto o PDF del recibo (máximo 4 MB). La app registra un solo egreso de Mercado, enlazado a los artículos.
- Si el gasto ya se registró desde este formulario, pulsar de nuevo **Registrar pago** no vuelve a incluir los mismos productos.
- En **Finanzas**, se añadió la pestaña «🛒 Mercado» y el enlace «Ver productos de esta compra». El detalle conserva una instantánea del nombre, cantidad y precio de los productos del momento del pago, aunque luego se editen en Mercado.
- Los movimientos de Finanzas y de los informes se ordenan **por fecha descendente**. Entre registros de la misma fecha, aparece primero el creado después. Los movimientos antiguos sin sello horario utilizan su posición original para desempatar.
- Al borrar desde Finanzas un pago vinculado al mercado, se informa que las compras volverán a estar pendientes de pago; los productos no se eliminan de despensa.
- Las compras y los pagos siguen separados por la **casa seleccionada**. El gasto no sale de una cuenta bancaria real: únicamente se anota en las finanzas del hogar.

## Instalación desde iPhone

1. **Exportar respaldo** desde Más → Copia de seguridad, incluyendo documentos y comprobantes. Comprobar que quedó en Archivos.
2. Descargar este ZIP y **descomprimirlo** en Archivos.
3. En GitHub, entrar al repositorio donde ya está Casa en Orden. Subir los archivos descomprimidos a la raíz (junto a `index.html`) y sustituir los archivos de igual nombre. **No subir el ZIP como único archivo ni borrar los datos de Safari.**
4. Abrir GitHub Pages en Safari con internet y comprobar que arriba dice **3.8**. Si sigue mostrando la versión anterior, esperar el despliegue y volver a cargar.
5. Marcar un artículo de prueba, comprobar que aparece en «En casa», pulsar «Registrar pago», confirmar el valor y luego revisar la pestaña «Mercado» dentro de Finanzas.

## Seguridad y límites de la prueba

- Mantiene la conexión Supabase existente; **no requiere otro SQL**.
- Probado con lógica JavaScript aislada: orden, pago único, relación de productos, detalles y reversión del pago. **No fue posible una prueba visual en Safari de este entorno**. Confirmar con pruebas reales antes de usar información financiera sensible.
- Los archivos y la sincronización familiar siguen dependiendo del almacenamiento y de la configuración Supabase ya instalada. Evitar registrar la misma compra desde dos teléfonos a la vez hasta comprobar el comportamiento de sincronización.
