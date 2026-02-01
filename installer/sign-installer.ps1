<#
.SYNOPSIS
  Firma el instalador Emic-QDA con el certificado configurado.

.DESCRIPTION
  Busca signtool (Windows SDK), el .exe del instalador y firma con el PFX.
  Certificado y contraseña por variables de entorno o parámetros.

.PARAMETER ExePath
  Ruta al .exe a firmar. Si no se pasa, usa el más reciente Emic-QDA-Installer-*.exe en esta carpeta.

.PARAMETER PfxPath
  Ruta al .pfx. Por defecto: variable de entorno SIGNING_PFX_PATH.

.PARAMETER Password
  Contraseña del PFX. Por defecto: variable de entorno SIGNING_PFX_PASSWORD.

.EXAMPLE
  $env:SIGNING_PFX_PATH = "C:\certs\EmicQDA-CodeSign.pfx"
  $env:SIGNING_PFX_PASSWORD = "miclave"
  .\sign-installer.ps1

.EXAMPLE
  .\sign-installer.ps1 -ExePath ".\Emic-QDA-Installer-2026-01-31-1505.exe" -PfxPath ".\EmicQDA-CodeSign.pfx" -Password "miclave"
#>
param(
  [string] $ExePath,
  [string] $PfxPath = $env:SIGNING_PFX_PATH,
  [string] $Password = $env:SIGNING_PFX_PASSWORD
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- Buscar signtool (Windows SDK) ---
$sdkRoot = "${env:ProgramFiles(x86)}\Windows Kits\10\bin"
if (-not (Test-Path $sdkRoot)) {
  Write-Error "No se encontró Windows SDK en $sdkRoot. Instalá el Windows SDK para usar signtool."
}
$versions = Get-ChildItem -Path $sdkRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^\d+\.\d+\.\d+' } | Sort-Object { [version]$_.Name } -Descending
$signtool = $null
foreach ($v in $versions) {
  $candidate = Join-Path $sdkRoot "$($v.Name)\x64\signtool.exe"
  if (Test-Path $candidate) {
    $signtool = $candidate
    break
  }
}
if (-not $signtool) {
  Write-Error "No se encontró signtool.exe en $sdkRoot (revisá que esté instalado el componente Windows SDK Signing Tools)."
}
Write-Host "Signtool: $signtool"

# --- Resolver .exe a firmar ---
if (-not $ExePath) {
  $exes = Get-ChildItem -Path $ScriptDir -Filter "Emic-QDA-Installer-*.exe" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
  if (-not $exes) {
    Write-Error "No hay ningún Emic-QDA-Installer-*.exe en $ScriptDir. Compilá antes con: makensis installer.nsi"
  }
  $ExePath = $exes[0].FullName
  Write-Host "Usando instalador más reciente: $($exes[0].Name)"
} else {
  if (-not (Test-Path $ExePath)) { Write-Error "No existe el archivo: $ExePath" }
  $ExePath = (Resolve-Path $ExePath).Path
}

# --- Certificado ---
if (-not $PfxPath) {
  Write-Error "Falta el certificado. Definí SIGNING_PFX_PATH o pasá -PfxPath."
}
if (-not (Test-Path $PfxPath)) { Write-Error "No existe el PFX: $PfxPath" }
$PfxPath = (Resolve-Path $PfxPath).Path

if (-not $Password) {
  Write-Error "Falta la contraseña del PFX. Definí SIGNING_PFX_PASSWORD o pasá -Password."
}

# --- Marca de tiempo (DigiCert) ---
$timestampUrl = "http://timestamp.digicert.com"

Write-Host "Firmando: $ExePath"
& $signtool sign /tr $timestampUrl /td sha256 /fd sha256 /f $PfxPath /p $Password $ExePath
if ($LASTEXITCODE -ne 0) { Write-Error "signtool falló con código $LASTEXITCODE" }
Write-Host "Firma correcta: $ExePath"
