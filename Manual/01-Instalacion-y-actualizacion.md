# Instalación y actualización

## ¿Para qué sirve?
Instalar **EMIC Plus QDA** (instalador y/o plugins sueltos) y mantenerlo actualizado sin perder tu proyecto (vault).

## Requisitos
- **Obsidian** instalado (versión compatible con tus plugins según cada `manifest.json`).
- Una **carpeta de vault** donde trabajarás los datos del estudio.

## Instalación con el instalador (recomendado)
El instalador de la suite copia los plugins al vault y opcionalmente configura valores iniciales. El flujo típico es:

1. Cerrá Obsidian si te lo pide el instalador (para evitar archivos bloqueados).
2. Ejecutá el instalador como administrador sólo si la documentación del producto lo requiere.
3. elegí **el vault objetivo** (la carpeta donde está tu proyecto).
4. Confirmá los componentes (plugins incluidos) y terminá la instalación.
5. Abrí Obsidian → **Settings → Community plugins** y habilitá cada plugin instalado (`emic-qda`, `emic-reports`, etc.).

Si el instalador ofrece un **log** o pantalla final con rutas escritas en `.obsidian/plugins/`, guardala por si necesitás soporte.

## Instalación manual (sin instalador)

1. En el explorador de archivos, abrí:  
   `<TuVault>/.obsidian/plugins/`
2. Por cada plugin, creá una carpeta cuyo nombre coincida con el **id del plugin** (por ejemplo `emic-qda`, `emic-reports`, `emic-charts-view`, `emic-camera`, según cada `manifest.json`).
3. Copiá dentro de esa carpeta los artefactos de release:
   - `main.js`
   - `manifest.json`
   - `styles.css` (si viene en la release).
4. En Obsidian: **Settings → Community plugins → Installed plugins** → habilitá el plugin.
5. **Reload**: **Ctrl+R** o menú equivalente si no aparecen comandos hasta reiniciar.

## Actualización
- Con **installer**: volvé a ejecutar la nueva versija apuntando al mismo vault y seguí las opciones para “overwrite” sólo donde corresponda.
- Manual: guardá backup del vault → reemplazá `main.js` / `manifest.json` / `styles.css` por los de la nueva release → recargá Obsidian.

Siempre revisá **`minAppVersion`** en `manifest.json` tras actualizar Obsidian.

## Desinstalación
1. Deshabilitá cada plugin en **Settings → Community plugins**.
2. (Opcional) Borrá la carpeta `<vault>/.obsidian/plugins/<plugin-id>/`.
3. El contenido analítico (notas en `Datos`, `Extractions`, etc.) **no se borra** salvo que lo hagas vos a mano.

## Notas para equipos multi-plataforma
- Windows / macOS / Linux: rutas diferentes; Obsidian usa siempre `.obsidian` dentro del vault.
- Mantener versiones **alineadas** de Obsidian entre integrantes reduce diferencias bug.

Problemas: ver [[05-Troubleshooting]].
