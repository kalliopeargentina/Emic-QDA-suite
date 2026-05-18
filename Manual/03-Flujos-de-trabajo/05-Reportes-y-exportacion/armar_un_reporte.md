# Reportes — Armar un reporte (compositor)

## ¿Para qué sirve?
Componer un **documento final** a partir de notas y carpetas del vault: estructura por nodos (nota/carpeta), orden, saltos de página y opciones de presentación antes de exportar.

## Resultado (qué obtenés)
- Un **proyecto de reporte** activo en la vista *Report Architect* / compositor (según Emic Report Architect / **Emic‑Reports**).

## Pasos (desde la interfaz)

1. Command palette → **Open report composer** (nombre exacto depende del idioma del plugin; buscá “report” o “composer”).
2. Se abre la vista dedicada del compositor.
3. Operaciones típicas (según UI del plugin):
   - **Agregar nota** al reporte (drag & drop o botón *add*).
   - **Agregar carpeta** para incluir secciones completas.
   - **Reordenar** nodos con arrastre.
   - Definir **page breaks**, **heading offset**, exclusión de TOC, etc. (ajustes en panel del compositor).
4. Guardá el proyecto (auto‑save o botón explícito según versión — si hay “Save now”, usalo antes de exportar).

## Relación con plantillas de estilo

El aspecto visual (tipografías, márgenes, callouts) no se define aquí sino en el **template de estilo** — ver [[templates_de_estilo]].

## Qué NO hace este paso

No genera aún el PDF/DOCX final; eso es [[exportar_a_pdf_y_docx]].

## Problemas comunes

- **No veo la vista compositor**: plugin deshabilitado o comando distinto — buscá “Report Architect”, “composer”.
- **Faltan notas**: verificá rutas y que las notas estén dentro del vault (no fuera).
- **Orden confuso**: usá la vista de árbol del proyecto y reordená nodos.

Siguiente: [[guardar_y_reutilizar_reportes]].
