# Gráficos — CSV del vault, tablas Markdown y WordCount

## ¿Para qué sirve?
Alimentar gráficos `emic-charts-view` con tres fuentes comunes durante análisis cualitativo: **datasets tabulares** (CSV), **tablas en notas**, y **conteos de palabras** sobre subsets del vault.

## 1) CSV interno desde carpeta configurada (`dataPath`)

1. Settings → Emic Charts View → **Data Folder**.
2. Colocá allí tus `.csv` (exportados desde tabla MD vía Table Tools u otro proceso).
3. En el YAML:

```yaml
data: "mi_archivo.csv"
```

Para DualAxes con dos fuentes típicamente:

```yaml
data: "archivo_a.csv, archivo_b.csv"
```

## 2) Importar CSV externo (solo desktop)

1. Command palette → **Import data from external CSV file**.
2. Elegís archivo `.csv` del disco con el diálogo nativo (`fileDialog`).
3. El contenido inserta como YAML (`data:` con array de objetos) en el cursor.

## 3) Tabla Markdown con block-id (Wizard)

Preferí [[crear_graficos_con_wizard]] → fuente **Markdown Table** después de aplicar [[../06-Tablas-y-csv/block_id_y_transponer_tablas]] sobre la tabla.

## 4) WordCount desde scope de notas/carpetas

Sintaxis en `data`:

```yaml
data: "wordcount:MiNota"
data: "wordcount:nota_a,nota_b,@MiCarpeta/"
data: "wordcount:/"
```

- Lista separada por comas incluye carpeta `@Carpeta/`.
- `/` cuenta **todo el vault** (¡puede tardar!).

Las **palabras ignoradas / regex** se configuran en Settings → **Word Filter** (`wordCountFilter`).

### Wordcount en combinación WordCloud chart

Creá desde template WordCloud ([[crear_graficos_con_templates]]) y reemplazá `data` por string `wordcount:...`.

## Consejos

- Normalizá **headers** antes de graficar (sin espacios raros en nombres de columna).
- Para grandes corpora, probá carpeta antes que `/`.

Referencia sintaxis amplia: [[04-Referencia-funcional/charts_view]].
