# Casa en Orden 3.7.1 — compras a despensa

Esta actualización arregla el problema por el que un producto marcado como **Comprado** no aparecía en **En casa**.

## Antes de instalar
1. Abre la versión actual y exporta un **respaldo completo**, con los comprobantes y documentos. Guárdalo en Archivos del iPhone; **nunca** subas el respaldo a GitHub.
2. Conserva tu usuario, contraseña de Supabase y los códigos de Privado; no los envíes a GitHub.

## Actualizar en GitHub Pages
1. Descomprime el ZIP en Archivos.
2. En el mismo repositorio, reemplaza los archivos de la aplicación con los de la actualización, en la misma carpeta donde está `index.html`. No subas el ZIP como si fuera la página, ni crees una carpeta anidada.
3. Guarda los cambios y espera a que GitHub Pages publique.
4. Abre el enlace en Safari con conexión y recarga. Si aparece la versión anterior, cierra esa pestaña y vuelve a abrirla; no borres los datos de Safari.

## Prueba
1. Entra a la casa correcta (Bogotá o Cartagena).
2. Ve a **Mercado → Lista de compras**.
3. Marca como comprado un producto de prueba.
4. Debe indicar **✓ En despensa**. Entra a **En casa** y comprueba nombre, cantidad y categoría.
5. Si deseas vencimiento o ubicación diferente, pulsa **Editar** sobre el producto en despensa.
6. Regresa a la lista. El producto seguirá marcado, para poder incluirlo en **Registrar pago de compras**. No se registra ningún gasto sin tu confirmación.
7. Desmarca y vuelve a marcar el mismo producto: no debería duplicarse en la despensa.
8. Cambia a la otra casa y confirma que no aparecen compras de la primera.

### Compras marcadas antes de actualizar
Si ya estaban marcadas pero no aparecen en despensa, toca **➕ A despensa** junto a ellas. La aplicación solo las agrega una vez.

### Nota
La actualización no modifica tablas de Supabase y no importa datos de una casa en otra. El bloqueo de documentos privados y las demás funciones de 3.7 se conservan.
