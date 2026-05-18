# PDF (apoyo a QDA) — Copiar citas y enlaces desde PDF

## ¿Para qué sirve?
Sacar del visor PDF fragmentos **citables** insertables en notas Markdown con **enlace de retorno** al PDF (y a la selección o anotación si aplica). Esto integra lectura PDF dentro del flujo QDA sin “perder” la trazabilidad del material.

## Resultado (qué obtenés)
- Texto pegado en la nota como cita (quote), link, embed, callout, etc. según el **formato de copia** activo en **EMIC PDF++** / PDF++ fork.

## Pasos básicos — copiar con enlace a selección/anotación

1. Abrí un PDF en el visor nativo de Obsidian.
2. **Seleccioná texto** con el mouse.
3. Command palette → **Copy link to selection or annotation** *(copy-link-to-selection)* — o usá el menú contextual del plugin si lo activaste.
4. Pegá en tu nota Markdown (nota analítica / memo / datafile según tu método).
5. Opcional: usá **Copy format menu** / **Display text format menu** para alternar plantillas de salida.

## Formatos de texto de enlace (display)

En **Settings → EMIC PDF++** existen plantillas `displayTextFormats` ej. `Title & page`, `Page`, `Text`, etc. Elegí cuál produce el display que querés en el link resultante.

## Formatos de copia (quote / callout / embed)

`copyCommands` típicos incluyen:
- Quote (`> ...`)
- Link plano
- Embed `![]`
- Callout con color

Usá el menú contextual o comando **Show copy format menu** para alternar sin abrir settings cada vez.

## Consejos pedagógicos

- Creá una **nota de lectura por PDF** donde acumulás citas + comentario libre + link.
- Unificá formato (siempre quote vs siempre callout) para que el reporte final sea homogéneo.

## Problemas comunes

| Síntoma | Revisar |
|---------|---------|
| No copia bien la selección bug Obsidian | Opción en settings `fixObsidianTextSelectionBug` (si tu build la trae) activada |
| Link roto en nota | Moviste/renombraste PDF — actualizá enlace |
| Necesito escribir highlights en el PDF | Habilitá modo edición PDF sólo si forma parte de tu flujo (esto ya no es “minimal QDA”, es feature avanzada; documentala aparte si equipo la usa) |

Análisis posterior: [[03-Flujos-de-trabajo/02-Codificacion-y-codebooks/codificar_parrafos_asignar_y_quitar]].
