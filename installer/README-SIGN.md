# Firmar el instalador (Build & Sign)

Variables de entorno que tenés que definir en **PowerShell** para poder ejecutar `build-and-sign.ps1` (compilar y firmar el instalador).

---

## Variables obligatorias

| Variable | Descripción |
|----------|-------------|
| **SIGNING_PFX_PATH** | Ruta completa al archivo del certificado (.pfx). Ejemplo: `D:\Dropbox\SoftProducts\Emic-QDA-Suite\installer\EmicQDA-CodeSign.pfx` |
| **SIGNING_PFX_PASSWORD** | Contraseña del archivo .pfx (la que elegiste al crear el certificado con `create-signing-cert.ps1`). |

---

## Cómo definirlas en PowerShell

**Una vez por sesión** (en la misma ventana de PowerShell donde vas a ejecutar el script):

```powershell
$env:SIGNING_PFX_PATH     = "D:\Dropbox\SoftProducts\Emic-QDA-Suite\installer\EmicQDA-CodeSign.pfx"
$env:SIGNING_PFX_PASSWORD = "tu_contraseña"
```

Reemplazá `tu_contraseña` por la contraseña real del .pfx. Reemplazá la ruta si tu certificado está en otra carpeta.

---

## Ejecutar compilar y firmar

Desde la carpeta `installer`, en la **misma sesión** donde definiste las variables:

```powershell
cd "D:\Dropbox\SoftProducts\Emic-QDA-Suite\installer"
.\build-and-sign.ps1
```

Para solo compilar **sin** firmar:

```powershell
.\build-and-sign.ps1 -SkipSign
```

---

## Primera vez: crear el certificado

Si todavía no tenés el archivo .pfx, generalo una sola vez:

```powershell
cd "D:\Dropbox\SoftProducts\Emic-QDA-Suite\installer"
.\create-signing-cert.ps1
```

Te pedirá una contraseña para el .pfx; esa misma es la que usás en **SIGNING_PFX_PASSWORD**.

---

## Resumen

1. Definir `SIGNING_PFX_PATH` y `SIGNING_PFX_PASSWORD` en PowerShell.
2. Ejecutar `.\build-and-sign.ps1` desde `installer/`.
