#!/bin/bash
# Ejecutar SOLO en macOS. Arma Emic QDA Installer.app (con install.sh + assets) y crea un .dmg comprimido.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MACOS_DIR="$INSTALLER_DIR/macos"
ASSETS_SRC="$INSTALLER_DIR/assets"
TEMPLATE_APP="$SCRIPT_DIR/Emic QDA Installer.app"

DIST_DIR="$SCRIPT_DIR/dist"
APP_OUT="$DIST_DIR/Emic QDA Installer.app"

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "Este script solo puede crear el .dmg en macOS (hdiutil)." >&2
	exit 1
fi

if [[ ! -f "$MACOS_DIR/install.sh" ]]; then
	echo "No se encontró $MACOS_DIR/install.sh" >&2
	exit 1
fi
if [[ ! -d "$ASSETS_SRC" ]]; then
	echo "No se encontró $ASSETS_SRC" >&2
	exit 1
fi
if [[ ! -d "$TEMPLATE_APP" ]]; then
	echo "No se encontró la plantilla: $TEMPLATE_APP" >&2
	exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

echo "Copiando plantilla .app..."
cp -R "$TEMPLATE_APP" "$DIST_DIR/"

echo "Copiando install.sh y assets → Contents/Resources..."
mkdir -p "$APP_OUT/Contents/Resources"
cp "$MACOS_DIR/install.sh" "$APP_OUT/Contents/Resources/"
cp -R "$ASSETS_SRC" "$APP_OUT/Contents/Resources/assets"

chmod +x "$APP_OUT/Contents/MacOS/emicqda-installer"
chmod +x "$APP_OUT/Contents/Resources/install.sh"

# Sincronizar versión corta en Info.plist con install.sh (opcional, best-effort)
VER=$(grep '^VERSION=' "$MACOS_DIR/install.sh" | head -1 | sed 's/^VERSION=//;s/"//g')
if [[ -n "$VER" ]] && command -v /usr/libexec/PlistBuddy >/dev/null 2>&1; then
	/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VER" "$APP_OUT/Contents/Info.plist" 2>/dev/null || true
fi

BUILD=$(grep '^BUILD=' "$MACOS_DIR/install.sh" | head -1 | sed 's/^BUILD=//;s/"//g')
DMG_NAME="Emic-QDA-Installer-macOS-${VER:-0}-${BUILD:-0}.dmg"
DMG_PATH="$DIST_DIR/$DMG_NAME"

echo "Creando DMG: $DMG_NAME"
rm -f "$DMG_PATH"
hdiutil create -volname "Emic QDA Installer" -srcfolder "$APP_OUT" -ov -format UDZO "$DMG_PATH"

echo ""
echo "Listo:"
echo "  App: $APP_OUT"
echo "  DMG: $DMG_PATH"
echo ""
echo "Para distribuir: subí el .dmg o entregalo tal cual. El usuario abre el DMG y hace doble clic en «Emic QDA Installer»."
