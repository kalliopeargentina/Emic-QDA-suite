!define PYTHON_VERSION "3.12.10"
!define PYTHON_URL "https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe"
!define PYTHON_INSTALLER "python-3.12.10-amd64.exe"

!define OBSIDIAN_VERSION "1.11.5"
!define OBSIDIAN_URL "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.11.5/Obsidian-1.11.5.exe"
!define OBSIDIAN_INSTALLER "Obsidian-1.11.5.exe"

!define ZOTERO_URL "https://www.zotero.org/download/client/dl?channel=release&platform=win-x64"
; Nombre del instalador: fijo "Zotero_setup.exe" en installer.nsi (no depende de la versión devuelta por el servidor)

; Versión del suite (ej. 1.0.0) y build (ej. fecha-hora). El .exe se nombra Emic-QDA-Installer-<VERSION>-<BUILD>.exe
!define VERSION "0.5.7"
!define BUILD "2026-03-29"

!define PY_LAUNCHER "py"
!define PY_MAJOR "3.12"
; Versiones de Python que se consideran "ya instalado" (la salida de py --version debe contener una de estas; separadas por espacio)
!define PYTHON_VERSIONS_ACCEPTED "3.12 3.13 3.14 3.15 3.16"

; Directorio del template (descomprimido): poner la carpeta en installer/assets/template/
; Debe contener la raíz del vault (ej. .obsidian, README, etc.) directamente dentro.
!define TEMPLATE_DIR "template"
!define ONTOLOGY_WHL "ontology_explorer-0.1.1-py3-none-any.whl"
!define QDA_WHL "obsidian_qda_suite-0.1.4-py3-none-any.whl"

; Incluir ffmpeg: poné la carpeta ffmpeg (con subcarpeta bin) en installer/assets/ffmpeg/
; Comentá la línea siguiente si no incluís los binarios en esta build.
!define INCLUDE_FFMPEG

; Descomentar para que las ventanas de PowerShell esperen Enter en error (depuración)
; !define POWERSHELL_PAUSE_ON_ERROR

; Splash al iniciar (NewAdvSplash). Imagen: assets\Emic-Splash.bmp (BMP, o JPG/GIF). Comentá si no usás splash.
!define INCLUDE_SPLASH
