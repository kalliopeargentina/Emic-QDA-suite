# Tablas y CSV — Insertar CSV como tabla en una nota Markdown

## ¿Para qué sirve?
Tomar un `.csv` (ya sea abierto en vista tabla o desde el vault) y **pegar** en el editor una **tabla GFM** lista para leer en modo lectura o imprimir en reportes.

## Resultado (qué obtenés)
- Marcado de tabla Markdown compatible con Obsidian en la posición actual del cursor.

## Pasos

1. Command palette → **Insert CSV as markdown** *(Insertar CSV como tabla en la nota — según idioma)*.
2. Si tenés un CSV abierto en vista tabla, el comando usa esos datos como fuente.
3. Si no, el plugin te pedirá **elegir un archivo** `.csv` del vault.
4. Elegí opciones en el diálogo (`delimiter`, primera fila como encabezados, etc.).
5. Confirmá — la tabla se inserta donde estaba el cursor.

## Cuándo usarlo

| Escenario | Razón |
|-----------|------|
| Pegar resumen en informe intermedio | Legibilidad Markdown |
| Compartir tabla con colega sin CSV | Un solo archivo `.md` |

## Consejo

Si el CSV viene de [[exportar_tablas_markdown_a_csv]] y volvés atrás, perdés posiblemente formato rico (bold dentro de celdas) — esperá texto plano celda a celda.

Ver módulo: [[04-Referencia-por-modulo/emic-table-tools]].
