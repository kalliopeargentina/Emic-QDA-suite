# Organización y seguimiento — Datafiles leídos y archivo de progreso

## ¿Para qué sirve?
Registrar avance de revisión del **corpus fuente** (“ya leí/analicé esta nota”) y consultar un archivo de **progreso** agregado cuando el proyecto es grande.

## Resultado (qué obtenés)
- Propiedad/estado visible en datafile (campo `read` o equivalente en tu plantilla demo).
- Vista o archivo `progress` (`Análisis/progress` mencionado en [[01-Interfase-de-usuario]]) cuando generás reportes de avance.

## Marcar el datafile actual como leído

1. Abrí el documento fuente (típicamente bajo *Datos / Documentos* o flujo equivalente).
2. Command palette → **Mark current Data File as read**.
3. Observá el cambio en propiedades/frontmatter (campo `read: true` típico según plantillas del video).

> Si tu plantilla distingue niveles (revisado / codificado / extraído), podés combinar un tag adicional manual (`#pendiente-codigo`) hasta que exista automatismo.

## Abrir el archivo de progreso

Command palette → **Show data analysis progress file** (*show-progress*).

Te lleva al JSON o nota de progreso donde el entorno consolida estado (depende de tus pipelines de análisis automatizados instalados).

## Abrir un documento al azar pendiente (exploración estratificada opcional)

Si usás muestreo intencionalmente:

Command palette → **Open random unread Data File** (*open-random-unread-datafile*).

## Interpretación pedagógica

| Indicador | Significa (operativo) |
|-----------|------------------------|
| Documento sin `read` | Aún no marcado como revisado base |
| Progress file | Avance batch de rutinas (LDA, topics, etc.) — no confundir con “leído humano” |

## Problemas comunes

| Síntoma | Revisar |
|---------|---------|
| Comando no aparece | Cursor no en nota considerada datafile por plugin |
| `read` no persiste | Falta frontmatter en plantilla o archivo no es markdown estándar |

Mapa: [[../00-Mapa-de-flujos]].
