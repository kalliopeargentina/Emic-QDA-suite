---
aliases: []
tags: []
date created: sábado, enero 31º 2026, 4:06:15 pm
date modified: lunes, febrero 2º 2026, 12:57:34 am
---

Claro, aquí tienes la traducción completa de la nota al español:

# Quadro: Bóveda de Plantilla

Por favor, visita la [documentación de Quadro](https://github.com/chrisgrieser/obsidian-quadro) para obtener información detallada sobre cómo usar *Quadro*.

Para obtener ayuda sobre Obsidian en general, consulta la [Documentación de Obsidian](https://help.obsidian.md/Home).

> [!summary] Contenido
> - [[#quadro-bóveda-de-plantilla|Quadro: Bóveda de Plantilla]]
> - [[#instalando-esta-bóveda|Instalando esta bóveda]]
> - [[#configuración-de-plugins-preconfigurados|Configuración de Plugins Preconfigurados]]
>   - [[#plugins-del-núcleo-de-obsidian|Plugins del Núcleo de Obsidian]]
>   - [[#plugins-de-la-comunidad|Plugins de la Comunidad]]
> - [[#demostración-de-qda-con-quadro|Demostración de QDA con Quadro]]
>   - [[#datos-de-ejemplo|Datos de Ejemplo]]
>   - [[#codificaciones-de-ejemplo|Codificaciones de Ejemplo]]
>   - [[#extracciones-de-ejemplo|Extracciones de Ejemplo]]
> - [[#guardar-rápidamente-contenido-web-en-obsidian|Guardar rápidamente contenido web en Obsidian]]
> - [[#usando-esta-bóveda-para-tu-propia-investigación|Usando esta bóveda para tu propia investigación]]
## Instalando esta bóveda
1. Asegúrate de que tu versión de Obsidian sea al menos la 1.5.8.
2. [Descarga esta bóveda](https://github.com/chrisgrieser/quadro-example-vault/releases/latest/download/quadro-example-vault.zip).
3. Abre el directorio `quadro-example-vault` como una bóveda de Obsidian. ([Si eres nuevo en Obsidian, consulta la Documentación de Obsidian sobre cómo hacerlo.](https://help.obsidian.md/Getting+started/Create+a+vault#Open+existing+folder))

## Configuración de Plugins Preconfigurados

### Plugins del Núcleo de Obsidian
- [Paleta de Comandos](https://help.obsidian.md/Plugins/Command+palette) (`cmd+p` en macOS, `ctrl+p` en Windows)
	- Lista todos los comandos disponibles, junto con sus respectivos atajos de teclado. Útil para que los nuevos usuarios busquen un comando.
	- Incluye una lista de todos los comandos relevantes para QDA en la parte superior.
- [Vista de Propiedades](https://help.obsidian.md/Plugins/Properties+view)
	- Ver todas las propiedades (= dimensiones de extracción) en toda la bóveda.
	- Haz clic izquierdo sobre ellas para buscarlas.
	- Haz clic derecho para renombrar dimensiones globalmente.
	- Accede a través de la Paleta de Comandos o el icono de "Caja" en la parte superior izquierda.
- [Recuperación de Archivos](https://help.obsidian.md/Plugins/File+recovery): Configurado para crear automáticamente ==copias de seguridad versionadas de cualquier archivo cada 5 minutos==. Accesible a través de la **Paleta de Comandos**.
- [Vista de Gráfico](https://help.obsidian.md/Plugins/Graph+view): Explora los enlaces entre todos los archivos.

> [!INFO]
> Para obtener ayuda sobre los plugins del núcleo, consulta la documentación enlazada.

### Plugins de la Comunidad

Listado según lo instalado en esta bóveda (`.obsidian/plugins` y `community-plugins.json`).

**QDA y flujo de trabajo**
- [Quadro](https://github.com/chrisgrieser/obsidian-quadro): Análisis cualitativo de datos (QDA) en Markdown. Botones en el extremo izquierdo para todos los comandos; pasa el cursor sobre ellos para ver qué hace cada uno.
- [Another Quick Switcher](https://github.com/tadashi-aikawa/obsidian-another-quick-switcher): Alternativa al cambiador rápido. Busca solo Archivos de Código con `alt+c`, solo Extracciones con `alt+e`, solo Datos con `alt+d`.
- [Multi Properties](https://github.com/technohiker/obsidian-multi-properties): Añade o edita propiedades en varias notas a la vez (clic derecho en carpeta o en una selección múltiple).
- [Semantic Canvas](https://github.com/aarongilly/obsidian-semantic-canvas-plugin): Crea grafos de conocimiento en Canvas y modifica propiedades de notas de forma gráfica. Ideal para codificación axial y explorar relaciones entre archivos.
- [Dynamic Highlights](https://github.com/nothingislost/obsidian-dynamic-highlights): Resalta texto según la selección del cursor o una búsqueda, con soporte para regex y vista previa en vivo.
- [Supercharged Links](https://github.com/mdelobelle/obsidian_supercharged_links): Añade propiedades y opciones de menú a los enlaces y les da estilo (color, iconos). La apariencia se configura con **Style Settings**.
- [Style Settings](https://github.com/mgmeyers/obsidian-style-settings): Ajusta variables CSS de temas, plugins y snippets desde la interfaz (sin tocar CSS a mano).

**IA, mapas y visualización**
- [Copilot](https://github.com/logancyang/obsidian-copilot): IA integrada: chatea con tu bóveda (`@vault`), genera texto/tablas/listas, resume notas o selecciones.
- [Map View](https://github.com/esm7/obsidian-map-view): Mapa interactivo a partir de notas con geolocalización; ver notas en el mapa y crear notas geolocalizadas.
- [Maps](https://obsidian.md): Plugin oficial de Obsidian para Bases: muestra notas como mapa interactivo en bases con datos enlazados.
- [Charts View](https://github.com/caronchen/obsidian-chartsview-plugin): Visualización de datos en Obsidian con gráficos basados en Ant Design Charts.
- [Chronos Timeline](https://github.com/Taitava/obsidian-chronos): Líneas de tiempo interactivas a partir de Markdown; útil para eventos, proyectos o entradas de diario.

**Referencias y escritura**
- [Zotero Integration](https://github.com/mgmeyers/obsidian-zotero-integration): Inserta e importa citas, bibliografías, notas y anotaciones de PDF desde Zotero. Fichas bibliográficas y notas de literatura.
- [Templater](https://github.com/SilentVoid13/Templater): Plantillas con variables y funciones (JavaScript). Automatiza creación de notas, coocurrencias, análisis de extracciones, etc.
- [Linter](https://github.com/platers/obsidian-linter): Formatea y estiliza notas (YAML, aliases, encabezados, espaciado, listas, bloques matemáticos, etc.) con reglas personalizables.

**Interfaz y comandos**
- [Commander](https://github.com/phibr0/obsidian-commander): Añade comandos, macros y scripts a la cinta lateral, barra de estado y menús contextuales.
- [Shell commands](https://github.com/Taitava/obsidian-shellcommands): Define comandos del sistema, asigna atajos y opcionalmente ejecución automática o por enlaces URI.

**Medios y archivos**
- [Media Extended](https://github.com/aidenlx/media-extended): Mejora la reproducción de video y audio: notas con marcas de tiempo, transcripciones, capturas de pantalla, control de YouTube y archivos locales.
- [Image Converter](https://github.com/xryul/obsidian-image-converter): Convierte, comprime, redimensiona y edita imágenes (WebP, JPG, PNG, HEIC, TIF); procesamiento por lotes y variables para nombres.
- [Custom File Viewer](https://github.com/peabody28/obsidian-custom-file-viewer): Abre archivos con aplicaciones externas según la extensión.
- [Attachment Management](https://github.com/trganda/obsidian-attachment-management): Personaliza la ruta de adjuntos por nota con variables y renombrado automático al cambiar.

**Exportar, comparar y explorador**
- [DOCX Exporter](https://github.com/Kanshurichard/obsidian-docx-exporter): Exporta notas a Word (.docx), con soporte en dispositivos móviles.
- [Docxer](https://github.com/Developer-Mike/obsidian-docxer): Importa Word: vista previa de .docx y conversión a Markdown.
- [File Diff](https://github.com/friebetill/obsidian-file-diff): Muestra las diferencias entre dos archivos.
- [File Explorer Note Count](https://github.com/ozntel/file-explorer-note-count): Muestra el número de notas bajo cada carpeta en el explorador de archivos.

**Resaltados y anotaciones**
- [Sidebar Highlights](https://github.com/trevware/obsidian-sidebar-highlights): Gestiona resaltados de texto, comentarios sobre resaltados y colecciones en la barra lateral.

> [!INFO]
> Para obtener ayuda sobre cada plugin, consulta la documentación enlazada o la página del plugin en Obsidian.

### Software Externos

- [FFmpeg](https://ffmpeg.org/): Una solución de línea de comandos para ==procesar, convertir y manipular archivos de video y audio==. Es el motor indispensable detrás de plugins como Media Extended, permitiendo la extracción de audio, creación de clips y asegurando la compatibilidad de medios en tu bóveda.

- [Zotero con Better BibTeX](https://www.zotero.org/): La combinación definitiva para la gestión de referencias académicas. Better BibTeX permite ==generar claves de cita (citekeys) únicas y estables==, que son la base para el plugin Zotero Integration, permitiendo crear notas de literatura robustas y automatizar la importación de metadatos.

- [Python](https://www.python.org/): Un lenguaje de programación versátil para ==crear scripts personalizados que interactúan directamente con los archivos de tu bóveda==. Es ideal para la automatización avanzada, como el procesamiento por lotes de notas, la integración con APIs externas o el análisis de datos, llevando tus flujos de trabajo más allá de lo que los plugins pueden ofrecer.

> [!INFO]
> Las descripciones anteriores ofrecen un resumen de cómo estas herramientas externas se integran con Obsidian. Para obtener una guía completa sobre su instalación, configuración y uso avanzado, se recomienda encarecidamente consultar la documentación oficial de cada programa, así como la de sus respectivos plugins (como Better BibTeX) y librerías.
## Demostración de QDA con Quadro
### Datos de Ejemplo
Algunos archivos de datos para fines de demostración, todos almacenados en la carpeta `Data`
- Dos entrevistas simuladas con desarrolladores de aplicaciones para iOS y Android.
	- [[Mock Interview A (iOS developer)]]
	- [[Mock Interview B (Android developer)]]
- Algunos artículos descargados con la [Extensión de Navegador MarkDownload](https://chromewebstore.google.com/detail/markdownload-markdown-web/pcmpcfapbekmbjjkdalcgopdkipoggdi)
	- [[Verge Article A]]
	- [[Verge Article B]]
	- [[Verge Article C]]

### Codificaciones de Ejemplo
Algunos códigos de ejemplo se pueden encontrar en la carpeta `Codes`.
- Los datos fueron codificados para problemas de , y .
- Se ha realizado una [[Example Code Co-occurrence]] ilustrativa para y 
- Puedes hacer clic en el Botón de Gráfico en la barra lateral izquierda (o `ctrl+g`/ `cmd+g`) para abrir la Vista de Gráfico. Se ha configurado para mostrar solo Archivos de Datos y Archivos de Código.
- Usando el plugin **Canvas** y el plugin **Semantic Canvas**, se pueden explorar las relaciones entre códigos. Aquí, se utiliza como un [[Axial Coding Example.canvas|Ejemplo de Codificación Axial]].

### Extracciones de Ejemplo
Algunas extracciones de ejemplo se pueden encontrar en la carpeta `Extractions`.
- Se han realizado algunas extracciones sobre problemas de compatibilidad y los resultados se han agregado en una hoja de cálculo. Para ver esa tabla, usa la **Paleta de Comandos** (`cmd+p` en macOS, `ctrl+p` en Windows): y busca/selecciona "Projects: Show projects".
- También hay una [[Example Search for Co-occurrent Extraction Dimensions]], extracciones donde dos dimensiones tienen un valor específico.

## Guardar rápidamente contenido web en Obsidian
Instala el [Obsidian Web Clipper](https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf), para guardar el contenido de un sitio web directamente en esta bóveda con un atajo de teclado. Consulta la documentación del Web Clipper para personalizar qué metadatos se deben añadir.

## Usando esta bóveda para tu propia investigación
Si quieres usar esta bóveda para tu propio proyecto, puedes simplemente eliminar el contenido de las carpetas `Codes`, `Extractions`, `Analysis` y `Data`. De esa manera, solo quedará la configuración de plugins preconfigurada.

> [!TIP]
> Quizás quieras renombrar esta bóveda, para que ya no se llame `quadro-template-vault`. Para hacerlo, haz clic en el pequeño icono de bóveda en la parte inferior izquierda, cierra esta ventana, haz clic derecho en `quadro-template-vault` y selecciona `Renombrar Bóveda…`. Después de eso, haz doble clic en tu bóveda recién nombrada para volver a abrirla.

---

> [!NOTE] Configuración de APIs y credenciales
> Algunos plugins requieren APIs o claves específicas para funcionar:
>
> - **Copilot**: Necesita APIs de IA configuradas. Usa la sección de configuración propia del plugin (Ajustes → Copilot) para definir el proveedor y las claves.
> - **Shell commands**: Para comandos que usen IA (p. ej. Hugging Face u otros servicios), hay que definir las variables (claves, tokens) en la sección de *Variables* del plugin (Ajustes → Shell commands → Variables).
> - **Chronos Timeline**: Utiliza el *keychain* de Obsidian para guardar credenciales de forma segura; no hace falta configurar claves en archivos externos.