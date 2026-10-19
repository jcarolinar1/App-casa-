# Casa en Orden 3.8.5 — Préstamos por persona

## ¿Qué se agregó?

En **Finanzas**, abre **🤝 Préstamos**. Allí puedes registrar préstamos que haces a otras personas (**Por cobrar**) y préstamos que recibes (**Por pagar**). Cada uno se agrupa por nombre de la persona, con capital, interés pactado, fecha de entrega, fecha de vencimiento, total pendiente, estado y un historial de abonos parciales.

Puedes utilizar tres condiciones: **sin interés**, **interés fijo total** o **interés mensual simple**. El mensual simple se calcula una sola vez como `capital × porcentaje mensual / 100 × (días entre fechas / 30)`; no acumula intereses compuestos ni renueva automáticamente la deuda. La cifra calculada es una estimación de las condiciones registradas; verifica lo que realmente acordaron.

Al crear un préstamo o registrar un abono, se crea un movimiento vinculado en Finanzas. **El capital prestado y devuelto no se suma a los ingresos ni a los egresos de consumo.** Si eliges una cuenta de origen/destino, se actualiza su saldo contable estimado. Si no eliges cuenta, no se ajusta ningún saldo de cuenta.

## Cómo usarlo

1. **Finanzas → 🤝 Préstamos → Nuevo préstamo**.
2. Elige **Yo presté dinero** o **Me prestaron dinero**.
3. Escribe nombre, capital, fecha, vencimiento, interés y cuenta opcional.
4. Guarda; se crea la ficha de la persona y un movimiento de préstamo.
5. Abre su ficha para **Registrar abono** o consultar el historial.
6. Usa **Filtrar por persona** y **Por cobrar / Por pagar** para analizar la cartera.

Los préstamos quedan incluidos en los datos de la **casa seleccionada**. Cartagena y Bogotá tienen carteras independientes. En modo local pueden usarse sin internet; la sincronización entre teléfonos requiere conectividad y haber configurado Supabase con permisos.

**No hay cobranza, transferencia de dinero ni alertas automáticas de vencimiento.** Los estados vencido/pagado se muestran al abrir la sección.

## Instalación desde iPhone/GitHub

1. En la versión que estás usando, exporta primero un **respaldo completo** de cada casa, incluidos soportes.
2. Descomprime el ZIP y sube **los archivos de su interior** a la raíz del repositorio donde está `index.html`; no subas documentos privados, respaldos con datos reales, credenciales o el ZIP como único archivo.
3. Confirma **Commit changes** y abre GitHub Pages desde Safari. Comprueba **Versión 3.8.5**.
4. Prueba un préstamo ficticio, registra un abono y comprueba saldo pendiente y **Cuentas y saldos**.

No se necesita ejecutar otro SQL para este módulo: se guarda en el snapshot de cada casa existente. No reemplaces ni borres datos desde Safari antes de verificar la copia de seguridad.

## Verificaciones técnicas

- Comprobación de sintaxis JavaScript: correcta.
- Navegación y registro en Chromium con HTML y scripts cargados en memoria: correctos.
- Préstamo COP 100.000 + interés fijo COP 20.000 y abono COP 30.000 → pendiente COP 90.000.
- Segundo préstamo de COP 50.000 de otra persona: visible por separado.
- Filtro por persona: correcto.
- Entradas contables vinculadas y cálculo de saldos: verificados con cuentas de ejemplo.
- Eliminación con confirmación: elimina el préstamo y sus movimientos relacionados.
- Pendiente: prueba en Safari iPhone, RLS y sincronización real entre familiares y dos casas.
