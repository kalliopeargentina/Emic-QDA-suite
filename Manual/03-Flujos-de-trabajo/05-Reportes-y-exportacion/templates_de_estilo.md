# Reportes — Plantillas de estilo (style templates)

## ¿Para qué sirve?
Controlar la **tipografía, márgenes, colores, encabezados, TOC, portada** y demás presentación del reporte exportado sin tocar el contenido semántico de las notas.

## Resultado (qué obtenés)
- Archivos JSON de plantilla en la carpeta del vault configurada en **Settings → Emic Report Architect** (clave típica `templatesFolder`, por defecto algo como `Utils/Emic-Report-Arquitect` según release).
- Plantilla académica built‑in si tu release la incluye.

## Pasos — abrir el editor de plantillas

1. Command palette → **Open style template editor**.
2. Se abre la vista en un panel; podés combinar con **Open style preview** para ver cambios en vivo.

## Pasos — ajustar parámetros

En el editor recorré secciones (Encabezados, Página, Código, Callouts, etc.) — el video de [[01-Interfase-de-usuario]] muestra panel derecho con familias tipográficas e interlineado.

1. Modificá valores (tipografía, tamaños H1–H4, márgenes).
2. Guardá la plantilla con el botón / acción del editor.
3. Volvé al compositor y asigná esa plantilla al reporte activo (según UI de tu versión).

## Pasos — previsualizar estilo

1. Command palette → **Open style preview**.
2. Split con template editor si trabajás iterativamente.

## Qué no documentamos aquí

No se explica el motor interno de composición HTML/PDF; sólo **dónde tocar** en la UI.

Siguiente consumo: [[exportar_a_pdf_y_docx]].
