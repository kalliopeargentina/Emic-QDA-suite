# Gráficos — Exportar a PNG

## ¿Para qué sirve?
Guardar el render del chart como imagen raster **PNG** para informes externos, slides o anexo en nota.

## Resultado (qué obtenés)
- Archivo `<tipo>.png` descargado vía flujo del navegador/Obsidian.

## Vía UI (usuario final)

1. Settings → Emic Charts View → activá **Show Export Button**.
2. Abrí nota en modo lectura/preview donde el chart renderiza.
3. Sobre el chart aparece overlay/botón **Export to PNG**.
4. Click → descarga.

## Vía API (solo si sos desarrollador de otro plugin)

```ts
const api = app.plugins.plugins["emic-charts-view"]?.api;
await api.exportPngFromElement(hostEl);
```

Errores posibles (según implementación): `no-chart`, `multiple-charts`, `not-ready`. El manual de usuario final **no requiere** exponer esto; documentado para integraciones internas.

## Limitaciones

- El chart debe estar **renderizado** (no exportes nota recién recargada sin esperar paint completo).
- Temas oscuros → fondo transparente vs opaco según `backgroundColor` en settings/YAML.

Ver contexto: [[04-Referencia-funcional/charts_view]].
