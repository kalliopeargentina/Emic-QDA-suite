<%*
// Carpetas desde Emic-QDA (fallback si el plugin no está cargado)
const emic = app.plugins?.plugins?.['emic-qda'];
const TARGET_FOLDER = emic?.settings?.analysis?.folder ?? "Analysis";
const EXTRACTIONS_FOLDER = emic?.settings?.extraction?.folder ?? "Extractions";
// --- FIN DE LA CONFIGURACIÓN ---

// --- PATH RESOLUTION (supports subfolders) ---
const trimSlashes = (p) => (p ?? "").trim().replace(/^\/+|\/+$/g, "");

function resolveFolderPath(folderOrPath) {
    const wanted = trimSlashes(folderOrPath);
    if (!wanted) return "";

    if (wanted.includes("/")) return wanted;

    const files = app.vault.getMarkdownFiles();
    const candidates = new Set();

    for (const f of files) {
        const parts = f.path.split("/");
        for (let i = 0; i < parts.length - 1; i++) {
            if (parts[i] === wanted) {
                candidates.add(parts.slice(0, i + 1).join("/"));
            }
        }
    }

    if (candidates.size === 1) return [...candidates][0];
    if (candidates.size > 1) {
        return [...candidates].sort((a, b) => a.length - b.length)[0];
    }

    return wanted;
}

const extractionRoot = resolveFolderPath(EXTRACTIONS_FOLDER);
const targetRoot = resolveFolderPath(TARGET_FOLDER);

const joinVaultPath = (folderPath, name) => folderPath ? `${folderPath}/${name}` : name;
// --- END PATH RESOLUTION ---

// --- PASO 1: OBTENER CLAVES DE PROPIEDAD DE LA CARPETA DE EXTRACCIONES ---
const allFiles = app.vault.getMarkdownFiles();
const extractionFiles = extractionRoot
    ? allFiles.filter(file => file.path.startsWith(extractionRoot + "/"))
    : allFiles;

const propertyKeysSet = new Set();
extractionFiles.forEach(file => {
    const frontmatter = app.metadataCache.getFileCache(file)?.frontmatter;
    if (frontmatter) {
        Object.keys(frontmatter).forEach(key => propertyKeysSet.add(key));
    }
});
const propertyKeys = Array.from(propertyKeysSet).sort();

if (propertyKeys.length === 0) {
    new Notice(`❌ No se encontraron propiedades en las notas de la carpeta "${extractionRoot}".`, 5000);
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
const newFilePath = joinVaultPath(targetRoot, `${newTitle}.md`);

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
        const parentPath = file.parent?.path ?? "";
        const underExtraction =
            extractionRoot &&
            (parentPath === extractionRoot || parentPath.startsWith(extractionRoot + "/"));
        const relativePath = underExtraction
            ? (parentPath === extractionRoot ? "" : parentPath.slice(extractionRoot.length + 1))
            : parentPath;
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