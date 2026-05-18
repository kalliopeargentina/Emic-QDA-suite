# Tablas y CSV — Exportar tabla Markdown a CSV

## ¿Para qué sirve?
Convertir una tabla **GFM** (Markdown estándar de Obsidian) en un archivo `.csv` editable con hojas de cálculo y reutilizable como dataset o como fuente para gráficos.

## Resultado (qué obtenés)
- Archivo `.csv` dentro del vault en la carpeta que elijas (prefijada por default en **Emic Table Tools** settings si la configuraste).

## Requisitos
- Plugin **Emic Table Tools** habilitado.

## Pasos

1. Abrí la nota que contiene la tabla.
2. Colocá el **cursor dentro de la tabla** o hacé clic sobre ella.
3. Abrí la **Command palette** y ejecutá **Export table to CSV** *(Exportar tabla a CSV)*.
   - Alternativa: clic derecho sobre la tabla → menú **Table Tools** → Exportar (si tu versión lo muestra).
4. En el **modal** revisá la **previsualización**.
5. Confirmá **columnas / encabezados** según opciones del modal.
6. **Save to file**: elegí nombre y carpeta destino (tomará `defaultExportFolder` si lo definiste en Settings del plugin).
7. Si activaste **open csv after export**, se abrirá en la vista tabla del plugin.

## Ajustes relacionados (Settings → Emic Table Tools)

| Clave | Uso |
|-------|-----|
| defaultExportFolder | Carpeta sugerida por defecto al guardar |
| preferredDelimiter | Para abrir CSV después (auto/coma/punto y coma/tab) |
| openCsvAfterExport | Abrir archivo recién generado automáticamente |

## Consejos para QDA
- Si la tabla resume **frecuencias** o **extracciones**, exportá con encabezados para análisis estadístico liviano.
- Usá **assign block id** ([[block_id_y_transponer_tablas]]) antes del export si necesitás filenames con identificador de tabla.

Siguiente: [[editar_csv_como_tabla]].
