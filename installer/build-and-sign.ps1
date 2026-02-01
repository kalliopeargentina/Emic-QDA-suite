<#
.SYNOPSIS
  Compila el instalador NSIS y lo firma en un solo paso.

.DESCRIPTION
  1. Ejecuta makensis installer.nsi (desde la carpeta installer).
  2. Ejecuta sign-installer.ps1 para firmar el .exe generado.
  Requiere: NSIS en el PATH, Windows SDK (signtool), y certificado configurado
  (SIGNING_PFX_PATH y SIGNING_PFX_PASSWORD).

.EXAMPLE
  $env:SIGNING_PFX_PATH = "C:\certs\EmicQDA-CodeSign.pfx"
  $env:SIGNING_PFX_PASSWORD = "miclave"
  .\build-and-sign.ps1
#>
param(
  [switch] $SkipSign
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "--- Compilando instalador (makensis installer.nsi) ---"
& makensis installer.nsi
if ($LASTEXITCODE -ne 0) { Write-Error "makensis falló con código $LASTEXITCODE" }

if ($SkipSign) {
  Write-Host "Omisión de firma (-SkipSign)."
  exit 0
}

Write-Host ""
Write-Host "--- Firmando instalador ---"
& (Join-Path $ScriptDir "sign-installer.ps1")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Listo: compilado y firmado."
