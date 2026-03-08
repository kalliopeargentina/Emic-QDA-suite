<%*
// Carpetas desde Emic-QDA (fallback a valores por defecto si el plugin no está cargado)
const emic = app.plugins?.plugins?.['emic-qda'];
const EXTRACTIONS_FOLDER = emic?.settings?.extraction?.folder ?? "Extractions";
const ANALYSIS_FOLDER = emic?.settings?.analysis?.folder ?? "Analysis";

// 1. Carpeta principal a escanear = carpeta de extracciones de Emic-QDA
const FOLDER_TO_SCAN = EXTRACTIONS_FOLDER;

// 2. Obtener el objeto de la carpeta de extracciones.
const extractionsFolder = app.vault.getAbstractFileByPath(FOLDER_TO_SCAN);

// 3. Validar que la carpeta de extracciones existe y es una carpeta.
if (!extractionsFolder || !extractionsFolder.children) {
    new Notice(`❌ Error: La carpeta "${FOLDER_TO_SCAN}" no fue encontrada.`, 5000);
    return ""; // Detener y no dejar contenido
}

// 4. Obtener los nombres de todas las subcarpetas.
const subfolderNames = extractionsFolder.children
    .filter(child => child.children)
    .map(folder => folder.name);

// 5. Validar que existen subcarpetas.
if (subfolderNames.length === 0) {
    new Notice(`ℹ️ No se encontraron subcarpetas en "${FOLDER_TO_SCAN}".`, 5000);
    return ""; // Detener y no dejar contenido
}

// 6. Mostrar un prompt (suggester) para que el usuario elija una carpeta.
const selectedFolderName = await tp.system.suggester(subfolderNames, subfolderNames, "Selecciona una carpeta de extracción:");

// 7. Si el usuario cancela, detener el script.
if (!selectedFolderName) {
    new Notice("Operación cancelada.");
    // Devolvemos una cadena vacía para que la nota temporal no tenga contenido y pueda ser borrada fácilmente.
    return "";
}

// 8. Preparar el nombre y la ruta del nuevo archivo.
const newFileTitle = `Extraction Overview – ${selectedFolderName}`;
const newFilePath = `/${ANALYSIS_FOLDER}/${newFileTitle}.md`;

// 9. Comprobar si el archivo ya existe para evitar duplicados.
const existingFile = app.vault.getAbstractFileByPath(newFilePath);
if (existingFile) {
    new Notice(`⚠️ El archivo "${newFileTitle}" ya existe. Abriéndolo.`, 5000);
    app.workspace.getLeaf().openFile(existingFile);
    // IMPORTANTE: Devolvemos una cadena vacía. La nota temporal quedará en blanco
    // y el foco se moverá al archivo existente. El usuario puede cerrar la nota temporal.
    return "";
}

// 10. Definir el contenido de la nueva nota.
const content = `_Este archivo se actualiza automáticamente, cualquier cambio manual que se le haga se perderá._

> [!INFO]
> Puedes usar la propiedad "filter" del bloque de código para mostrar solo valores específicos. Haz clic en el ícono \`</>\` para editar el filtro, por ejemplo: \`filter: 'word'\`, y mueve el cursor fuera del bloque de código. (Déjalo vacío para mostrar todos los valores.)

\`\`\`emic-qda-extractiontype-overview
extraction-type: "${selectedFolderName}"
filter: ""
\`\`\`
`;

// 11. ¡LA MAGIA! Mover y renombrar la nota actual a su destino final.
await tp.file.move(newFilePath);
new Notice(`✅ Archivo creado: ${newFileTitle}`);

// 12. Devolver el contenido para que se inserte en la nota (que ahora está en la ubicación correcta).
return content;
%>