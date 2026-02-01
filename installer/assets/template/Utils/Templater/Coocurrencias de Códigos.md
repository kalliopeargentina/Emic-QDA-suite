<%*
// --- CONFIGURATION ---
const sourceFolder = "Codes"; 
const defaultSearchPath = "Data";
const targetFolder = "Analysis"; // <-- Carpeta de destino para la nota
const folderToIgnore = "/pre-merge-backups/"; // <-- Carpeta a ignorar
// --- END CONFIGURATION ---

const allFiles = app.vault.getMarkdownFiles();

// --- FILTRO MODIFICADO ---
// Ahora también excluye cualquier archivo dentro de una carpeta llamada "pre-merge-backups"
const filesInFolder = sourceFolder 
    ? allFiles.filter(file => 
        file.path.startsWith(sourceFolder + "/") && 
        !file.path.includes(folderToIgnore)
      )
    : allFiles.filter(file => !file.path.includes(folderToIgnore));
// --- FIN DE LA MODIFICACIÓN ---

const fileBasenames = filesInFolder.map(file => file.basename);

if (fileBasenames.length === 0) {
    new Notice("No se encontraron archivos en la carpeta de origen especificada (después de ignorar las copias de seguridad).");
    return;
}

const term1 = await tp.system.suggester(fileBasenames, fileBasenames, false, "Seleccione el PRIMER código:");
if (!term1) return;

const term2 = await tp.system.suggester(fileBasenames, fileBasenames, false, "Seleccione el SEGUNDO código:");
if (!term2) return;

// --- CÓDIGO PARA MOVER Y RENOMBRAR ---
const newTitle = `Coocurrencia entre ${term1} y ${term2}`;
await tp.file.move(`${targetFolder}/${newTitle}`);

// --- USA LA CARPETA POR DEFECTO SIN PREGUNTAR ---
const searchPath = defaultSearchPath;

const formattedTerm1 = `[[${term1}]]`;
const formattedTerm2 = `[[${term2}]]`;

// --- SCRIPT LOGIC using Obsidian API ---

// Get all files in the specified search path
const pages = app.vault.getMarkdownFiles().filter(f => f.path.startsWith(searchPath + "/"));
let results = [];

for (const page of pages) {
    // Use Obsidian's API to read the file content
    const content = await app.vault.cachedRead(page);
    const lines = content.split('\n');

    for (const line of lines) {
        if (line.includes(formattedTerm1) && line.includes(formattedTerm2)) {
            results.push({
                // Create a markdown link to the file
                fileLink: `[[${page.path}]]`, 
                lineText: line.trim()
            });
        }
    }
}

// --- GENERATE STATIC MARKDOWN TABLE ---

let table = "| Archivo | Cita |\n";
table += "|---|---|\n";

if (results.length > 0) {
    for (const r of results) {
        // Pipe characters within the line can break the table, so we replace them.
        const sanitizedLine = r.lineText.replace(/\|/g, "\\|");
        table += `| ${r.fileLink} | ${sanitizedLine} |\n`;
    }
} else {
    table = `No se encontraron coocurrencias para **${formattedTerm1}** y **${formattedTerm2}** en la carpeta "${searchPath}".`;
}

// Use tp.file.cursor() to insert the generated table
-%>
<%- table %>