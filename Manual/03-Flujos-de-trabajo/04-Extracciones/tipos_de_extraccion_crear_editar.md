# Núcleo QDA — Tipos de extracción: crear y editar

## ¿Para qué sirve?
Definir la **plantilla** de una extracción: qué atributos tiene cada registro (campos) y cómo se presenta al usuario al extraer desde un párrafo. Sin tipos no hay extracción estructurada coherente.

## Resultado (qué obtenés)
- Un **tipo de extracción** disponible en el selector al ejecutar **Extract from paragraph**.
- (Opcional) Vista de resumen de tipos — comando **Show extraction type overview** / resumen de tipos.

## Pasos — crear un tipo nuevo

1. Command palette → **Create new Extraction Type** (o nombre traducido).
2. Definí identificador y atributos según el formulario/modal que abra Emic‑QDA.
3. Guardá/aplicá.
4. Probá rápido creando extracción de prueba vía [[extracciones_crear_desde_parrafo]] en un párrafo dummy.

## Pasos — ver/editar existentes

1. Command palette → **Show extraction type overview** para localizar rápidamente plantillas/templates.
2. Para borrar tipo no usado: **Delete Extraction Type** (ojo con registros derivados ya creados — confirmá comportamiento en pantalla antes de borrar).

## Mantenimiento después de campo

Cuando tus categorías cambian tras iteración inductiva:

- creá nuevo tipo mejorado **o**
- documentá campo extra en mismo tipo sólo si el plugin lo permite desde UI sin romper registros históricos.

## Buenas prácticas

| Práctica | Motivo |
|----------|--------|
| Pocos tipos claros mejor que demasiados | Evita dispersión CSV final. |
| Nombres de atributos estables antes de recolectar en serio | Menos refactoring de registros más adelante. |
| Probá tipo con 5 extracciones reales antes de recolectar 200 | Revela campos faltantes. |

Siguientes pasos: [[extracciones_crear_desde_parrafo]] • [[extracciones_exportar]] • referencia [[04-Referencia-funcional/extracciones]].
