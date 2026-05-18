# Reportes — Guardar y reutilizar reportes

## ¿Para qué sirve?
Conservar **proyectos de reporte** para no armar la misma estructura cada vez (versiones, informes periódicos, anexos estables).

## Resultado (qué obtenés)
- Un reporte **guardado** en el almacén del plugin (JSON bajo `.obsidian/plugins/emic-reports/data/projects/` en instalaciones típicas; no hace falta editarlo a mano).
- Posibilidad de **cambiar al reporte guardado** y **exportarlo** sin rearmar árbol.

## Pasos — creación y guardado implícito

1. Armá el reporte en el compositor ([[armar_un_reporte]]).
2. Si el plugin auto‑guarda, solo asegurate de nombrar el proyecto al crearlo.
3. Si existe comando **Save report now** / guardar ahora, usalo tras cambios grandes.

## Pasos — listar / exportar un reporte guardado

1. Command palette → **Export saved report** (seleccioná el proyecto de la lista/picker).
2. Elegí formato de salida según [[exportar_a_pdf_y_docx]].

## Pasos — borrar / duplicar (si la UI lo ofrece)

Desde el compositor o menú del proyecto (según versión):

- **Delete** para archivar/borrar proyecto obsoleto (tras backup).
- **Duplicate** (si existe) para variante con pequeños cambios.

## Buenas prácticas

- Nombrá proyectos con **fecha** y **audiencia** (`2026-05 Diagnóstico interno`).
- Antes de export definitivo, generá **preview** ([[exportar_a_pdf_y_docx]] menciona preview).

Ver referencia módulo: [[04-Referencia-por-modulo/emic-reports]].
