# Emic QDA Installer (NSIS)

<div align="center" style="background-color:#125d98; border-radius: 14px; padding: 18px 0; margin-bottom: 16px;">
  <img src="https://emic-consultora.com.ar/_assets/media/019ca9bc8f05f14410054b389468cb46.png" alt="Emic QDA logo" width="500"/>
</div>


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

**Importante:** al pegar comandos en PowerShell, pegá solo la línea del comando (ej. `.\build-and-sign.ps1`), no el prompt `PS ...>` ni la salida anterior, o PowerShell intentará ejecutar todo y dará errores.

## Firmar el instalador (opcional)
Para firmar el .exe con un certificado (reduce retrasos de UAC/SmartScreen):

1. **Requisitos:** Windows SDK instalado (para `signtool.exe`). Certificado en .pfx (self-signed o de una CA).

2. **Primera vez — certificado autofirmado:** desde `installer/` en PowerShell:
   ```powershell
   .\create-signing-cert.ps1
   ```
   Crea el certificado, lo exporta a `installer/EmicQDA-CodeSign.pfx` y te muestra los comandos para las variables de entorno.

3. **Variables de entorno** (una sola vez por sesión, o en el perfil):
   ```powershell
   $env:SIGNING_PFX_PATH   = "C:\ruta\EmicQDA-CodeSign.pfx"
   $env:SIGNING_PFX_PASSWORD = "tu_contraseña"
   ```

4. **Compilar y firmar en un solo paso:**
   ```powershell
   cd installer
   .\build-and-sign.ps1
   ```
   Para solo compilar sin firmar: `.\build-and-sign.ps1 -SkipSign`

5. **Solo firmar** (si ya tenés el .exe generado):
   ```powershell
   .\sign-installer.ps1
   ```
   Por defecto firma el `Emic-QDA-Installer-*.exe` más reciente en esta carpeta. Para otro archivo: `.\sign-installer.ps1 -ExePath ".\ruta\al\instalador.exe"`

## Configuración
Editar `installer/config.nsi` para actualizar URLs y versiones de:
- **VERSION** y **BUILD** — versión del suite y build (el .exe se nombra `Emic-QDA-Installer-<VERSION>-<BUILD>.exe`)
- Python
- Obsidian
- Zotero
