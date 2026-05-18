# Referencia funcional — Emic Charts View (bloque `emic-charts-view`)

Renderiza gráficos **Ant Design Charts** desde un bloque Markdown:

````markdown
```emic-charts-view
type: Bar
data: ...
options: ...
```
````

### Fuentes `data` comunes

| Patrón | Descripción |
|--------|-------------|
| `"archivo.csv"` | CSV bajo carpeta `dataPath` settings |
| `"a.csv, b.csv"` | Múltiples CSV (p.ej. DualAxes) |
| `wordcount:...` | Conteo por nota/carpeta/vault |
| `dataview:...` | Query Dataview embebida (subset API) |
| Import externo | Comando desktop inserta array YAML |

### Temas

`default`, `dark`, `emicDark`, `emicLight` + `backgroundColor` y paddings en settings/YAML.

### Interacción búsqueda

`options.enableSearchInteraction` puede mapear click de elemento a busqueda Obsidian (operadores según implementación).

### Export PNG

Botón si `showExportBtn` o API programática (integraciones).

Flujos: carpeta `07-Graficos-y-visualizaciones/`.
