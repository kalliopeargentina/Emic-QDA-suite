# Gráficos — Crear gráficos con el Wizard

## ¿Para qué sirve?
Construir un gráfico **sin escribir YAML a mano**: elegís tipo de chart, fuente de datos (manual, CSV del vault, tabla Markdown con block-id), series, y el plugin inserta el bloque `emic-charts-view`.

## Resultado (qué obtenés)
- Un bloque fenced ` ```emic-charts-view` en la nota con YAML generado y render al volver a modo lectura/preview.

## Pasos

1. Command palette → **Wizard** *(Emic Charts View)*.
2. Se abre el modal ancho con **preview en vivo**.
3. Elegí **Chart Type** (Bar, Line, Pie, DualAxes, WordCloud, …).
4. **Data source**:
   - **Manual**: completá labels/values por series.
   - **CSV**: seleccioná archivo(s) dentro de `Data Folder` configurado en Settings del plugin (clave `dataPath`). Podés agregar múltiples archivos (útil para DualAxes).
   - **Markdown Table**: elegí una tabla detectada por **block-id** en la nota actual; en DualAxes configurá geometría/color por serie cuando aparezca la UI.
5. Ajustá número de **value series** si aplica.
6. **Confirm**: el bloque YAML se inserta donde estaba el cursor del editor.

## Ajustes útiles previos (Settings → Emic Charts View)

| Ajuste | Efecto |
|--------|--------|
| dataPath | Carpeta base para listar CSV en wizard |
| theme / background / padding | Aspecto por defecto si el YAML no fuerza otro |
| showExportBtn | Muestra botón export PNG sobre el chart |
| wordCountFilter | Stopwords para charts `wordcount:` (otro flujo) |

## Problemas comunes

| Síntoma | Revisar |
|---------|---------|
| No lista CSV | `dataPath` vacío o carpeta sin `.csv` |
| Tabla MD no aparece | Falta block-id en tabla de la nota activa |
| DualAxes raro | Dos datasets y campos x/y/series correctos |

Ver también: [[crear_graficos_con_templates]], [[usar_datos_csv_tablas_y_wordcount]], [[04-Referencia-funcional/charts_view]].
