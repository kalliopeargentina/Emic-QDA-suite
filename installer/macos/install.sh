#!/bin/bash
# Emic QDA Suite — instalador macOS (paridad funcional con installer.nsi + config.nsi).
# Obsidian/Zotero: brew install --cask (evita DMG x86 y Rosetta en Apple silicon). Python/FFmpeg: fórmulas brew. config.nsi = Windows.
# shellcheck disable=SC2317  # funciones llamadas desde traps o indirectamente

set -euo pipefail

# --- Config (paridad funcional con installer.nsi; este script es macOS — config.nsi es Windows) ---
# Python: vía Homebrew (python@3.12), no .pkg ni .exe.
PYTHON_VERSION_LABEL="3.12 (Homebrew python@3.12)"

# Referencia respecto al instalador Windows (NSIS); en Mac el cask suele ser la última estable.
OBSIDIAN_VERSION_REF="1.12.7"

VERSION="0.5.7"
BUILD="2026-03-30"

PYTHON_VERSIONS_ACCEPTED="3.12 3.13 3.14 3.15 3.16"
TEMPLATE_DIR="template"
ONTOLOGY_WHL="ontology_explorer-0.1.1-py3-none-any.whl"
QDA_WHL="obsidian_qda_suite-0.1.4-py3-none-any.whl"
# 1 = instalar ontology_explorer (paridad con !define INCLUDE_ONTOLOGY_EXPLORER en config.nsi). 0 = omitir hasta que el wheel esté listo.
INCLUDE_ONTOLOGY_EXPLORER=0

# FFmpeg en macOS: solo vía Homebrew (no bundle estilo Windows INCLUDE_FFMPEG).

PREFERENCES_DOMAIN="ar.emic-qda"

# --- Rutas ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -d "$SCRIPT_DIR/assets" ]]; then
  ASSETS_DIR="$(cd "$SCRIPT_DIR/assets" && pwd)"
elif [[ -d "$SCRIPT_DIR/../assets" ]]; then
  ASSETS_DIR="$(cd "$SCRIPT_DIR/../assets" && pwd)"
else
  echo "Error: no se encontró la carpeta assets junto a este script ni en ../assets." >&2
  exit 1
fi

TMP_ROOT="${TMPDIR:-/tmp}/EmicQDA-${BUILD}"
mkdir -p "$TMP_ROOT"
MOUNTED_VOLS=()
PYTHON3_CMD=""
LOG_FILE=""

# Estado de detección (0 = no, 1 = sí)
HAVE_OBSIDIAN=0
HAVE_ZOTERO=0
HAVE_PYTHON=0
HAVE_FFMPEG=0

# Selección de instalación
INSTALL_PYTHON=0
INSTALL_OBSIDIAN=0
INSTALL_ZOTERO=0
INSTALL_FFMPEG_BREW=0

INSTDIR=""
VAULT_NAME=""
VAULT_PATH=""
OVERWRITE_VAULT=0

# --- Colores ---
if [[ -n "${NO_COLOR:-}" ]] || ! command -v tput >/dev/null 2>&1 || [[ "$(tput colors 2>/dev/null || echo 0)" -lt 8 ]]; then
  C_INFO=""
  C_WARN=""
  C_ERR=""
  C_RESET=""
else
  C_INFO=$'\033[0;36m'
  C_WARN=$'\033[0;33m'
  C_ERR=$'\033[0;31m'
  C_RESET=$'\033[0m'
fi

info() { echo "${C_INFO}[info]${C_RESET} $*"; }
warn() { echo "${C_WARN}[aviso]${C_RESET} $*" >&2; }
err() { echo "${C_ERR}[error]${C_RESET} $*" >&2; }

log_init() {
  LOG_FILE="$1"
  {
    echo "=== Emic QDA Suite instalador macOS ==="
    echo "build=${BUILD} version=${VERSION}"
    echo "script=${SCRIPT_DIR}"
    echo "assets=${ASSETS_DIR}"
    echo "fecha=$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo "----------------------------------------"
  } >>"$LOG_FILE"
}

log() {
  local line="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  if [[ -n "$LOG_FILE" ]]; then
    echo "$line" >>"$LOG_FILE"
  fi
  info "$*"
}

cleanup() {
  local st=$?
  local m
  # Con set -u, "${arr[@]}" vacío puede fallar en algunas versiones de bash.
  for m in "${MOUNTED_VOLS[@]+"${MOUNTED_VOLS[@]}"}"; do
    [[ -n "$m" ]] || continue
    hdiutil detach "$m" -quiet 2>/dev/null || true
  done
  rm -rf "$TMP_ROOT" 2>/dev/null || true
  exit "$st"
}

trap cleanup EXIT INT TERM

die() {
  err "$1"
  [[ -n "$LOG_FILE" ]] && log "ABORT: $1"
  exit "${2:-1}"
}

prompt_yn() {
  local def="${3:-n}"
  local p="$1"
  [[ "$def" == "y" ]] && p="$p [S/n]: " || p="$p [s/N]: "
  local r
  read -r -p "$p" r || true
  r=$(echo "${r:-}" | tr '[:upper:]' '[:lower:]')
  if [[ -z "$r" ]]; then
    [[ "$def" == "y" ]]
    return
  fi
  [[ "$r" == "s" || "$r" == "si" || "$r" == "sí" || "$r" == "y" || "$r" == "yes" ]]
}

# --- Detección ---
obsidian_detect() {
  if [[ -d "/Applications/Obsidian.app" ]]; then
    return 0
  fi
  local p
  p=$(mdfind "kMDItemCFBundleIdentifier == 'md.obsidian'" 2>/dev/null | head -1)
  [[ -n "$p" && -d "$p" ]]
}

zotero_detect() {
  if [[ -d "/Applications/Zotero.app" ]]; then
    return 0
  fi
  local p
  p=$(mdfind "kMDItemCFBundleIdentifier == 'org.zotero.zotero'" 2>/dev/null | head -1)
  [[ -n "$p" && -d "$p" ]]
}

python_version_accepted() {
  local out="$1"
  local v
  for v in $PYTHON_VERSIONS_ACCEPTED; do
    if echo "$out" | grep -qF "$v"; then
      return 0
    fi
  done
  return 1
}

find_python3_candidates() {
  brew_shellenv 2>/dev/null || true
  local -a c=(
    "$(command -v python3 2>/dev/null || true)"
    /opt/homebrew/bin/python3
    /usr/local/bin/python3
  )
  local py312
  for py312 in /opt/homebrew/opt/python@3.12/bin/python3.12 /usr/local/opt/python@3.12/bin/python3.12; do
    [[ -x "$py312" ]] && c+=("$py312")
  done
  local fw
  for fw in /Library/Frameworks/Python.framework/Versions/*/bin/python3; do
    [[ -x "$fw" ]] && c+=("$fw")
  done

  local seen p
  for p in "${c[@]}"; do
    [[ -n "$p" && -x "$p" ]] || continue
    if [[ "$seen" != *"|$p|"* ]]; then
      echo "$p"
      seen="${seen}|$p|"
    fi
  done
}

detect_python3_cmd() {
  PYTHON3_CMD=""
  local p out
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    out=$("$p" --version 2>&1) || continue
    if python_version_accepted "$out"; then
      PYTHON3_CMD="$p"
      return 0
    fi
  done < <(find_python3_candidates)
  return 1
}

ffmpeg_in_path_detect() {
  local ffmpeg ffprobe
  ffmpeg=$(command -v ffmpeg 2>/dev/null) || return 1
  ffprobe=$(command -v ffprobe 2>/dev/null) || return 1
  [[ -n "$ffmpeg" && -n "$ffprobe" ]]
}

ffmpeg_path_segments_detect() {
  local IFS=':'
  local -a segments
  read -r -a segments <<<"${PATH:-}"
  local dir ffmpeg_exe ffprobe_exe
  for dir in "${segments[@]}"; do
    dir="${dir//[$'\t\r\n']}"
    [[ -z "$dir" ]] && continue
    echo "$dir" | grep -qi ffmpeg || continue
    ffmpeg_exe="${dir%/}/ffmpeg"
    ffprobe_exe="${dir%/}/ffprobe"
    if [[ -x "$ffmpeg_exe" && -x "$ffprobe_exe" ]]; then
      return 0
    fi
  done
  return 1
}

run_detection() {
  if obsidian_detect; then HAVE_OBSIDIAN=1; else HAVE_OBSIDIAN=0; fi
  if zotero_detect; then HAVE_ZOTERO=1; else HAVE_ZOTERO=0; fi
  if detect_python3_cmd; then HAVE_PYTHON=1; else HAVE_PYTHON=0; fi
  if ffmpeg_in_path_detect || ffmpeg_path_segments_detect; then HAVE_FFMPEG=1; else HAVE_FFMPEG=0; fi
}

brew_shellenv() {
  # En Apple silicon, NO cargar solo /usr/local/bin/brew: suele ser Homebrew “Intel” y los bottles son x86_64 → Rosetta.
  if [[ "$(uname -m)" == "arm64" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    return 0
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

run_homebrew_install_script() {
  log "Instalando Homebrew (instalador oficial; puede pedir contraseña de administrador)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >>"$LOG_FILE" 2>&1 || die "La instalación de Homebrew falló. Revisá el log: ${LOG_FILE:-}"
  brew_shellenv
  hash -r 2>/dev/null || true
}

ensure_homebrew() {
  brew_shellenv

  if [[ "$(uname -m)" == "arm64" ]] && [[ -x /usr/local/bin/brew ]] && [[ ! -x /opt/homebrew/bin/brew ]]; then
    warn "Este Mac es Apple silicon pero solo hay Homebrew en /usr/local (típico de Intel). Usarlo suele instalar software x86_64 y macOS pide Rosetta."
    if ! prompt_yn "¿Instalar Homebrew nativo en /opt/homebrew? (recomendado; puede convivir con el de /usr/local)" "" "y"; then
      die "En Apple silicon este instalador necesita Homebrew en /opt/homebrew. Instalación: https://docs.brew.sh/Installation"
    fi
    run_homebrew_install_script
  fi

  brew_shellenv
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew: $(command -v brew)"
    return 0
  fi

  warn "No se encontró Homebrew en el PATH."
  if ! prompt_yn "¿Instalar Homebrew ahora? (necesario para Python, FFmpeg, Obsidian y Zotero con este asistente)" "" "y"; then
    die "Se requiere Homebrew. Podés instalarlo desde https://brew.sh o instalar los componentes por tu cuenta."
  fi

  run_homebrew_install_script
  if ! command -v brew >/dev/null 2>&1; then
    die "Homebrew se instaló pero no está en el PATH de esta sesión. Cerrá Terminal, abrí una nueva y ejecutá de nuevo el instalador (o seguí las instrucciones que mostró el instalador de Homebrew)."
  fi
}

# --- Términos ---
show_terms() {
  local terms="$ASSETS_DIR/terms.txt"
  [[ -f "$terms" ]] || die "No se encontró $terms"
  info "Mostrando términos y condiciones..."
  if command -v less >/dev/null 2>&1; then
    less "$terms" || true
  else
    cat "$terms"
  fi
  echo
  prompt_yn "¿Aceptás los términos y condiciones para continuar?" "" "n" || die "Instalación cancelada (términos no aceptados)." 2
}

# --- Menú de componentes ---
components_plan() {
  INSTALL_PYTHON=0
  INSTALL_OBSIDIAN=0
  INSTALL_ZOTERO=0
  INSTALL_FFMPEG_BREW=0

  if [[ "$HAVE_PYTHON" -eq 0 ]]; then INSTALL_PYTHON=1; fi
  if [[ "$HAVE_OBSIDIAN" -eq 0 ]]; then INSTALL_OBSIDIAN=1; fi
  if [[ "$HAVE_ZOTERO" -eq 0 ]]; then INSTALL_ZOTERO=1; fi
  if [[ "$HAVE_FFMPEG" -eq 0 ]]; then INSTALL_FFMPEG_BREW=1; fi

  echo
  info "Componentes:"
  if [[ "$HAVE_OBSIDIAN" -eq 1 ]]; then
    echo "  [ya instalado] Obsidian"
  else
    echo "  [  instalar   ] Obsidian (Homebrew cask)"
  fi
  if [[ "$HAVE_PYTHON" -eq 1 ]]; then
    echo "  [ya instalado] Python (${PYTHON_VERSIONS_ACCEPTED// /, })"
  else
    echo "  [  instalar   ] Python ${PYTHON_VERSION_LABEL} (Homebrew)"
  fi
  if [[ "$HAVE_ZOTERO" -eq 1 ]]; then
    echo "  [ya instalado] Zotero (opcional)"
  else
    echo "  [  instalar   ] Zotero (opcional, Homebrew cask)"
  fi
  if [[ "$HAVE_FFMPEG" -eq 1 ]]; then
    echo "  [ya instalado] FFmpeg"
  else
    echo "  [  instalar   ] FFmpeg (Homebrew: brew install ffmpeg)"
  fi
  echo

  if [[ "$HAVE_ZOTERO" -eq 0 ]] && [[ "$INSTALL_ZOTERO" -eq 1 ]]; then
    prompt_yn "¿Instalar Zotero?" "" "y" || INSTALL_ZOTERO=0
  fi
  if [[ "$HAVE_FFMPEG" -eq 0 ]] && [[ "$INSTALL_FFMPEG_BREW" -eq 1 ]]; then
    prompt_yn "¿Instalar FFmpeg con Homebrew? (requiere Homebrew)" "" "y" || INSTALL_FFMPEG_BREW=0
  fi

  if ! prompt_yn "¿Continuar con la instalación con esta selección?" "" "y"; then
    die "Instalación cancelada por el usuario." 2
  fi
}

# --- Directorio de instalación ---
default_installdir() {
  echo "$HOME/Documents/Emic-QDA"
}

read_saved_installdir() {
  local s
  s=$(defaults read "$PREFERENCES_DOMAIN" InstallPath 2>/dev/null || true)
  echo "${s//$'\n'/}"
}

choose_installdir() {
  local saved def picked
  saved=$(read_saved_installdir)
  def="${saved:-$(default_installdir)}"

  picked=""
  if command -v osascript >/dev/null 2>&1; then
    picked=$(osascript 2>/dev/null <<'APPLESCRIPT'
try
  POSIX path of (choose folder with prompt "Elegí la carpeta donde instalar Emic QDA (se creará el vault y el entorno Python):")
on error number -128
  ""
end try
APPLESCRIPT
) || true
    picked="${picked//$'\r'/}"
    picked="${picked//$'\n'/}"
  fi
  if [[ -z "$picked" ]]; then
    warn "No se pudo usar el diálogo gráfico (¿sin GUI?). Ingresá la ruta manualmente."
    read -r -p "Ruta de instalación [${def}]: " picked || true
    picked="${picked:-$def}"
  fi
  INSTDIR="${picked%/}"
  [[ -n "$INSTDIR" ]] || die "Directorio de instalación vacío."
  mkdir -p "$INSTDIR" || die "No se pudo crear o acceder a: $INSTDIR"
  log_init "$INSTDIR/EmicQDA-install-${BUILD}.log"
  log "InstallPath=$INSTDIR"
}

# --- Vault ---
validate_vault_name() {
  local n="$1"
  [[ -n "$n" ]] || { err "Ingresá un nombre para el vault."; return 1; }
  if [[ "$n" == .* ]]; then
    warn "Los nombres que empiezan con punto pueden ser problemáticos; continuá solo si es intencional."
  fi
  if echo "$n" | grep -qE '[\\/:\*\?"<>\|]'; then
    err "Nombre de vault inválido. Evitá caracteres \\ / : * ? \" < > |"
    return 1
  fi
  return 0
}

prompt_vault_name() {
  local def="emicqda"
  local name=""
  if command -v osascript >/dev/null 2>&1; then
    name=$(osascript -e "text returned of (display dialog \"Nombre del vault:\" default answer \"${def}\" with title \"Emic QDA\")" 2>/dev/null) || true
    name="${name//$'\r'/}"
  fi
  if [[ -z "$name" ]]; then
    read -r -p "Nombre del vault [${def}]: " name || true
    name="${name:-$def}"
  fi
  validate_vault_name "$name" || exit 1
  VAULT_NAME="$name"
  VAULT_PATH="$INSTDIR/$VAULT_NAME"

  if [[ -e "$VAULT_PATH" ]]; then
    prompt_yn "La carpeta ya existe: $VAULT_PATH ¿Sobrescribirla?" "" "n" || die "Instalación cancelada." 2
    OVERWRITE_VAULT=1
  fi
  log "vault_name=$VAULT_NAME vault_path=$VAULT_PATH overwrite=$OVERWRITE_VAULT"
}

install_python_brew() {
  [[ "$INSTALL_PYTHON" -eq 1 ]] || return 0
  ensure_homebrew
  log "Instalando python@3.12 con Homebrew (brew install python@3.12)..."
  brew install python@3.12 >>"$LOG_FILE" 2>&1 || die "brew install python@3.12 falló. Revisá el log: $LOG_FILE"
  brew_shellenv
  hash -r 2>/dev/null || true
  if ! detect_python3_cmd; then
    die "Tras instalar python@3.12 no se detectó Python compatible (${PYTHON_VERSIONS_ACCEPTED}). Revisá el PATH o el log."
  fi
  HAVE_PYTHON=1
  log "Python detectado: $PYTHON3_CMD ($("$PYTHON3_CMD" --version 2>&1))"
}

install_obsidian_cask() {
  [[ "$INSTALL_OBSIDIAN" -eq 1 ]] || return 0
  ensure_homebrew
  log "Instalando Obsidian (brew install --cask obsidian; referencia Windows ${OBSIDIAN_VERSION_REF})..."
  brew install --cask obsidian >>"$LOG_FILE" 2>&1 || die "brew install --cask obsidian falló. Revisá el log: $LOG_FILE"
  HAVE_OBSIDIAN=1
}

install_zotero_cask() {
  [[ "$INSTALL_ZOTERO" -eq 1 ]] || return 0
  ensure_homebrew
  log "Instalando Zotero (brew install --cask zotero)..."
  brew install --cask zotero >>"$LOG_FILE" 2>&1 || die "brew install --cask zotero falló. Revisá el log: $LOG_FILE"
  HAVE_ZOTERO=1
}

install_ffmpeg_brew() {
  [[ "$INSTALL_FFMPEG_BREW" -eq 1 ]] || return 0
  ensure_homebrew
  log "Instalando ffmpeg con Homebrew (brew install ffmpeg)..."
  brew install ffmpeg >>"$LOG_FILE" 2>&1 || die "brew install ffmpeg falló. Revisá el log: $LOG_FILE"
  brew_shellenv
  hash -r 2>/dev/null || true
  if ! ffmpeg_in_path_detect; then
    warn "FFmpeg se instaló pero no aparece en el PATH de esta sesión. Cerrá y reabrí Terminal si hace falta."
  fi
  HAVE_FFMPEG=1
  log "FFmpeg: $(command -v ffmpeg 2>/dev/null || echo '(no en PATH)')"
}

# --- Vault + venv ---
copy_vault_template() {
  if [[ "$OVERWRITE_VAULT" -eq 1 ]] && [[ -e "$VAULT_PATH" ]]; then
    log "Eliminando vault existente en $VAULT_PATH"
    rm -rf "$VAULT_PATH"
  fi
  mkdir -p "$VAULT_PATH"
  local tpl="$ASSETS_DIR/$TEMPLATE_DIR"
  [[ -d "$tpl" ]] || die "No existe el template en $tpl"
  log "Copiando template del vault..."
  cp -R "$tpl/." "$VAULT_PATH/" || die "Error copiando el template."
  [[ -f "$VAULT_PATH/.obsidian/app.json" ]] || die "No se encontró .obsidian/app.json tras copiar el template."
  log "Template copiado OK."
}

create_venv_and_pip() {
  detect_python3_cmd || die "No hay Python compatible. Instalá Python ${PYTHON_VERSIONS_ACCEPTED// /, } e intentá de nuevo."
  local venv="$INSTDIR/.venv"
  log "Creando venv en $venv con $PYTHON3_CMD"
  "$PYTHON3_CMD" -m venv "$venv" >>"$LOG_FILE" 2>&1 || die "No se pudo crear el entorno virtual."
  local py="$venv/bin/python"
  [[ -x "$py" ]] || die "No se encontró $py"
  log "Actualizando pip..."
  "$py" -m pip install --upgrade pip >>"$LOG_FILE" 2>&1 || true
  if [[ "${INCLUDE_ONTOLOGY_EXPLORER:-0}" == "1" ]]; then
    log "Instalando $ONTOLOGY_WHL ..."
    "$py" -m pip install -v --find-links "$ASSETS_DIR" "$ASSETS_DIR/$ONTOLOGY_WHL" >>"$LOG_FILE" 2>&1 || die "No se pudo instalar OntologyExplorer."
    "$py" -m pip show ontology_explorer >/dev/null 2>&1 || die "Verificación pip show ontology_explorer falló."
  else
    log "Ontology Explorer omitido en esta build (INCLUDE_ONTOLOGY_EXPLORER=0; alinear con config.nsi en Windows)."
  fi
  log "Instalando $QDA_WHL ..."
  "$py" -m pip install -v --find-links "$ASSETS_DIR" "$ASSETS_DIR/$QDA_WHL" >>"$LOG_FILE" 2>&1 || die "No se pudo instalar obsidian_qda_suite."
  "$py" -m pip show obsidian_qda_suite >/dev/null 2>&1 || die "Verificación pip show obsidian_qda_suite falló."
  log "Paquetes Python instalados correctamente."
}

register_defaults() {
  defaults write "$PREFERENCES_DOMAIN" InstallPath -string "$INSTDIR"
  defaults write "$PREFERENCES_DOMAIN" Version -string "$VERSION"
  defaults write "$PREFERENCES_DOMAIN" Build -string "$BUILD"
  log "Preferencias guardadas en $PREFERENCES_DOMAIN"
}

# Abre la app para que el usuario elija o agregue el vault (sin obsidian:// que fuerza un vault).
open_obsidian_app() {
  if open -a Obsidian 2>>"$LOG_FILE"; then
    log "Obsidian abierto; elegí o agregá el vault en la app (carpeta: $VAULT_PATH)."
    return 0
  fi
  warn "No se pudo abrir Obsidian. Abrila desde Aplicaciones y abrí el vault en: $VAULT_PATH"
}

banner() {
  echo ""
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║     Emic QDA Suite — instalador      ║"
  echo "  ║     versión ${VERSION} / build ${BUILD}     ║"
  echo "  ╚══════════════════════════════════════╝"
  echo ""
}

main() {
  [[ "$(uname -s)" == "Darwin" ]] || die "Este script es solo para macOS."

  banner
  show_terms
  run_detection
  components_plan

  choose_installdir
  prompt_vault_name

  # Orden alineado a secciones NSIS: PY, OBS, ZOT, FFMPEG, luego vault
  install_python_brew
  install_obsidian_cask
  install_zotero_cask
  install_ffmpeg_brew

  copy_vault_template
  create_venv_and_pip
  register_defaults

  info "Instalación completada. Log: $LOG_FILE"
  info "Vault instalado en: $VAULT_PATH"
  if prompt_yn "¿Abrir Obsidian ahora? (en la app vas a elegir o agregar el vault manualmente)" "" "y"; then
    open_obsidian_app
  fi
  # Evitar doble detach en cleanup si ya desmontamos
  MOUNTED_VOLS=()
}

main "$@"
