# Emic QDA Installer (NSIS)

## Requisitos
- NSIS 3.x (`NSISdl` incluido por defecto).
- `makensis` en el PATH o usar ruta completa.

## Assets locales (obligatorios)
Colocar estos archivos en `installer/assets/`:
- `Emic-Splash.bmp` — opcional: imagen del splash (BMP, JPG o GIF). Solo si definís `INCLUDE_SPLASH` en `config.nsi`. Usa el plugin [NewAdvSplash](https://nsis.sourceforge.io/NewAdvSplash_plug-in).
- `Template-v0.1.0.zip`
- `ontology_explorer-0.1.1-py3-none-any.whl`
- `ontology_explorer-0.1.1.tar.gz`
- `obsidian_qda_suite-0.1.0-py3-none-any.whl`
- `obsidian_qda_suite-0.1.0.tar.gz`

## Compilar
Desde `installer/`:
```
makensis installer.nsi
```

## Configuración
Editar `installer/config.nsi` para actualizar URLs y versiones de:
- Python
- Obsidian
- Zotero
