# Tablas y CSV — Block-id y transponer tablas Markdown

## ¿Para qué sirve?
Dos utilidades frecuentes al preparar datos:

1. **block-id** establece un ancla `^tabla-N` debajo de una tabla para poder **linkearla** y referenciarla (también puede influir en naming al exportar CSV).
2. **Transponer** intercambia filas↔columnas sin reescribir a mano cuando pivotás la presentación.

## Resultado (qué obtenés)
- Tabla con línea `^tabla-...` **estable** cuando corresponda.
- Nueva orientación de tabla en el editor.

## Requisitos

- Plugin **Emic Table Tools**.

## Asignar block-id — una tabla

1. Cursor dentro de la tabla objetivo.
2. Command palette → **Asignar block-id a esta tabla** *(assign table block id)*.

## Asignar block-id — todas las tablas de la nota

1. Cursor en la misma nota.
2. Command palette → **Asignar block-id a todas las tablas…** *(assign all tables block id)*.

Si una tabla ya tiene id, el comando salta según lógica del plugin.

## Transponer una tabla

1. Cursor dentro de la tabla.
2. Command palette → **Transponer Tabla** *(Transpose table)*.
3. Verificá resultado: celdas vacías rellenadas con `""` según implementación; la línea de **block-id posterior** se preserva cuando aplica.

## Consejos pedagógicos

- **Primero** decidí si vas a referenciar tabla en queries Dataview o gráficos Markdown table source **luego** asigná IDs.
- Si transponés después de asignar ID, validá que Obsidian sigue resolviendo el block ref correctamente.

Menú contextual “Table Tools” acelera ambas acciones cuando está habilitado.

Ver: [[04-Referencia-por-modulo/emic-table-tools]].
