# Gráficos — Crear gráficos desde plantillas (Insert Template)

## ¿Para qué sirve?
Insertar rápidamente ejemplos funcionales (Barras, Pie, WordCloud, WordCount, DualAxes, Treemap, Scatter, etc.) **basados en templates** con miniaturas para no empezar YAML desde cero.

## Resultado (qué obtenés)
- Bloque ``` `emic-charts-view` con configuración base editable en el editor.

## Pasos

1. Poné el cursor en la nota destino.
2. Command palette → **Insert Template**.
3. Se abre un **FuzzySuggestModal** con **thumbnails** por template.
4. Elegí tipo (Bar, Pie, WordCloud…).
5. Confirmá: el template se decodifica y se inserta como bloque Markdown normalizado.
6. Ajustá el YAML (por ejemplo `data:`) según tu corpus.

## Templates frecuentes en QDA

| Template | Uso típico |
|----------|------------|
| WordCount | Distribución lexical / tópicos rápidos sobre scope de notas |
| Bar / Column | Comparar frecuencias de códigos exportados a CSV |
| Pie | Partes de una categoría cerrada |
| DualAxes | Serie temporal + conteo paralelo |

Para WordCount y Dataview ver [[usar_datos_csv_tablas_y_wordcount]] y [[graficos_con_dataview]].

## Consejo

Después de insertar, pasá a modo **lectura** para validar tema/fondo; podés sobrescribir `theme:` en YAML o apoyarte en defaults del plugin ([[04-Referencia-funcional/charts_view]]).
