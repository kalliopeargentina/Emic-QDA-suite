# PDF (apoyo a QDA) — Acciones QDA desde el contexto del PDF

## ¿Para qué sirve?
Lanzar desde el visor PDF **operaciones alineadas con Emic‑QDA** (asignación de códigos desde highlight, atributos de entidad, propiedades de relación, etc.) sin salir del documento cuando la UI del plugin lo muestra en **menú contextual** o **toolbar**.

## Resultado (qué obtenés)
- Registro en el vault en la sección correspondiente (códigos, entidades…) según la acción ejecutada y el highlight o anotación desde el que disparaste.

## Prerrequisitos típicos

1. Plugin **EMIC PDF++** (`Emic-pdf-plus`) habilitado.
2. **Emic‑QDA** habilitado y dominio/codebook donde corresponda.
3. Settings de PDF++ con opciíon de **Emic QDA file bridge** y flags de visibilidad (`emicQdaShowInContextMenu`, `emicQdaShowInToolbar`) activos según necesites.
4. En muchos casos **PDF edit / highlight real** en archivo requiere permisos y `enablePDFEdit` — revisá si tu acción concreta lo pide.

## Pasos genéricos

1. Abrí el PDF.
2. Creá o seleccioná un **highlight**/anotación texto.
3. Abrí **menú contextual** (clic derecho) — debería aparecer sección/group **Emic QDA** si está habilitado.
4. Elegí una acción disponible (nombre exacto depende de build: asignación código, etc.).
5. Seguí el modal (p.ej. picker de codebook/código, formulario de propiedades lit. de entidad, etc.).
6. Confirmá y verificá en el destino (nota de código / entidad / sidebar de highlights).

## Si no ves el menú Emic QDA

1. Settings → PDF++ → grupo **Emic QDA** → activá mostrar en menú/toolbar y **bridge**.
2. Verificá PDF **no external** si la acción necesita escribir archivo.
3. Leé aviso tipo “bridge off” — el propio plugin muestra notice si bridge deshabilitado explícitamente.

## Alcance de este capítulo

Aquí **no** listamos patches internos ni colas de escritura diferida al PDF; sólo el flujo observable: *selección → menú → modal → resultado*.

Para copiar citas ver [[copiar_citas_y_enlaces_desde_pdf]]. Núcleo QDA pleno: volvé a [[03-Flujos-de-trabajo/00-Mapa-de-flujos]].
