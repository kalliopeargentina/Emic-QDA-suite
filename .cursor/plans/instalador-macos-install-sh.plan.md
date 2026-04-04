# Plan: instalador macOS en carpeta separada de `installer/`

## Objetivo

Tener un **árbol propio** para el instalador macOS que **no comparta** rutas ni convenciones con el NSIS de Windows (`installer/`). El paquete que se distribuye (`.tar.gz` / `.zip`) se arma **solo** desde esa carpeta.

## Carpeta nueva en el repo

Sugerencia de nombre: [`macos-installer/`](macos-installer/) en la raíz del repositorio (junto a `installer/`, no dentro).

Estructura objetivo (la misma que describiste para distribución, viviendo en el repo):

```text
macos-installer/
├── install.sh              # script principal
├── assets/
│   ├── terms.txt           # copia (réplica) de installer/assets/terms.txt
│   ├── template/           # réplica del vault template (mismo contenido que installer/assets/template/)
│   ├── ontology_explorer-0.1.1-py3-none-any.whl
│   ├── obsidian_qda_suite-0.1.4-py3-none-any.whl
│   └── ffmpeg/             # opcional, si INCLUDE_FFMPEG en el script
```

- **No** se añade nada bajo `installer/` para macOS.
- El script usa siempre `ASSETS_DIR="$SCRIPT_DIR/assets"` (sin heurística `../assets`).

## Qué “replicar” y cómo mantenerlo

| Contenido | Origen actual en el repo | Notas |
|-----------|---------------------------|--------|
| `terms.txt` | [`installer/assets/terms.txt`](installer/assets/terms.txt) | Copia literal al publicar o al preparar release; si cambia el legal, actualizar ambos o automatizar copia en CI. |
| `template/` | [`installer/assets/template/`](installer/assets/template/) | Misma réplica que empaqueta el NSIS. |
| Wheels | [`installer/assets/*.whl`](installer/assets/) | Mismos nombres que [`installer/config.nsi`](installer/config.nsi). |
| `ffmpeg/` | [`installer/assets/ffmpeg/`](installer/assets/ffmpeg/) | Solo si la build macOS incluye binarios; mismo criterio que `INCLUDE_FFMPEG` en NSIS. |

Opcional más adelante: un script `macos-installer/sync-from-windows-installer.ps1` o `.sh` que copie `terms.txt`, `template`, wheels y ffmpeg desde `installer/assets/` hacia `macos-installer/assets/` para no editar a mano (fuera del alcance mínimo si no lo pedís).

## Configuración

- Variables bash al inicio de `install.sh` (o `config.sh` incluido con `source`) con **los mismos valores semánticos** que [`installer/config.nsi`](installer/config.nsi) (URLs macOS, `VERSION`, `BUILD`, wheels, `PYTHON_VERSIONS_ACCEPTED`, flag `INCLUDE_FFMPEG`).
- Comentario en `install.sh`: al cambiar versiones, alinear con `config.nsi`.

## Comportamiento del script

Sin cambios respecto al plan funcional ya acordado: detección (Obsidian, Zotero, Python ≥ lista, FFmpeg), términos, menú de componentes en terminal, `osascript` + `defaults` para `INSTDIR`, nombre de vault + validación macOS, descargas (`.pkg`, DMG), copia template, venv en `$INSTDIR/.venv`, pip, log en `$INSTDIR`, plist `ar.emic-qda`, apertura `obsidian://`, traps y colores.

## Empaquetado para el usuario final

Comprimir la carpeta `macos-installer/` (o renombrar a `Emic-QDA-Installer-macOS` solo en el zip) de forma que quede `install.sh` y `assets/` en la raíz del archivo.

## Criterios de aceptación (actualizados)

- Todo el instalador macOS vive bajo `macos-installer/`; **`installer/` solo NSIS**.
- `install.sh` asume `assets` como subcarpeta del script.
- Contenido de `assets/` es autosuficiente para correr el instalador sin leer `installer/`.

## Tareas de implementación

1. Crear árbol `macos-installer/` con `install.sh` y `assets/` (réplicas de terms, template, wheels; ffmpeg opcional).
2. Implementar `install.sh` según el flujo ya definido (detección, UI, descargas, vault, venv, log, plist).
3. Documentar en un comentario al tope de `install.sh` (o en README solo si lo pedís) cómo volver a copiar assets desde `installer/assets` cuando cambien.
