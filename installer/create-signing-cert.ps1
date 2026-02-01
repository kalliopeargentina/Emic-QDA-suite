<#
.SYNOPSIS
  Crea un certificado autofirmado para firma de código y lo exporta a .pfx.

.DESCRIPTION
  Usa New-SelfSignedCertificate para crear un certificado de firma de código,
  lo exporta a installer/EmicQDA-CodeSign.pfx y muestra los comandos para
  definir SIGNING_PFX_PATH y SIGNING_PFX_PASSWORD (para build-and-sign.ps1).
  Ejecutar una sola vez; después usá build-and-sign.ps1.

.PARAMETER PfxPath
  Ruta del .pfx a generar. Por defecto: installer/EmicQDA-CodeSign.pfx (junto a este script).

.PARAMETER Subject
  Nombre del certificado. Por defecto: "CN=Emic QDA Suite".

.PARAMETER ValidYears
  Años de validez. Por defecto: 3.

.EXAMPLE
  .\create-signing-cert.ps1
  # Luego definí las variables e invocá: .\build-and-sign.ps1
#>
param(
  [string] $PfxPath = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "EmicQDA-CodeSign.pfx"),
  [string] $Subject = "CN=Emic QDA Suite",
  [int]    $ValidYears = 3
)

$ErrorActionPreference = "Stop"

Write-Host "Creando certificado autofirmado de firma de código..."
$cert = New-SelfSignedCertificate `
  -Type CodeSigningCert `
  -Subject $Subject `
  -CertStoreLocation "Cert:\CurrentUser\My" `
  -NotAfter (Get-Date).AddYears($ValidYears)

$thumbprint = $cert.Thumbprint
Write-Host "Certificado creado. Thumbprint: $thumbprint"

$password = Read-Host "allegra" -AsSecureString
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

$certObj = Get-ChildItem Cert:\CurrentUser\My\$thumbprint
Export-PfxCertificate -Cert $certObj -FilePath $PfxPath -Password $password | Out-Null
Write-Host "Exportado a: $PfxPath"

# No dejar la contraseña en memoria más de lo necesario
$plainPassword = $null

Write-Host ""
Write-Host "--- Siguiente paso: definí las variables y compilá/firmá ---"
Write-Host '(En PowerShell, una vez por sesión o en tu perfil):'
Write-Host ""
Write-Host "  `$env:SIGNING_PFX_PATH     = `"$PfxPath`""
Write-Host "  `$env:SIGNING_PFX_PASSWORD = `"tu_contraseña`""
Write-Host ""
Write-Host "Luego:"
Write-Host "  .\build-and-sign.ps1"
Write-Host ""
