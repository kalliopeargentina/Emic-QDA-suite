# Tablas y CSV — Editar CSV como tabla

## ¿Para qué sirve?
Trabajar datos tabulares dentro de Obsidian como si fuera una **hoja de cálculo** (edición de celdas, undo/redo, delimitador configurable) sin salir del vault.

## Resultado (qué obtenés)
- Archivo `.csv` modificado *in place* con una UI de grilla.

## Pasos

1. En el explorador de archivos de Obsidian abrí cualquier `.csv` del vault.
2. Se registra la vista **emic-csv-view** (tabla editable) automáticamente.
3. Editá celdas con doble click o flujo de celda activa del plugin.
4. Deshacer/rehacer con atajos estándar donde aplique.
5. Para ver/editar **texto plano** crudo del CSV, alterná a la vista **source** con el control del plugin (nombre “source” / “CSV source” según versión).

## Delimitador incorrecto

Si columnas se desalinean:

1. Settings → **Emic Table Tools** → **preferredDelimiter** (auto / `,` / `;` / TAB).
2. Reabrí el CSV o forzá re-parse desde la barra de la vista si existe.

## Consejos para QDA

- Buen puente entre **extracciones exportadas CSV** y reporting.
- Antes de graficar con Emic Charts, validá que la primera fila sean **cabeceras**.

Siguiente flujo de reingreso a notas: [[insertar_csv_como_tabla_en_nota]].
