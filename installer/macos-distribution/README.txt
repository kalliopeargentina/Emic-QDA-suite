Emic QDA — distribución macOS (.app + .dmg)
==========================================

Qué hay aquí
------------
• Emic QDA Installer.app   Plantilla del bundle (sin Contents/Resources hasta armar el paquete).
• build-dmg.sh             Script que se ejecuta en una Mac para copiar install.sh + assets y generar el DMG.

Requisitos
----------
• macOS (usa hdiutil).
• Bash.

Cómo generar el instalador
--------------------------
Desde la carpeta installer/macos-distribution en una Mac:

  chmod +x build-dmg.sh
  ./build-dmg.sh

Salida en dist/:
  • Emic QDA Installer.app (completo, con Resources)
  • Emic-QDA-Installer-macOS-<versión>-<build>.dmg

Uso final para el usuario
-------------------------
1. Descargar el .dmg
2. Abrirlo y hacer doble clic en «Emic QDA Installer»
3. Se abre Terminal con el asistente de instalación

Notas
-----
• Para firma y notarización Apple (menos avisos de Gatekeeper) necesitás cuenta de desarrollador; no está automatizado aquí.
• La versión en Info.plist se intenta alinear con installer/macos/install.sh vía PlistBuddy al construir.
