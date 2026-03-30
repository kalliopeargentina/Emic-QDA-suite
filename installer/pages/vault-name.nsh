Function VaultNamePageCreate
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 18u "Nombre del vault:"
  Pop $0
  ${NSD_CreateText} 0 18u 100% 12u "emicqda"
  Pop $VaultNameInput

  ${NSD_CreateLabel} 0 38u 100% 30u "Se creará en: $INSTDIR"
  Pop $0

  nsDialogs::Show
FunctionEnd

Function VaultNamePageLeave
  ${NSD_GetText} $VaultNameInput $VaultName
  ${If} $VaultName == ""
    MessageBox MB_ICONEXCLAMATION "Ingresá un nombre para el vault." /SD IDOK
    Abort
  ${EndIf}

  Call ValidateVaultName

  StrCpy $VaultPath "$INSTDIR\$VaultName"
  CreateDirectory "$INSTDIR"
  Push "installdir=$INSTDIR"
  Call AppendInstallLog
  Push "vault_path_set"
  Call AppendInstallLog

  IfFileExists "$VaultPath\*.*" 0 +3
    MessageBox MB_ICONQUESTION|MB_YESNO "La carpeta ya existe. ¿Querés sobrescribirla?" /SD IDNO IDYES +2
      Abort
    StrCpy $OverwriteVault "1"
FunctionEnd
