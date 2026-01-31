---
name: nsis-installer-plan
overview: Plan para construir el instalador NSIS online con selección de vault y configuración de API keys usando el template de Obsidian existente.
todos:
  - id: repo-setup
    content: Definir estructura installer/ y config base NSIS
    status: completed
  - id: nsis-ui-flow
    content: "Diseñar páginas: componentes, vault name, API keys"
    status: completed
  - id: downloads
    content: Descargas online y ejecución de instaladores externos
    status: completed
  - id: vault-setup
    content: Descargar template, crear vault y aplicar keys
    status: completed
isProject: false
---

# Plan de instalador NSIS (online)

## Contexto clave del template

- Shell Commands guarda variables personalizadas (incluye `OpenAIKey` y `huggface`) en `data.json` del plugin, donde se actualizarán los valores capturados en el instalador. Ruta: [D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\.obsidian\plugins\obsidian-shellcommands\data.json](D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\.obsidian\plugins\obsidian-shellcommands\data.json).
- Copilot almacena `openAIApiKey` y `huggingfaceApiKey` en `data.json` del plugin. Ruta: [D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\.obsidian\plugins\copilot\data.json](D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\.obsidian\plugins\copilot\data.json).
- La mención del “keychain” de Obsidian está en la nota del template (no hay archivo directo a modificar). Ruta: [D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\LEAME.md](D:\Dropbox\Zettlekasten\Emic-QDA-Vault-Template\LEAME.md).

## Diseño del instalador (decisiones ya cerradas)

- Instalación **online**: descargar y ejecutar instaladores de terceros (Python/Obsidian/Zotero) durante el setup.
- **Zotero opcional** mediante componentes NSIS.
- **Ruta del vault** elegida por usuario + **nombre del vault** ingresado por el usuario.
- **API keys**: se piden en el instalador; si quedan vacías, se muestra advertencia con los 3 lugares donde configurarlas luego (Shell Commands variables, Copilot, Keychain).
- **Template del vault**: **empaquetado** dentro del instalador (no descarga).
- **Pip packages**: **empaquetados** dentro del instalador (whl y tar.gz de cada repo).
- **Python/Obsidian/Zotero**: se descargan online y se ejecutan durante el setup.
- **Assets exactos**:
- Template: `Template-v0.1.0.zip`
- OntologyExplorer: `ontology_explorer-0.1.1-py3-none-any.whl`, `ontology_explorer-0.1.1.tar.gz`
- ObsidianQDA-Suite: `obsidian_qda_suite-0.1.0-py3-none-any.whl`, `obsidian_qda_suite-0.1.0.tar.gz`

## Implementación en el repo

1. **Estructura del instalador**

- Crear carpeta `installer/` en el repo con:
- `installer/installer.nsi` (script principal NSIS).
- `installer/config.nsi` (URLs/versiones/paths y variables de build).
- `installer/pages/` para páginas custom (nombre de vault, API keys).
- Dejar todos los endpoints como variables para que puedas versionar sin tocar lógica.

2. **Variables de configuración (URLs y versiones)**

- Definir en `config.nsi`:
- URLs de instaladores: Python, Obsidian, Zotero.
- URLs **solo** para instaladores externos: Python, Obsidian, Zotero.
- El template del vault y los pip packages se incluyen como archivos en `installer/assets/`.

3. **Páginas NSIS**

- `MUI_PAGE_COMPONENTS` con Zotero opcional.
- `MUI_PAGE_DIRECTORY` para elegir carpeta base del vault.
- Página custom para **nombre del vault** (validación de caracteres inválidos y nombres reservados).
- Página custom para **API keys** (OpenAI / Hugging Face) y advertencia condicional si quedan vacías.

4. **Descarga y ejecución de instaladores externos**

- Usar `inetc::get` (o `NSISdl` si preferís) con:
- Descarga a `$TEMP\EmicQDA\`.
- Manejo de errores y reintentos.
- Validación de exit codes de los instaladores (`ExecWait`).
- Orden: Python → Obsidian → Zotero (si está seleccionado).

5. **Setup del entorno Python**

- Crear venv en el vault (`<vaultPath>\.venv`).
- Instalar paquetes pip desde `installer/assets/` usando `pip install --no-index --find-links`.

6. **Vault template**

- Copiar template desde `installer/assets/` al directorio elegido por el usuario y renombrar con el nombre elegido.
- Aplicar configuración de keys:
- Actualizar `openAIApiKey` y `huggingfaceApiKey` en Copilot.
- Actualizar variables `OpenAIKey` y `huggface` en Shell Commands.
- Si keys están vacías, mostrar advertencia y dejar valores en blanco.

7. **Mensajes y UX**

- Mensajes claros antes de abrir cada instalador externo.
- Mensaje final con recordatorio de configuración manual si las keys quedaron vacías (Shell Commands, Copilot, Keychain).

## Entregables

- Script NSIS compilable y parametrizado.
- Páginas custom para nombre de vault y API keys.
- Documentación breve en `installer/README.md` sobre cómo actualizar URLs/versiones.