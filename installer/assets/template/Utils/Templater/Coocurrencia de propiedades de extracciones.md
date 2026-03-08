<%*
// Carpetas desde Emic-QDA (fallback si el plugin no está cargado)
const emic = app.plugins?.plugins?.['emic-qda'];
const TARGET_FOLDER = emic?.settings?.analysis?.folder ?? "Analysis";
const EXTRACTIONS_FOLDER = emic?.settings?.extraction?.folder ?? "Extractions";
// --- FIN DE LA CONFIGURACIÓN ---

// --- PASO 1: OBTENER CLAVES DE PROPIEDAD DE LA CARPETA DE EXTRACCIONES ---
const allFiles = app.vault.getMarkdownFiles();
const extractionFiles = allFiles.filter(file => file.path.startsWith(EXTRACTIONS_FOLDER + "/"));

const propertyKeysSet = new Set();
extractionFiles.forEach(file => {
    const frontmatter = app.metadataCache.getFileCache(file)?.frontmatter;
    if (frontmatter) {
        Object.keys(frontmatter).forEach(key => propertyKeysSet.add(key));
    }
});
const propertyKeys = Array.from(propertyKeysSet).sort();

if (propertyKeys.length === 0) {
    new Notice(`❌ No se encontraron propiedades en las notas de la carpeta "${EXTRACTIONS_FOLDER}".`, 5000);
    return "";
}

// --- PASO 2: SOLICITAR LA INFORMACIÓN AL USUARIO ---

const prop1 = await tp.system.suggester(propertyKeys, propertyKeys, "1. Selecciona la PRIMERA propiedad:");
if (!prop1) { new Notice("Operación cancelada."); return ""; }

const value1 = await tp.system.prompt(`2. Introduce el valor para "${prop1}":`);
if (!value1) { new Notice("Operación cancelada."); return ""; }

const prop2 = await tp.system.suggester(propertyKeys, propertyKeys, "3. Selecciona la SEGUNDA propiedad:");
if (!prop2) { new Notice("Operación cancelada."); return ""; }

const value2 = await tp.system.prompt(`4. Introduce el valor para "${prop2}":`);
if (!value2) { new Notice("Operación cancelada."); return ""; }

// --- PASO 3: BUSCAR ARCHIVOS COINCIDENTES ---

const matchingFiles = [];
const lowerValue1 = value1.toLowerCase();
const lowerValue2 = value2.toLowerCase();

function checkProperty(frontmatter, prop, value) {
    const propValue = frontmatter[prop];
    if (propValue === undefined || propValue === null) {
        return false;
    }
    if (Array.isArray(propValue)) {
        return propValue.some(item => String(item).toLowerCase().includes(value));
    }
    return String(propValue).toLowerCase().includes(value);
}

for (const file of extractionFiles) {
    const frontmatter = app.metadataCache.getFileCache(file)?.frontmatter;
    if (frontmatter) {
        const match1 = checkProperty(frontmatter, prop1, lowerValue1);
        const match2 = checkProperty(frontmatter, prop2, lowerValue2);

        if (match1 && match2) {
            matchingFiles.push(file);
        }
    }
}

// --- PASO 4: CONSTRUIR LA NOTA CON LA TABLA ---

const newTitle = `Coocurrencia Extracciones - ${value1} (${prop1}) AND ${value2} (${prop2})`;
const newFilePath = `/${TARGET_FOLDER}/${newTitle}.md`;

const existingFile = app.vault.getAbstractFileByPath(newFilePath);
if (existingFile) {
    new Notice(`⚠️ El archivo ya existe. Abriéndolo.`, 5000);
    app.workspace.getLeaf().openFile(existingFile);
    return "";
}

await tp.file.move(newFilePath);
new Notice(`✅ Archivo creado: ${newTitle}`);

let content = `Resultados para la búsqueda de notas con **${prop1}: ${value1}** Y **${prop2}: ${value2}**.\n\n`;

if (matchingFiles.length > 0) {
    let table = "| Carpeta | Archivo | Fuente | Fecha de Extracción |\n|---|---|---|---|\n";
    matchingFiles.forEach(file => {
        const relativePath = file.parent.path.replace(EXTRACTIONS_FOLDER + '/', '');
        const frontmatter = app.metadataCache.getFileCache(file)?.frontmatter;

        let extractionSource = frontmatter && frontmatter['extraction-source'] ? frontmatter['extraction-source'] : 'N/A';
        if (Array.isArray(extractionSource)) {
            extractionSource = extractionSource.join(', ');
        }

        const extractionDate = frontmatter && frontmatter['extraction-date'] ? frontmatter['extraction-date'] : 'N/A';

        // --- CORRECCIÓN CLAVE AQUÍ ---
        // Se añade una barra invertida (\$ para escapar el carácter | en la salida de Markdown.
        const fileLink = `[[${file.path}\\|${file.basename}]]`;
        
        table += `| ${relativePath} | ${fileLink} | ${extractionSource} | ${extractionDate} |\n`;
    });
    content += table;
} else {
    content += "No se encontraron archivos que coincidan con los criterios de búsqueda.";
}

return content;
%>