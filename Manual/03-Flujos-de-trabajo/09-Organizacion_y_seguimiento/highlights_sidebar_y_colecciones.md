# Organización y seguimiento — Highlights sidebar y colecciones

## ¿Para qué sirve?
Navegar evidencia resaltada (códigos, entidades, extracciones…) en un **panel lateral** dedicado, agrupar vistas en **colecciones** persistidas, y saltar rápido a cada pasaje sin perder contexto.

## Resultado (qué obtenés)
- Panel derecho/izquierdo (según configuración) **Highlights** abierto.
- Comandos rápidos tipo “ir a colección X” si definiste colecciones en settings.

## Abrir / alternar el sidebar

1. Command palette → **Emic-QDA: open highlights sidebar** *(open-highlights-sidebar)*.
2. Para colapsar/expander sin cerrar del todo: **toggle highlights sidebar** *(toggle-highlights-sidebar)*.

Ubicación lateral default controlada en Settings del núcleo (clave `highlights.sidebarPosition` típica).

## Trabajar dentro del sidebar

Pasos generales (adaptá nombres según UI traducida):

1. **Tabs** superiores cambian entre vistas (p.ej. colecciones actuales vs resumen).
2. Lista de items: click abre nota origen y enfoca highlight.
3. Filtros/perPage: si tu build trae paginación (`perPage`) ajustala para performance en corpora grandes.

## Colecciones

Las colecciones viven en configuración Emic‑QDA (`highlights.collections`). Flujo usuario:

1. Desde UI del sidebar → acción **añadir a colección** (si está expuesta en tu versión) o vía comando contextual.
2. Nombra la colección nueva o elegí existente.
3. Luego usá comando dinámico **Go to {name}** generado por colección (lista en command palette filtrando “collection”).

Si no ves UI clara: alternativa operativa es crear **nota índice Markdown** con enlaces manuales hasta que expongan UI completa en tu build.

## Momentos recomendados del pipeline

| Momento | Para qué usarlo |
|---------|-----------------|
| Entre lectura y codificación | revisar highlights acumulados del día |
| Antes de extracción | agrupar evidencia candidata |
| Revisión por pares | colección “pendiente advisor” |

Referencias: [[04-Referencia-funcional/highlights]] • volver al mapa [[../00-Mapa-de-flujos]].
