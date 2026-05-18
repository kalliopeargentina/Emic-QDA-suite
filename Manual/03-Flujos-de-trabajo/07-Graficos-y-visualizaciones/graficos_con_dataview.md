# Gráficos — Dataview / Dataviewjs como fuente

## ¿Para qué sirve?
Conectar tus **consultas dinámicas** (counts por carpeta/tag, líneas temporales desde frontmatter) con **Emic Charts View** usando `data: "dataview:..."` o un bloque `dataviewjs:` incrustado en el YAML como fuente (según patrón soportado por la versión instalada).

## Requisitos
- Plugin community **Dataview** habilitado (y familiaridad básica con su sintaxis).

## Patrón `dataview:` inline (ejemplo conceptual)

Muchas configuraciones siguen líneas:

```yaml
type: Line
data: "dataview: TABLE fecha, count WHERE ... "
```

Adaptá la parte `TABLE …` según tus campos (`file.name`, `#tag`, etc.). El compilador ejecuta mediante API limitada lista blanca (`dv.pages`, `dv.current`, …) — errores muestran en consola de Obsidian *Developer Tools* si algo no está permitido.

## Patrón `dataviewjs` en bloque (si aplicás)

Consultá ejemplo template “Dataviewjs Example” insertado desde [[crear_graficos_con_templates]] y modifica el retorno `{ ... }`.

## Cuándo NO conviene Dataview aquí

- Si la consulta cambia muy seguido y rompe reproducibilidad de figuras formales para paper — exportá antes a CSV estable [[../06-Tablas-y-csv/exportar_tablas_markdown_a_csv]].

## Debugging rápido

1. Probá primero tu query sólo dentro de bloque estándar `dataview` normal en nota aparte hasta que tabla sea estable.
2. Copiá lógica mínima a la cadena dentro de `emic-charts-view`.

Documentación sintaxis oficial Dataview está fuera alcance pero patrón de uso acá mismo.
