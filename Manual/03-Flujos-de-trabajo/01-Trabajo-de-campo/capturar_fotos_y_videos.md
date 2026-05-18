# Trabajo de campo — Capturar fotos y videos

## ¿Para qué sirve?
Registrar **evidencia visual** dentro del proyecto: fotografía y video desde cámara o adjuntos, embebidos en una nota de campo cuando corresponde.

## Resultado (qué obtenés)
- Archivos **PNG** / **WebM** (u otro formato que defina tu release) dentro del vault en la carpeta configurada del plugin **Emic‑Camera**.
- Si tenías abierta una nota activa al capturar, el embed del archivo queda insertado donde estaba el cursor.

## Pantallas donde operás

- **Ribbon** (columna lateral de Obsidian): ícono de **cámara** (tooltip según idioma).
- **Command palette** (`Ctrl+P` / `Cmd+P`): comandos relacionados con *Emic‑Camera* — por ejemplo **Open Emic‑Camera** / **Abrir Emic‑Camera**.
- Modal de cámara con botones para **grabar**, **snapshot**, etc.

## Pasos típicos (desktop — cámara en vivo)

1. Abrí la nota de campo donde querés registrar la evidencia (dejá el cursor donde insertar el embed).
2. Abrí Emic‑Camera desde el ribbon o el comando “Open / Abrir Emic‑Camera”.
3. Permití acceso a la cámara si el navegador/Electron lo solicita.
4. Opcional: cambiá de cámara si tenés más de una.
5. **Foto**: usá tomar fotograma (**snapshot**) → guarda PNG y embedded en la nota si hay nota activa.
6. **Video**: iniciá grabación → detené → archivo WebM guardado en la carpeta configurada y embed si corresponde.

## Pasos típicos (mobile — sobretodo Android)

La **vista en vivo** puede estar desactivada en Android por límites del dispositivo. En ese modo el modal prioriza:

- **Subir imagen**
- **Subir video**

Elegís el modo correcto para que la app nativa capture o elija archivo; el archivo se copia al vault y se embedding en la nota activa igual que en escritorio cuando aplica.

## Ajustes (Settings → plugin Emic‑Camera)

| Ajuste | Uso típico |
|--------|-----------|
| **Carpeta de guardado** | Ruta relativa dentro del vault (ej. `attachments/snaps`). Se crea si no existe. |
| **Ancho máximo embed** | Evita multimedia enorme en vista lectura (`0` = sin límite). |
| **Alto máximo embed** | Ídem en vertical. |

## Consejos
- Fotografías rápidas: snapshot + texto descriptivo al pie en la misma nota el mismo día.
- Videos cortos: reduce peso para sincronización (Dropbox, etc.).
- Sin nota abierta igual se guardan archivos en carpeta configurada con un **aviso** de ruta según comportamiento documentado del plugin.

## Problemas comunes

- No aparece cámara: permisos del SO/Obsidian; probá desde ribbon y desde command palette.
- En mobile no ves stream: esperado en algunos dispositivos; usá botones **Subir**.
- Embed demasiado grande: bajá `maxEmbedWidth` / `maxEmbedHeight` en Settings.

Siguientes pasos: [[adjuntar_material_existente]] → [[03-Flujos-de-trabajo/02-Codificacion-y-codebooks/codificar_parrafos_asignar_y_quitar]] cuando pases al análisis.
