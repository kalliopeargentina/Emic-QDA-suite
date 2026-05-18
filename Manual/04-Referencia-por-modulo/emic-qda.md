# Referencia por módulo — Emic‑QDA (núcleo QDA)

## Qué hace
Plugin central de **codificación**, **dominios/entidades**, **extracciones**, **highlights sidebar**, comandos auxiliares de lectura de corpus e integración **bridge** opcional.

## Comandos (grupos)

| Grupo | Ejemplos |
|-------|----------|
| Coding | assign/rename/merge/split codes, relations, exports, code overview |
| Entities / Domain | crear dominio, tipos, extraer entidades/relaciones, validar, export KG |
| Extractions | extract, merge, exports csv/json, type overview |
| Auxiliary | random unread, progress, mark read |
| Highlights sidebar | open/toggle + colecciones dinámicas |

Nombres exactos dependen del idioma en settings del plugin (`language: auto|es|…`).

## Ajustes típicos (`Settings → Emic‑QDA`)

- `coding.folder`, `coding.storageRoot`, `activeCodebookId`, orden y conteos.
- `extraction.folder`, `extraction.storageRoot`, separador CSV, comportamiento de merge.
- `entity.folder`, `entity.storageRoot`, `activeDomainId`, calidad (`maxUnderdeterminedRatio`).
- `bridge.*` opcional.
- `highlights.*` sidebar, colecciones, colores.

## Notas de plataforma
- Mobile: muchos comandos registran también **toolbar** icon según build.
- Desktop: experiencia completa en modals complejos.

Ver flujos: [[../03-Flujos-de-trabajo/00-Mapa-de-flujos]].
