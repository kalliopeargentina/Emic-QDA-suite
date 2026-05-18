# Núcleo QDA — Crear y cambiar el codebook activo

## ¿Para qué sirve?
Definir y administrar el **libro de códigos** (codebook) con el cual vas a codificar tus datafiles. Cambiar de codebook cuando trabajás distintas fases, proyectos o equipos.

## Resultado (qué obtenés)
- Un **codebook** disponible con su `Codebook Definition` (definición).
- Un **codebook activo** reconocible en la interfaz (según tu plantilla EMIC, aparece en menú y/o status bar).

## Dónde aparece en la UI (según material del manual)

Según [[01-Interfase-de-usuario]], en la ficha de un **código** hay una barra de íconos; el último abre el **menú del libro de códigos** con opciones entre otras:

- *Cambiar libro de códigos activo*
- *Crear definición del libro de códigos*
- *Crear múltiples códigos*, *Eliminar libro de códigos*
- exportaciones y vistas de resumen

También podés localizar los mismos comandos en la **Command palette** buscando texto en tu idioma configurado (nombre del comando depende de `settings.language` del núcleo).

## Pasos — crear un codebook (primera vez)

1. Abrí **Códigos** en la barra lateral o una ficha existente de código.
2. Abrí el **menú del libro de códigos**.
3. Ejecutá **Create codebook definition** / *Crear definición del libro de códigos*.
4. Completá nombre/identificador si el diálogo lo pide — confirmá creación.

## Pasos — cambiar el codebook activo

1. Menú del libro de códigos → **Switch active codebook** / *Cambiar libro de códigos activo*.
2. Seleccioná el codebook de la lista.
3. Confirmá antes de codificar que el nuevo codebook aparece seleccionado (evita código “mezclado” entre libros durante una sesión).

## Pasos eliminar libro (con cuidado)

1. Backup del vault.
2. Menú → **Delete codebook**.
3. Leé advertencias: elimina estructuras y vínculos asociados según comportamiento actual del plugin — confirmá sólo si entendiste el alcance.

## Creación masiva de códigos

Desde menú/codebook usar **Bulk create new Code Files** si necesitás importar desde lista (por ejemplo después de brainstorm en planilla externa adaptada).

## Problemas comunes

| Síntoma | Qué revisar |
|--------|---------------|
| “No encuentro menu” | Abrí una **ficha de código** válida dentro de ese codebook (`Códigos/...`). |
| Codebook equivocado activo | `Switch active codebook`. |
| Códigos no aparecen después de crear definición | Revisá que estés dentro de carpeta esperada (`Códigos/` del proyecto según tutorial). |

Referencia rápida: [[04-Referencia-por-modulo/emic-qda]] • siguiente capítulo: [[codificar_parrafos_asignar_y_quitar]].
