# Guía de instalación — Emic QDA Suite

Esta guía describe los pasos para instalar **Emic QDA Suite** en Windows usando el instalador oficial.

---

# Emic QDA Installer (NSIS)


  <img src="installer\img\logo-emic.png" alt="Emic QDA logo" width="550"/>

<!--
Note: The <p align="center">...</p> HTML with <img> works in GitHub README files.
If you only want a centered image, this is a common cross-platform way to do it.
Markdown's native image syntax (![alt](url)) does not support centering or resizing directly.
-->




## Requisitos del sistema

- **Sistema operativo:** Windows 10 o Windows 11 (64 bits).
- **Permisos:** Cuenta de usuario con permisos para instalar software (el instalador puede solicitar elevación UAC para instalar Python, Obsidian o Zotero).
- **Espacio en disco:** Al menos 1–2 GB libres (según los componentes que elijas).
- **Conexión a internet:** Necesaria para descargar Python, Obsidian y Zotero si el instalador los instala por ti.

---

## Cómo obtener el instalador

1. Descargá el archivo del instalador, por ejemplo:  
   `Emic-QDA-Installer-<versión>-<build>.exe`  
   (la versión y el build pueden variar; el nombre exacto lo indica quien te haya facilitado el instalador).

2. Guardalo en una carpeta de tu elección (por ejemplo, el Escritorio o Descargas).

---

## Pasos para instalar

### 1. Ejecutar el instalador

- Hacé **doble clic** en `Emic-QDA-Installer-....exe`.
- Si Windows SmartScreen muestra una advertencia (“Windows protegió su PC”):
  - Elegí **“Más información”** y luego **“Ejecutar de todas formas”**  
    (el instalador no está firmado por defecto; si tenés una versión firmada, esta advertencia puede no aparecer).
- Si Windows solicita permisos de administrador (UAC), aceptá para permitir la instalación de componentes como Python u Obsidian.

### 2. Pantalla de bienvenida

- Leé la bienvenida y hacé clic en **“Siguiente”**.

### 3. Selección de componentes

Elegí qué quieres que el instalador instale o configure:

| Componente | Descripción |
|------------|-------------|
| **Python** | Python 3.12 (necesario para las herramientas de línea de comandos del suite). Si ya tenés Python 3.12 o superior instalado, podés desmarcarlo. |
| **Obsidian** | Editor de notas para el vault de análisis cualitativo. Si ya tenés Obsidian instalado, podés desmarcarlo. |
| **Zotero** | Gestor de referencias. Opcional; desmarcalo si ya lo tenés o no lo usás. |
| **Repositorio (vault) EMIC-QDA** | Crea la carpeta del proyecto con la plantilla del suite (notas, configuración, etc.). Recomendado dejarlo marcado. |
| **FFmpeg** | Incluido solo si esta build del instalador lo trae; útil para medios. Podés desmarcarlo si no lo necesitás. |

![Selección de componentes](installer/img/seleccion-componentes.png)

Hacé clic en **“Siguiente”** cuando termines.

### 4. Carpeta de instalación

- El instalador sugiere por defecto: **Documentos\Emic-QDA**.
- Podés cambiar la ruta si querés otra ubicación.
- Todos los componentes del suite (vault, entorno virtual de Python, etc.) se instalarán dentro de esta carpeta.

Hacé clic en **“Siguiente”**.

### 5. Nombre del repositorio (vault)

- Indicá el **nombre** con el que querés que se cree la carpeta del vault dentro de la carpeta de instalación (por ejemplo: `Mi-Proyecto-QDA`).
- Si ya existe un vault con ese nombre en la misma ruta, el instalador puede preguntar si deseas sobrescribirlo; elegí según corresponda.

Hacé clic en **“Siguiente”**.

### 6. Instalación

- El instalador descargará e instalará los componentes marcados (Python, Obsidian, Zotero, etc.) y configurará el vault y los paquetes Python. La instalación se hace con **instaladores oficiales** de cada aplicación.
- Seguí los pasos de cada instalador que se abra; si no querés cambios específicos, **aceptá los valores por defecto**.
- **No marques** la opción “Abrir la aplicación al terminar” (o similar) al final de cada instalador; cerrando cada uno, el instalador de Emic QDA continuará con el siguiente componente.
- Podés seguir el progreso en la ventana de detalles del instalador de Emic QDA.
- No cierres el instalador principal hasta que termine.

### 7. Finalización

- Al finalizar, podés marcar la opción **“Abrir el nuevo repositorio de EMIC-QDA”** para abrir Obsidian al cerrar el asistente. Si es la **primera vez** que usás Obsidian, se abrirá el administrador de vaults: ahí elegí **“Abrir carpeta como repositorio”** y seleccioná la carpeta del repositorio que el instalador acaba de crear. Solo hay que hacer esto la primera vez; después el repositorio ya queda agregado a Obsidian.
- Hacé clic en **“Finalizar”**.

---

## Qué se instala

- **Carpeta base:** La que elegiste (por defecto `Documentos\Emic-QDA`).
- **Vault:** Una subcarpeta con el nombre que indicaste, con la plantilla del suite (archivos de Obsidian, notas, etc.).
- **Entorno virtual de Python:** Dentro de la carpeta del vault o de la instalación; ahí se instalan los paquetes `ontology_explorer` y `obsidian_qda_suite`.
- **Python / Obsidian / Zotero:** Solo si los seleccionaste y el instalador los descargó e instaló (Python suele instalarse en el sistema vía instalador oficial; Obsidian y Zotero en sus ubicaciones habituales).

---

## Posibles problemas

- **SmartScreen o antivirus:** Si el .exe no está firmado, Windows puede advertir. Usá “Más información” → “Ejecutar de todas formas” si confiás en el origen del instalador.
- **UAC:** Si no aceptás la elevación, la instalación de Python/Obsidian/Zotero puede fallar. Ejecutá de nuevo el instalador y aceptá cuando pida permisos.
- **Python ya instalado:** Si tenés otra versión de Python (por ejemplo 3.11), el instalador puede instalar 3.12 en paralelo; podés desmarcar “Python” si preferís usar solo tu instalación y cumplir vos mismo los requisitos del suite.
- **Log de instalación:** En caso de error, el instalador puede generar un archivo de log en `%TEMP%` (por ejemplo `EmicQDA-install-<build>.log`). Ese archivo ayuda a diagnosticar fallos.

---

## Desinstalación

- Para **desinstalar el instalador** (entrada en “Agregar o quitar programas”): usá **Configuración de Windows → Aplicaciones** y buscá “Emic QDA Suite” o el nombre del instalador.
- La **carpeta de instalación** (p. ej. `Documentos\Emic-QDA`) y su contenido (vault, entorno virtual) **no se borran** de forma automática; podés eliminarla a mano si querés quitar todo.
- **Python, Obsidian y Zotero** instalados por el instalador hay que desinstalarlos por separado desde “Agregar o quitar programas” si deseas eliminarlos.

---

## Resumen rápido

1. Descargar `Emic-QDA-Installer-....exe`.
2. Ejecutarlo y, si aparece, aceptar SmartScreen y UAC.
3. Siguiente → elegir componentes → elegir carpeta → poner nombre del vault → Siguiente.
4. Esperar a que termine y, si querés, abrir el repositorio en Obsidian al finalizar.

Para **crear o compilar** el instalador (desarrolladores), consultá el archivo `installer/README.md` del repositorio.
