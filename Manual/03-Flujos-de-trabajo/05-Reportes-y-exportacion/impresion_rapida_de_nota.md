# Reportes — Impresión rápida de la nota activa (quick print)

## ¿Para qué sirve?
Exportar **rápidamente** la nota que tenés abierta como reporte de una sola pieza, usando una **plantilla de estilo** predefinida en settings (sin armar árbol de proyecto completo).

## Resultado (qué obtenés)
- Salida **PDF** y/o **DOCX** de la nota actual (según opciones del plugin y disponibilidad desktop).

## Pasos

1. Abrí la nota a imprimir/exportar (panel central).
2. Command palette → **Print active note** (nombre según idioma).
3. Si el plugin pide confirmar plantilla `quickPrintTemplateId`, configurála antes en **Settings → Emic Report Architect** (campo “plantilla para impresión rápida” o equivalente).
4. El export sigue la misma ruta de salida que reportes normales ([[exportar_a_pdf_y_docx]]).

## Cuándo usarlo vs compositor completo

| Situación | Herramienta |
|-----------|-------------|
| Una sola nota final | Quick print |
| Informe largo con muchas fuentes y TOC | Compositor [[armar_un_reporte]] |

## Problemas comunes

- **Salida vacía o sin estilo**: plantilla quick print no seteada.
- **No exporta en mobile**: export PDF real suele requerir desktop/Electron.

Ver referencia: [[04-Referencia-por-modulo/emic-reports]].
