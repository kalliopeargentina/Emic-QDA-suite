; Instalador Unicode para que los diálogos muestren bien caracteres acentuados (á, é, ñ, etc.).
; Guardar este archivo como UTF-8 con BOM si los acentos no se ven correctamente al compilar.
Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"
!include "Sections.nsh"

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
Var ObsidianInstalled
Var ZoteroInstalled
Var PythonInstalled
Var FFmpegInstalled

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
OutFile "Emic-QDA-Installer-${VERSION}-${BUILD}.exe"
; Recordar directorio de instalación previa (registro); si no existe, usar Documents\Emic-QDA
InstallDirRegKey HKCU "Software\Emic-QDA" "InstallPath"
InstallDir "$DOCUMENTS\\Emic-QDA"
RequestExecutionLevel highest
ShowInstDetails show

!define MUI_ICON "assets\favicon.ico"
!define MUI_UNICON "assets\favicon.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "assets\banner.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "assets\side.bmp"

!define MUI_PAGE_CUSTOMFUNCTION_SHOW CloseSplashWhenDialogShows
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ComponentsPageShow
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirLeave
!insertmacro MUI_PAGE_DIRECTORY
!ifdef MUI_PAGE_CUSTOMFUNCTION_LEAVE
!undef MUI_PAGE_CUSTOMFUNCTION_LEAVE
!endif
Page custom VaultNamePageCreate VaultNamePageLeave
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "Abrir el nuevo repositorio de EMIC-QDA"
!define MUI_FINISHPAGE_RUN_FUNCTION RunOpenVault
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "Spanish"

; Cerrar el splash 3 segundos después de que va a mostrarse el diálogo Welcome
Function CloseSplashWhenDialogShows
!ifdef INCLUDE_SPLASH
  Sleep 3000
  newadvsplash::stop /FADEOUT
!endif
FunctionEnd

; Guardar directorio elegido en el registro para ofrecerlo por defecto en la próxima corrida
Function DirLeave
  WriteRegStr HKCU "Software\Emic-QDA" "InstallPath" "$INSTDIR"
FunctionEnd

; Si el usuario dejó marcado "Abrir el nuevo repositorio", abrir Obsidian vía PowerShell
Function RunOpenVault
  Exec 'powershell.exe -NoProfile -Command $\"Start-Process \$\"obsidian:$\"$\"'
FunctionEnd

Function .onInit
!ifdef INCLUDE_SPLASH
  ; Splash con NewAdvSplash: visible desde el doble clic hasta que aparece el diálogo Welcome.
  InitPluginsDir
  File /oname=$PLUGINSDIR\Emic-Splash.bmp "assets\Emic-Splash.bmp"
  newadvsplash::show /NOUNLOAD 3600000 500 500 -1 /BANNER "$PLUGINSDIR\Emic-Splash.bmp"
!endif
  StrCpy $OverwriteVault "0"
  StrCpy $TempDir "$TEMP\\EmicQDA-${BUILD}"
  ; Un solo log en $TEMP; crearlo ya con "w" para que exista (el modo "a" no siempre crea el archivo en NSIS)
  StrCpy $DebugLogPath "$TEMP\\EmicQDA-install-${BUILD}.log"
  ClearErrors
  FileOpen $R0 $DebugLogPath w
  IfErrors +4
    FileWrite $R0 "build=${BUILD}$\r$\n"
    FileWrite $R0 "exedir=$EXEDIR$\r$\n"
    FileClose $R0
  ; VenvPath se fija en SEC_VAULT con el $INSTDIR que eligió el usuario (en .onInit $INSTDIR es el valor por defecto)
  DetailPrint "Build: ${BUILD}"
  ; Ventana centrada en la mitad derecha de la pantalla (700x550)
  System::Call "user32::GetSystemMetrics(i 0) i .r0"
  System::Call "user32::GetSystemMetrics(i 1) i .r1"
  IntOp $2 $0 * 3
  IntOp $2 $2 / 4
  IntOp $2 $2 - 350
  IntOp $3 $1 - 550
  IntOp $3 $3 / 2
  System::Call "user32::SetWindowPos(i $HWNDPARENT, i 0, i $2, i $3, i 700, i 550, i 0x40)"
  ; Detectar si Obsidian está instalado: primero ruta por defecto; si no, registro (App Paths o protocolo obsidian:) verificando que el exe exista
  StrCpy $ObsidianInstalled "0"
  IfFileExists "$LOCALAPPDATA\Obsidian\Obsidian.exe" 0 obsidian_try_reg
    StrCpy $ObsidianInstalled "1"
  Goto obsidian_done
  obsidian_try_reg:
  Call CheckObsidianByRegistry
  obsidian_done:
  ; Crear VBS para ejecutar .ps1 sin ventana (lo usan CheckZoteroByRegistry y CheckPythonVersion)
  Call CreateRunVbs
  ; Detectar si Zotero está instalado (registro App Paths, sin ventana)
  StrCpy $ZoteroInstalled "0"
  Call CheckZoteroByRegistry
  ; Detectar si Python 3.12+ está instalado: ejecutar py --version oculto y comprobar versión
  StrCpy $PythonInstalled "0"
  Call CheckPythonVersion
  ; Detectar si FFmpeg está en PATH: rutas que contengan "ffmpeg" y tengan ffmpeg.exe y ffprobe.exe
  StrCpy $FFmpegInstalled "0"
  Call CheckFFmpegInPath
FunctionEnd

; Crea $TEMP\EmicQDA-run.vbs: ejecuta PowerShell con el .ps1 indicado sin ventana (WScript.Shell.Run con 0 = oculto)
Function CreateRunVbs
  Push $R0
  Push $R9
  StrCpy $R9 "$TEMP\EmicQDA-run.vbs"
  FileOpen $R0 $R9 w
  FileWrite $R0 "Set sh = CreateObject($\"WScript.Shell$\")$\r$\n"
  FileWrite $R0 "If WScript.Arguments.Count >= 1 Then$\r$\n"
  FileWrite $R0 "  sh.Run $\"powershell.exe -NoProfile -ExecutionPolicy Bypass -File $\" & Chr(34) & WScript.Arguments(0) & Chr(34), 0, True$\r$\n"
  FileWrite $R0 "End If$\r$\n"
  FileClose $R0
  Pop $R9
  Pop $R0
FunctionEnd

; Fallback Obsidian: lee ruta del registro (App Paths o protocolo obsidian:) y solo pone $ObsidianInstalled "1" si el exe existe (evitar registros huérfanos)
Function CheckObsidianByRegistry
  Push $R0
  Push $R1
  Push $R2
  ; App Paths HKLM
  ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\App Paths\Obsidian.exe" ""
  StrCmp $R0 "" 0 obsidian_verify_path
  ; App Paths HKCU
  ReadRegStr $R0 HKCU "Software\Microsoft\Windows\CurrentVersion\App Paths\Obsidian.exe" ""
  StrCmp $R0 "" 0 obsidian_verify_path
  ; Protocolo obsidian: shell\open\command (valor tipo "C:\path\Obsidian.exe" "%1")
  ReadRegStr $R0 HKCU "Software\Classes\obsidian\shell\open\command" ""
  StrCmp $R0 "" obsidian_reg_done
  ; Extraer ruta entre comillas: primer " en 0, path hasta el siguiente "
  StrCpy $R1 $R0 1 0
  StrCmp $R1 "$\"" 0 obsidian_reg_done
  StrCpy $R1 1
  obsidian_parse_loop:
  StrCpy $R2 $R0 1 $R1
  StrCmp $R2 "" obsidian_reg_done
  StrCmp $R2 "$\"" 0 obsidian_parse_next
  IntOp $R2 $R1 - 1
  IntCmp $R2 0 obsidian_reg_done obsidian_reg_done
  StrCpy $R0 $R0 $R2 1
  Goto obsidian_verify_path
  obsidian_parse_next:
  IntOp $R1 $R1 + 1
  Goto obsidian_parse_loop
  obsidian_verify_path:
  IfFileExists "$R0" 0 obsidian_reg_done
  StrCpy $ObsidianInstalled "1"
  obsidian_reg_done:
  Pop $R2
  Pop $R1
  Pop $R0
FunctionEnd

; Detecta Zotero por registro (App Paths) sin ventana; si hay ruta en HKLM o HKCU, pone $ZoteroInstalled "1"
Function CheckZoteroByRegistry
  Push $R0
  Push $R8
  StrCpy $R8 "$TEMP\EmicQDA-zotero-check.ps1"
  FileOpen $R0 $R8 w
  FileWrite $R0 "$$x = Get-ItemProperty $\"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\zotero.exe$\", $\"HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\zotero.exe$\" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $\"(default)$\"$\r$\n"
  FileWrite $R0 "if ($$x) { $\"1$\" | Out-File -FilePath $$env:TEMP\EmicQDA-zotero-out.txt -Encoding ascii }$\r$\n"
  FileClose $R0
  ExecWait '$\"$SYSDIR\wscript.exe$\" //B $\"$TEMP\EmicQDA-run.vbs$\" $\"$R8$\"' $R0
  Delete $R8
  IfFileExists "$TEMP\EmicQDA-zotero-out.txt" 0 zotero_reg_done
  StrCpy $ZoteroInstalled "1"
  Delete "$TEMP\EmicQDA-zotero-out.txt"
  zotero_reg_done:
  Pop $R8
  Pop $R0
FunctionEnd

; Ejecuta py --version de forma oculta vía script .ps1 temporal; si la salida contiene alguna versión de PYTHON_VERSIONS_ACCEPTED, pone $PythonInstalled "1"
Function CheckPythonVersion
  Push $0
  Push $1
  Push $2
  Push $3
  StrCpy $0 "$TEMP\EmicQDA-pyver.txt"
  StrCpy $R8 "$TEMP\EmicQDA-pycheck.ps1"
  FileOpen $R0 $R8 w
  FileWrite $R0 "$$outFile = '$0'$\r$\n"
  FileWrite $R0 "$$psi = New-Object System.Diagnostics.ProcessStartInfo$\r$\n"
  FileWrite $R0 "$$psi.FileName = 'py'$\r$\n"
  FileWrite $R0 "$$psi.Arguments = '--version'$\r$\n"
  FileWrite $R0 "$$psi.UseShellExecute = $$false$\r$\n"
  FileWrite $R0 "$$psi.CreateNoWindow = $$true$\r$\n"
  FileWrite $R0 "$$psi.RedirectStandardOutput = $$true$\r$\n"
  FileWrite $R0 "$$psi.RedirectStandardError = $$true$\r$\n"
  FileWrite $R0 "$$p = [System.Diagnostics.Process]::Start($$psi)$\r$\n"
  FileWrite $R0 "$$out = $$p.StandardOutput.ReadToEnd() + $$p.StandardError.ReadToEnd()$\r$\n"
  FileWrite $R0 "$$p.WaitForExit()$\r$\n"
  FileWrite $R0 "$$out | Out-File -FilePath $$outFile -Encoding ascii$\r$\n"
  FileWrite $R0 "$$p.ExitCode | Out-File -FilePath $$env:TEMP\EmicQDA-exitcode.txt -Encoding ascii$\r$\n"
  FileClose $R0
  ExecWait '$\"$SYSDIR\wscript.exe$\" //B $\"$TEMP\EmicQDA-run.vbs$\" $\"$R8$\"' $1
  Delete $R8
  IfFileExists "$0" 0 pyver_done
  ClearErrors
  FileOpen $1 "$0" r
  IfErrors pyver_close
  FileRead $1 $R9
  FileClose $1
  Delete "$0"
  ; Recorrer PYTHON_VERSIONS_ACCEPTED (versiones separadas por espacio en config.nsi)
  StrCpy $0 "${PYTHON_VERSIONS_ACCEPTED}"
pyver_loop:
  StrCmp $0 "" pyver_done
  ${StrStr} $1 $0 " "
  StrCmp $1 "" pyver_last
  StrLen $2 $0
  StrLen $3 $1
  IntOp $2 $2 - $3
  StrCpy $R8 $0 $2
  StrCpy $0 $1 "" 1
  Goto pyver_check
pyver_last:
  StrCpy $R8 $0
  StrCpy $0 ""
pyver_check:
  StrCmp $R8 "" pyver_loop
  ${StrStr} $1 $R9 $R8
  StrCmp $1 "" pyver_loop
  StrCpy $PythonInstalled "1"
  Goto pyver_done
  Goto pyver_loop
pyver_close:
  FileClose $1
  Delete "$0"
pyver_done:
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd

; Detecta FFmpeg por PATH (usuario + sistema): segmentos que contengan "ffmpeg" (case-insensitive); solo si en ese directorio existen ffmpeg.exe y ffprobe.exe pone $FFmpegInstalled "1"
Function CheckFFmpegInPath
  Push $R0
  Push $R8
  StrCpy $R8 "$TEMP\EmicQDA-ffmpeg-check.ps1"
  FileOpen $R0 $R8 w
  FileWrite $R0 "$$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')$\r$\n"
  FileWrite $R0 "$$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')$\r$\n"
  FileWrite $R0 "$$combined = $$userPath + ';' + $$machinePath$\r$\n"
  FileWrite $R0 "$$segments = $$combined -split ';' | ForEach-Object { $$_.Trim() } | Where-Object { $$_.Length -gt 0 }$\r$\n"
  FileWrite $R0 "foreach ($$dir in $$segments) {$\r$\n"
  FileWrite $R0 "  if ($$dir -match 'ffmpeg') {$\r$\n"
  FileWrite $R0 "    $$ffmpegExe = Join-Path $$dir 'ffmpeg.exe'$\r$\n"
  FileWrite $R0 "    $$ffprobeExe = Join-Path $$dir 'ffprobe.exe'$\r$\n"
  FileWrite $R0 "    if ((Test-Path -LiteralPath $$ffmpegExe) -and (Test-Path -LiteralPath $$ffprobeExe)) {$\r$\n"
  FileWrite $R0 "      $\"1$\" | Out-File -FilePath (Join-Path $$env:TEMP 'EmicQDA-ffmpeg-out.txt') -Encoding ascii$\r$\n"
  FileWrite $R0 "      exit 0$\r$\n"
  FileWrite $R0 "    }$\r$\n"
  FileWrite $R0 "  }$\r$\n"
  FileWrite $R0 "}$\r$\n"
  FileClose $R0
  ExecWait '$\"$SYSDIR\wscript.exe$\" //B $\"$TEMP\EmicQDA-run.vbs$\" $\"$R8$\"' $R0
  Delete $R8
  IfFileExists "$TEMP\EmicQDA-ffmpeg-out.txt" 0 ffmpeg_path_done
  StrCpy $FFmpegInstalled "1"
  Delete "$TEMP\EmicQDA-ffmpeg-out.txt"
ffmpeg_path_done:
  Pop $R8
  Pop $R0
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

Section /o "Python" SEC_PY
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  DetailPrint "Descargando Python..."
  inetc::get /POPUP "" /CAPTION "Descargando Python..." "${PYTHON_URL}" "$TempDir\${PYTHON_INSTALLER}"
  Pop $0
  StrCmp $0 "OK" python_download_ok
  MessageBox MB_ICONSTOP "Error descargando Python.$\r$\nDetalle: $0"
  Abort
  python_download_ok:
  DetailPrint "Python descargado correctamente."
  ExecWait '"$TempDir\\${PYTHON_INSTALLER}"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Python falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "Obsidian" SEC_OBS
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  DetailPrint "Descargando Obsidian..."
  inetc::get /POPUP "" /CAPTION "Descargando Obsidian..." "${OBSIDIAN_URL}" "$TempDir\${OBSIDIAN_INSTALLER}"
  Pop $0
  StrCmp $0 "OK" obsidian_download_ok
  MessageBox MB_ICONSTOP "Error descargando Obsidian.$\r$\nDetalle: $0"
  Abort
  obsidian_download_ok:
  DetailPrint "Obsidian descargado correctamente."
  ExecWait '"$TempDir\\${OBSIDIAN_INSTALLER}"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Obsidian falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "Zotero (opcional)" SEC_ZOT
  CreateDirectory "$TempDir"
  SetOutPath "$TempDir"
  DetailPrint "Descargando Zotero..."
  inetc::get /POPUP "" /CAPTION "Descargando Zotero..." "${ZOTERO_URL}" "$TempDir\Zotero_setup.exe"
  Pop $0
  StrCmp $0 "OK" zotero_download_ok
  MessageBox MB_ICONSTOP "Error descargando Zotero.$\r$\nDetalle: $0"
  Abort
  zotero_download_ok:
  DetailPrint "Zotero descargado correctamente."
  ExecWait '"$TempDir\Zotero_setup.exe"' $0
  IntCmp $0 0 done
    MessageBox MB_ICONSTOP "La instalación de Zotero falló (código $0)." /SD IDOK
    Abort
done:
SectionEnd

Section /o "FFmpeg" SEC_FFMPEG
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
  File "assets\\${QDA_WHL}"
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
  ; Ejecutar venv por PowerShell sin ventana; stdout/stderr al log
  StrCpy $R9 "$TempDir\\create-venv.ps1"
  FileOpen $R0 $R9 w
  IfErrors venv_ps1_fail
  FileWrite $R0 "param([string]$$VenvPath, [string]$$LogPath, [string]$$Versions)$\r$\n"
  FileWrite $R0 "try { $$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(80, 30); $$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(80, 30) } catch {}$\r$\n"
  FileWrite $R0 "$$ErrorActionPreference = 'Stop'$\r$\n"
  FileWrite $R0 "if ($$LogPath) { '[venv] VenvPath=' + $$VenvPath | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host '[venv] VenvPath=' $$VenvPath$\r$\n"
  FileWrite $R0 "$$versions = ($$Versions.Trim() -split '\s+') | Where-Object { $$_.Length -gt 0 }$\r$\n"
  FileWrite $R0 "$$regPaths = $$versions | ForEach-Object { $$v = $$_; 'HKCU:\Software\Python\PythonCore\' + $$v + '\InstallPath'; 'HKLM:\Software\Python\PythonCore\' + $$v + '\InstallPath' }$\r$\n"
  FileWrite $R0 "$$installPath = $$regPaths | Where-Object { Test-Path $$_ } | ForEach-Object { (Get-ItemProperty $$_).'(default)' } | Select-Object -First 1$\r$\n"
  FileWrite $R0 "$$pythonExe = $$null; if ($$installPath) { $$p = Join-Path $$installPath 'python.exe'; if (Test-Path $$p) { $$pythonExe = $$p } }$\r$\n"
  FileWrite $R0 "$$venvExe = if ($$pythonExe) { $$pythonExe } else { 'py' }; $$venvArgs = if ($$pythonExe) { '-m', 'venv', $$VenvPath } else { '-${PY_MAJOR}', '-m', 'venv', $$VenvPath }$\r$\n"
  FileWrite $R0 "if ($$LogPath) { '[venv] Python=' + $$venvExe | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host '[venv] Python=' $$venvExe$\r$\n"
!ifdef POWERSHELL_PAUSE_ON_ERROR
  FileWrite $R0 "$$exitCode = 0; try { & $$venvExe @venvArgs 2>&1 | ForEach-Object { Write-Host $$_; if ($$LogPath) { $$_ | Out-File -FilePath $$LogPath -Append -Encoding utf8 } }; $$exitCode = $$LASTEXITCODE; if ($$LogPath) { '[venv] exit=' + $$exitCode | Out-File -FilePath $$LogPath -Append -Encoding utf8 } } catch { if ($$LogPath) { $$_.ToString() | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host $$_.ToString(); $$exitCode = 1 }; if ($$exitCode -ne 0) { Read-Host 'Error. Presione Enter para cerrar' }; exit $$exitCode$\r$\n"
!else
  FileWrite $R0 "$$exitCode = 0; try { & $$venvExe @venvArgs 2>&1 | ForEach-Object { Write-Host $$_; if ($$LogPath) { $$_ | Out-File -FilePath $$LogPath -Append -Encoding utf8 } }; $$exitCode = $$LASTEXITCODE; if ($$LogPath) { '[venv] exit=' + $$exitCode | Out-File -FilePath $$LogPath -Append -Encoding utf8 } } catch { if ($$LogPath) { $$_.ToString() | Out-File -FilePath $$LogPath -Append -Encoding utf8 }; Write-Host $$_.ToString(); $$exitCode = 1 }; exit $$exitCode$\r$\n"
!endif
  FileClose $R0
  StrCpy $R7 "${PYTHON_VERSIONS_ACCEPTED}"
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -LogPath "$INSTDIR\\EmicQDA-install-${BUILD}.log" -Versions "$R7"' $0
  Push "venv_exit=$0"
  Call AppendInstallLog
  ; Verificar por resultado: la ventana puede devolver error al cerrar; si el venv existe, continuar
  IfFileExists "$VenvPath\Scripts\python.exe" venv_ps1_ok
  MessageBox MB_ICONSTOP "No se pudo crear el entorno virtual (código $0). Verificá que Python esté instalado (registro o PATH). Revisá el log en la carpeta de instalación." /SD IDOK
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
  FileWrite $R0 "param([string]$$VenvPath, [string]$$PackageName, [string]$$LogPath, [switch]$$UpgradePip)$\r$\n"
  FileWrite $R0 "try { $$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(80, 30); $$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(80, 30) } catch {}$\r$\n"
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
  FileWrite $R0 "if ($$UpgradePip) { & $$py -m pip install --upgrade pip 2>&1 | ForEach-Object { Write-Host $$_; SafeLog $$_ } }$\r$\n"
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
  StrCpy $R2 "$INSTDIR\EmicQDA-install-${BUILD}.log"
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$R9" -VenvPath "$VenvPath" -PackageName "${ONTOLOGY_WHL}" -LogPath "$R2" -UpgradePip' $0
  Push "pip_ontology_whl_exit=$0"
  Call AppendInstallLog
  ; Verificar por resultado: las ventanas pueden devolver error al cerrar; si el paquete está instalado, continuar
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "& $\'$VenvPath\Scripts\python.exe$\' -m pip show ontology_explorer"' $0
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
  ExecWait '"$SYSDIR\\WindowsPowerShell\\v1.0\\powershell.exe" -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "& $\'$VenvPath\Scripts\python.exe$\' -m pip show obsidian_qda_suite"' $0
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
    CopyFiles /SILENT $DebugLogPath "$INSTDIR\\EmicQDA-install-nsis-${BUILD}.log"
  ; Volcar el log de la ventana de detalles (todo lo que vio el usuario en "Detalles")
  Push "$INSTDIR\\EmicQDA-install-details-${BUILD}.log"
  Call DumpLog
  ; Eliminar directorio temporal (scripts, assets copiados); los logs quedan en $INSTDIR
  RMDir /r "$TempDir"
  ; Registrar ruta, versión y build instalados para reutilizar (actualizador, detección, etc.)
  WriteRegStr HKCU "Software\Emic-QDA" "InstallPath" "$INSTDIR"
  WriteRegStr HKCU "Software\Emic-QDA" "Version" "${VERSION}"
  WriteRegStr HKCU "Software\Emic-QDA" "Build" "${BUILD}"
SectionEnd

; Al mostrar la página de componentes: si están instalados, "ya instalado" y solo lectura; si no, Python, Obsidian, Zotero y FFmpeg aparecen marcados.
Function ComponentsPageShow
  StrCmp $ObsidianInstalled "1" 0 obsidian_mark_selected
    SectionSetText ${SEC_OBS} "Obsidian (ya instalado)"
    SectionSetFlags ${SEC_OBS} ${SF_RO}
  Goto obsidian_done
  obsidian_mark_selected:
    SectionSetFlags ${SEC_OBS} ${SF_SELECTED}
  obsidian_done:
  StrCmp $PythonInstalled "1" 0 python_mark_selected
    SectionSetText ${SEC_PY} "Python (ya instalado)"
    SectionSetFlags ${SEC_PY} ${SF_RO}
  Goto python_done
  python_mark_selected:
    SectionSetFlags ${SEC_PY} ${SF_SELECTED}
  python_done:
  StrCmp $FFmpegInstalled "1" 0 ffmpeg_mark_selected
    SectionSetText ${SEC_FFMPEG} "FFmpeg (ya instalado)"
    SectionSetFlags ${SEC_FFMPEG} ${SF_RO}
  Goto ffmpeg_done
  ffmpeg_mark_selected:
    SectionSetFlags ${SEC_FFMPEG} ${SF_SELECTED}
  ffmpeg_done:
  StrCmp $ZoteroInstalled "1" 0 zotero_mark_selected
    SectionSetText ${SEC_ZOT} "Zotero (opcional - ya instalado)"
    SectionSetFlags ${SEC_ZOT} ${SF_RO}
  Goto zotero_done
  zotero_mark_selected:
    SectionSetFlags ${SEC_ZOT} ${SF_SELECTED}
  zotero_done:
FunctionEnd
