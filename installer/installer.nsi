!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"

${Using:StrFunc} StrStr
${Using:StrFunc} StrCase

!include "config.nsi"

; DumpLog: vuelca el log de la ventana de detalles del instalador a un archivo (requiere UI, no silent)
!define /IfNDef LVM_GETITEMCOUNT 0x1004
!define /IfNDef LVM_GETITEMTEXTA 0x102D
!define /IfNDef LVM_GETITEMTEXTW 0x1073
!if "${NSIS_CHAR_SIZE}" > 1
!define /IfNDef LVM_GETITEMTEXT ${LVM_GETITEMTEXTW}
!else
!define /IfNDef LVM_GETITEMTEXT ${LVM_GETITEMTEXTA}
!endif
Function DumpLog
  Exch $5
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $6
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1016
  StrCmp $0 0 exit
  FileOpen $5 $5 "w"
  StrCmp $5 "" exit
  SendMessage $0 ${LVM_GETITEMCOUNT} 0 0 $6
  System::Call '*(&t${NSIS_MAX_STRLEN})p.r3'
  StrCpy $2 0
  System::Call "*(i, i, i, i, i, p, i, i, i) p (0, 0, 0, 0, 0, r3, ${NSIS_MAX_STRLEN}) .r1"
loop:
  StrCmp $2 $6 done
  System::Call "User32::SendMessage(p, i, p, p) p ($0, ${LVM_GETITEMTEXT}, $2, r1)"
  System::Call "*$3(&t${NSIS_MAX_STRLEN} .r4)"
  FileWrite $5 "$4$\r$\n"
  IntOp $2 $2 + 1
  Goto loop
done:
  FileClose $5
  System::Free $1
  System::Free $3
exit:
  Pop $6
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
  Pop $5
FunctionEnd

Var VaultName
Var VaultPath
Var VaultNameInput
Var OverwriteVault
Var TempDir
Var DebugLogPath
Var VenvPath

; Escribe una línea en el log. En modo "a" NSIS deja el puntero al inicio; hay que FileSeek 0 END (doc NSIS).
Function AppendInstallLog
  Exch $0
  ClearErrors
  FileOpen $R0 $DebugLogPath a
  IfErrors done
  FileSeek $R0 0 END
  FileWrite $R0 "$0$\r$\n"
  FileClose $R0
done:
  Pop $0
FunctionEnd

!include "pages\\vault-name.nsh"

Name "Emic QDA Suite"
OutFile "Emic-QDA-Installer-${BUILD_ID}.exe"
InstallDir "$DOCUMENTS\\Emic-QDA"
RequestExecutionLevel highest
ShowInstDetails show

!define MUI_PAGE_CUSTOMFUNCTION_SHOW CloseSplashWhenDialogShows
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
Page custom VaultNamePageCreate VaultNamePageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "Spanish"

; Cerrar el splash 3 segundos después de que va a mostrarse el diálogo Welcome
Function CloseSplashWhenDialogShows
!ifdef INCLUDE_SPLASH
  Sleep 3000
  newadvsplash::stop /FADEOUT
!endif
FunctionEnd

Function .onInit
!ifdef INCLUDE_SPLASH
  ; Splash con NewAdvSplash: visible desde el doble clic hasta que aparece el diálogo Welcome.
  InitPluginsDir
  File /oname=$PLUGINSDIR\Emic-Splash.bmp "assets\Emic-Splash.bmp"
  newadvsplash::show /NOUNLOAD 3600000 500 500 -1 /BANNER "$PLUGINSDIR\Emic-Splash.bmp"
!endif
  StrCpy $OverwriteVault "0"
  StrCpy $TempDir "$TEMP\\EmicQDA-${BUILD_ID}"
  ; Un solo log en $TEMP; crearlo ya con "w" para que exista (el modo "a" no siempre crea el archivo en NSIS)
  StrCpy $DebugLogPath "$TEMP\\EmicQDA-install-${BUILD_ID}.log"
  ClearErrors
  FileOpen $R0 $DebugLogPath w
  IfErrors +4
    FileWrite $R0 "build=${BUILD_ID}$\r$\n"
    FileWrite $R0 "exedir=$EXEDIR$\r$\n"
    FileClose $R0
  ; VenvPath se fija en SEC_VAULT con el $INSTDIR que eligió el usuario (en .onInit $INSTDIR es el valor por defecto)
  DetailPrint "Build: ${BUILD_ID}"
FunctionEnd

Function ValidateVaultName
  Push $0
  Push $1
  Push $2

  ; Invalid characters
  ${StrStr} $0 $VaultName "\\"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "/"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName ":"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "*"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "?"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "$\""
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "<"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName ">"
  StrCmp $0 "" 0 invalid
  ${StrStr} $0 $VaultName "|"
  StrCmp $0 "" 0 invalid

  ${StrCase} $1 $VaultName "U"
  StrLen $2 $1

  ; Reserved names: CON, PRN, AUX, NUL
  StrCmp $2 3 0 +7
    StrCpy $0 $1 3
    StrCmp $0 "CON" invalid
    StrCmp $0 "PRN" invalid
    StrCmp $0 "AUX" invalid
    StrCmp $0 "NUL" invalid

  StrCmp $2 4 0 +6
    StrCpy $0 $1 4
    StrCmp $0 "CON." invalid
    StrCmp $0 "PRN." invalid
    StrCmp $0 "AUX." invalid
    StrCmp $0 "NUL." invalid

  ; Reserved COM1-9 and LPT1-9 (exact or followed by dot)
  StrCmp $2 4 0 +22
    StrCpy $0 $1 4
    StrCmp $0 "COM1" invalid
    StrCmp $0 "COM2" invalid
    StrCmp $0 "COM3" invalid
    StrCmp $0 "COM4" invalid
    StrCmp $0 "COM5" invalid
    StrCmp $0 "COM6" invalid
    StrCmp $0 "COM7" invalid
    StrCmp $0 "COM8" invalid
    StrCmp $0 "COM9" invalid
    StrCmp $0 "LPT1" invalid
    StrCmp $0 "LPT2" invalid
    StrCmp $0 "LPT3" invalid
    StrCmp $0 "LPT4" invalid
    StrCmp $0 "LPT5" invalid
    StrCmp $0 "LPT6" invalid
    StrCmp $0 "LPT7" invalid
    StrCmp $0 "LPT8" invalid
    StrCmp $0 "LPT9" invalid

  IntCmp $2 5 checkDot done checkDot
checkDot:
    StrCpy $0 $1 5
    StrCmp $0 "COM1." invalid
    StrCmp $0 "COM2." invalid
    StrCmp $0 "COM3." invalid
    StrCmp $0 "COM4." invalid
    StrCmp $0 "COM5." invalid
    StrCmp $0 "COM6." invalid
    StrCmp $0 "COM7." invalid
    StrCmp $0 "COM8." invalid
    StrCmp $0 "COM9." invalid
    StrCmp $0 "LPT1." invalid
    StrCmp $0 "LPT2." invalid
    StrCmp $0 "LPT3." invalid
    StrCmp $0 "LPT4." invalid
    StrCmp $0 "LPT5." invalid
    StrCmp $0 "LPT6." invalid
    StrCmp $0 "LPT7." invalid
    StrCmp $0 "LPT8." invalid
    StrCmp $0 "LPT9." invalid

  Goto done

invalid:
  MessageBox MB_ICONEXCLAMATION "Nombre de vault inválido. Evitá caracteres \\ / : * ? $\" < > | y nombres reservados (CON, PRN, AUX, NUL, COM1-9, LPT1-9)." /SD IDOK
  Pop $2
  Pop $1
  Pop $0
  Abort

done:
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

; Copia el directorio del template (empaquetado en el instalador) a $VaultPath.
; En Windows *.* no incluye carpetas que empiezan con punto; las añadimos explícitas.
Function CopyVaultTemplate
  Push "copy_template_start"
  Call AppendInstallLog
  IfFileExists "$VaultPath\\*.*" 0 +2
    RMDir /r "$VaultPath"
  CreateDirectory "$VaultPath"
  SetOutPath "$VaultPath"
  Push "copy_template_outpath=$VaultPath"
  Call AppendInstallLog
  File /r "assets\\${TEMPLATE_DIR}\\*.*"
  ; Carpeta .obsidian (en Windows *.* no incluye carpetas que empiezan con punto)
  SetOutPath "$VaultPath\\.obsidian"
  File /r "assets\\${TEMPLATE_DIR}\\.obsidian\\*.*"
  Push "copy_template_done"
  Call AppendInstallLog
FunctionEnd

Section /o "Python (opcional)" SEC_PY
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  File "assets\\${PYTHON_INSTALLER}"
  MessageBox MB_OK "Se abrirá el instalador de Python ${PYTHON_VERSION}. Completá la instalación y luego continuá aquí."
  ExecWait '"$TempDir\\${PYTHON_INSTALLER}"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Python falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "Obsidian (opcional)" SEC_OBS
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  File "assets\\${OBSIDIAN_INSTALLER}"
  MessageBox MB_OK "Se abrirá el instalador de Obsidian ${OBSIDIAN_VERSION}. Completá la instalación y luego continuá aquí."
  ExecWait '"$TempDir\\${OBSIDIAN_INSTALLER}"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Obsidian falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "Zotero (opcional)" SEC_ZOT
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  File "assets\\${ZOTERO_INSTALLER}"
  MessageBox MB_OK "Se abrirá el instalador de Zotero. Completá la instalación y luego continuá aquí."
  ExecWait '"$TempDir\\${ZOTERO_INSTALLER}"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Zotero falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "FFmpeg (opcional)" SEC_FFMPEG
!ifdef INCLUDE_FFMPEG
  CreateDirectory "$INSTDIR"
  SetOutPath "$INSTDIR"
  File /r "assets\ffmpeg"
  ; Persistir PATH del usuario apuntando a ffmpeg\bin en el directorio de instalación
  IfFileExists "$INSTDIR\ffmpeg\bin" 0 +8
  ReadRegStr $0 HKCU "Environment" "Path"
  StrCpy $1 "$INSTDIR\ffmpeg\bin"
  StrCpy $0 "$0;$1"
  WriteRegStr HKCU "Environment" "Path" "$0"
  System::Call 'user32::SendMessageTimeout(i 0xffff, i 0x1a, i 0, w "Environment", i 0, i 5000, *i .r2)'
  Push "ffmpeg_path_updated"
  Call AppendInstallLog
!else
  DetailPrint "FFmpeg no incluido en esta compilación (añadí assets/ffmpeg y define INCLUDE_FFMPEG para incluirlo)."
!endif
SectionEnd

Section "Vault y entorno Python (requerido)" SEC_VAULT
  SectionIn RO
  CreateDirectory "$INSTDIR"
  ; El archivo de log ya existe (creado en .onInit); installdir y vault_path_set los escribe la página
  Push "vault_section_begin"
  Call AppendInstallLog
  StrCpy $VenvPath "$INSTDIR\\.venv"
  DetailPrint "EXEDIR=$EXEDIR"
  DetailPrint "TempDir=$TempDir"
  DetailPrint "VenvPath=$VenvPath"
  Push "tempdir=$TempDir"
  Call AppendInstallLog
  Push "venvpath=$VenvPath"
  Call AppendInstallLog

  CreateDirectory "$TempDir\\assets"
  SetOutPath "$TempDir\\assets"
  File "assets\\${ONTOLOGY_WHL}"
  File "assets\\${ONTOLOGY_TAR}"
  File "assets\\${QDA_WHL}"
  File "assets\\${QDA_TAR}"
  Push "tempdir_assets_ready"
  Call AppendInstallLog

  Call CopyVaultTemplate
  Push "after_copy_template"
  Call AppendInstallLog
  IfFileExists "$VaultPath\\.obsidian\\app.json" 0 +3
    Goto vault_ok
  MessageBox MB_ICONSTOP "No se encontró la carpeta .obsidian en el vault creado. Revisa el template." /SD IDOK
  Abort
vault_ok:

  SetOutPath "$INSTDIR"

  ; Si .venv ya existe, no crear de nuevo
  IfFileExists "$VenvPath\Scripts\python.exe" venv_ps1_ok
  Push "venv_begin"
  Call AppendInstallLog
  MessageBox MB_OK "Creando entorno Python en el directorio de instalación..."
  ; Ejecutar venv por PowerShell sin ventana; stdout/stderr al log
  StrCpy $R9 "$TempDir\\create-venv.ps1"
  FileOpen $R0 $R9 w
  IfErrors venv_ps1_fail
  FileWrite $R0 "param([string]$$VenvPath, [string]$$LogPath)$\r$\n"
  FileWrite $R0 "$$ErrorActionPreference = 'Stop'$\r$\n"
  FileWrite $R0 "if ($$LogPath) { '[venv] VenvPath=' + $$VenvPath | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host '[venv] VenvPath=' $$VenvPath$\r$\n"
!ifdef POWERSHELL_PAUSE_ON_ERROR
  FileWrite $R0 "$$exitCode = 0; try { & py -${PY_MAJOR} -m venv $$VenvPath 2>&1 | ForEach-Object { Write-Host $$_; if ($$LogPath) { $$_ | Out-File -FilePath $$LogPath -Append -Encoding utf8 } }; $$exitCode = $$LASTEXITCODE; if ($$LogPath) { '[venv] exit=' + $$exitCode | Out-File -FilePath $$LogPath -Append -Encoding utf8 } } catch { if ($$LogPath) { $$_.ToString() | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host $$_.ToString(); $$exitCode = 1 }; if ($$exitCode -ne 0) { Read-Host 'Error. Presione Enter para cerrar' }; exit $$exitCode$\r$\n"
!else
  FileWrite $R0 "$$exitCode = 0; try { & py -${PY_MAJOR} -m venv $$VenvPath 2>&1 | ForEach-Object { Write-Host $$_; if ($$LogPath) { $$_ | Out-File -FilePath $$LogPath -Append -Encoding utf8 } }; $$exitCode = $$LASTEXITCODE; if ($$LogPath) { '[venv] exit=' + $$exitCode | Out-File -FilePath $$LogPath -Append -Encoding utf8 } } catch { if ($$LogPath) { $$_.ToString() | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host $$_.ToString(); $$exitCode = 1 }; exit $$exitCode$\r$\n"
!endif
  FileClose $R0
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -LogPath "$INSTDIR\\EmicQDA-install-${BUILD_ID}.log"' $0
  Push "venv_exit=$0"
  Call AppendInstallLog
  ; Verificar por resultado: la ventana puede devolver error al cerrar; si el venv existe, continuar
  IfFileExists "$VenvPath\Scripts\python.exe" venv_ps1_ok
  MessageBox MB_ICONSTOP "No se pudo crear el entorno virtual (código $0). Verificá que el launcher de Python esté instalado. Revisá el log en la carpeta de instalación." /SD IDOK
  Abort
venv_ps1_fail:
  Push "venv_error=ps1_create_fail"
  Call AppendInstallLog
  MessageBox MB_ICONSTOP "No se pudo crear el script de venv." /SD IDOK
  Abort
venv_ps1_ok:
  Push "venv_ok"
  Call AppendInstallLog
  ; Pip por PowerShell sin ventana: activar venv y pip; stdout/stderr al log
  StrCpy $R9 "$TempDir\\pip-install.ps1"
  FileOpen $R0 $R9 w
  IfErrors pip_ps1_fail
  FileWrite $R0 "param([string]$$VenvPath, [string]$$PackageName, [string]$$LogPath)$\r$\n"
  FileWrite $R0 "$$ErrorActionPreference = 'Continue'$\r$\n"
  FileWrite $R0 "function SafeLog { param($$msg) if ($$LogPath) { try { $$msg | Out-File -FilePath $$LogPath -Append -Encoding utf8 } catch {} } }$\r$\n"
  FileWrite $R0 "$$FindLinks = Join-Path $$PSScriptRoot 'assets'$\r$\n"
  FileWrite $R0 "$$Package = Join-Path $$FindLinks $$PackageName$\r$\n"
  FileWrite $R0 "$$line = '[pip] Package=' + $$Package$\r$\n"
  FileWrite $R0 "SafeLog $$line$\r$\n"
  FileWrite $R0 "Write-Host $$line$\r$\n"
  FileWrite $R0 "$$act = Join-Path $$VenvPath 'Scripts\Activate.ps1'$\r$\n"
  FileWrite $R0 "& $$act 2>&1 | ForEach-Object { Write-Host $$_; SafeLog $$_ }$\r$\n"
  FileWrite $R0 "$$py = Join-Path $$VenvPath 'Scripts\python.exe'$\r$\n"
  FileWrite $R0 "& $$py -m pip install --upgrade pip 2>&1 | ForEach-Object { Write-Host $$_; SafeLog $$_ }$\r$\n"
  FileWrite $R0 "$$env:PYTHONUNBUFFERED = '1'$\r$\n"
  FileWrite $R0 "Write-Host '[pip] Installing package (verbose)...'$\r$\n"
  FileWrite $R0 "& $$py -m pip install -v --find-links $$FindLinks $$Package 2>&1 | ForEach-Object { Write-Host $$_; SafeLog $$_ }$\r$\n"
  FileWrite $R0 "$$pipExit = $$LASTEXITCODE$\r$\n"
  FileWrite $R0 "if ($$pipExit -eq $$null -or $$pipExit -eq '') { $$pipExit = 1 }$\r$\n"
  FileWrite $R0 "SafeLog '[pip] exit=' + [string]$$pipExit$\r$\n"
  FileWrite $R0 "Write-Host '[pip] exit=' $$pipExit$\r$\n"
!ifdef POWERSHELL_PAUSE_ON_ERROR
  FileWrite $R0 "if ($$pipExit -ne 0) { Write-Host 'ERROR. Presione Enter para cerrar'$\r$\n"
  FileWrite $R0 "  Read-Host }$\r$\n"
!endif
  FileWrite $R0 "exit [int]$$pipExit$\r$\n"
  FileClose $R0
  StrCpy $R2 "$INSTDIR\EmicQDA-install-${BUILD_ID}.log"
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -PackageName "${ONTOLOGY_WHL}" -LogPath "$R2"' $0
  Push "pip_ontology_whl_exit=$0"
  Call AppendInstallLog
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -PackageName "${ONTOLOGY_TAR}" -LogPath "$R2"' $0
  Push "pip_ontology_tar_exit=$0"
  Call AppendInstallLog
  ; Verificar por resultado: las ventanas pueden devolver error al cerrar; si el paquete está instalado, continuar
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "& $\'$VenvPath\Scripts\python.exe$\' -m pip show ontology_explorer"' $0
  Push "pip_verify_ontology_exit=$0"
  Call AppendInstallLog
  IntCmp $0 0 ontology_ok
  Push "pip_ontology_error=not_installed"
  Call AppendInstallLog
  MessageBox MB_ICONSTOP "No se pudo instalar OntologyExplorer. Revisá el log en la carpeta de instalación." /SD IDOK
  Abort
ontology_ok:
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -PackageName "${QDA_WHL}" -LogPath "$R2"' $0
  Push "pip_qda_whl_exit=$0"
  Call AppendInstallLog
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -PackageName "${QDA_TAR}" -LogPath "$R2"' $0
  Push "pip_qda_tar_exit=$0"
  Call AppendInstallLog
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "& $\'$VenvPath\Scripts\python.exe$\' -m pip show obsidian_qda_suite"' $0
  Push "pip_verify_qda_exit=$0"
  Call AppendInstallLog
  IntCmp $0 0 pip_done
  Push "pip_qda_error=not_installed"
  Call AppendInstallLog
  MessageBox MB_ICONSTOP "No se pudo instalar ObsidianQDA-Suite. Revisá el log en la carpeta de instalación." /SD IDOK
  Abort
pip_ps1_fail:
  Push "pip_error=ps1_create_fail"
  Call AppendInstallLog
  MessageBox MB_ICONSTOP "No se pudo crear el script de pip." /SD IDOK
  Abort
pip_done:
  Push "pip_done"
  Call AppendInstallLog

  ; Copiar log desde $TEMP a $INSTDIR para que quede en la carpeta de instalación
  IfFileExists $DebugLogPath 0 +3
    CopyFiles /SILENT $DebugLogPath "$INSTDIR\\EmicQDA-install-nsis-${BUILD_ID}.log"
  ; Volcar el log de la ventana de detalles (todo lo que vio el usuario en "Detalles")
  Push "$INSTDIR\\EmicQDA-install-details-${BUILD_ID}.log"
  Call DumpLog
  ; Eliminar directorio temporal (scripts, assets copiados); los logs quedan en $INSTDIR
  RMDir /r "$TempDir"
SectionEnd
