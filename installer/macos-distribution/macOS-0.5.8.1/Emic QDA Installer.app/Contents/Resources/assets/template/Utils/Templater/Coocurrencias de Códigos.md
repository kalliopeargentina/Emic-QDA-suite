<%*
// Carpetas desde Emic-QDA (fallback si el plugin no está cargado)
const emic = app.plugins?.plugins?.['emic-qda'];
const sourceFolder = emic?.settings?.coding?.folder ?? "Codes";
const targetFolder = emic?.settings?.analysis?.folder ?? "Analysis";

// Resto de configuración (no definido en Emic-QDA)
const defaultSearchPath = emic?.settings?.data?.folder ?? "Data";
const folderToIgnore = "/pre-merge-backups/";
// --- END CONFIGURATION ---

// --- PATH RESOLUTION (supports subfolders) ---
// Emic-QDA settings may store either:
// - a vault-relative path (e.g. "Proyecto A/Códigos"), or
// - just a folder name (e.g. "Códigos") that can live under subfolders.
const trimSlashes = (p) => (p ?? "").trim().replace(/^\/+|\/+$/g, "");

function resolveFolderPath(folderOrPath) {
    const wanted = trimSlashes(folderOrPath);
    if (!wanted) return "";

    // Already a relative path
    if (wanted.includes("/")) return wanted;

    // Folder name: find matching folder segments in any markdown file paths
    const files = app.vault.getMarkdownFiles();
    const candidates = new Set();

    for (const f of files) {
        const parts = f.path.split("/");
        // iterate over folder segments only (exclude filename)
        for (let i = 0; i < parts.length - 1; i++) {
            if (parts[i] === wanted) {
                candidates.add(parts.slice(0, i + 1).join("/"));
            }
        }
    }

    if (candidates.size === 1) return [...candidates][0];
    if (candidates.size > 1) {
        // Choose the shortest path (closest to vault root) as a deterministic default
        return [...candidates].sort((a, b) => a.length - b.length)[0];
    }

    // Not found: fallback to original (keeps prior behavior)
    return wanted;
}
// --- END PATH RESOLUTION ---

const joinVaultPath = (folderPath, name) => folderPath ? `${folderPath}/${name}` : name;

const allFiles = app.vault.getMarkdownFiles();

// --- FILTRO MODIFICADO ---
// Ahora también excluye cualquier archivo dentro de una carpeta llamada "pre-merge-backups"
const sourceRoot = resolveFolderPath(sourceFolder);
const filesInFolder = sourceRoot 
    ? allFiles.filter(file => 
        file.path.startsWith(sourceRoot + "/") && 
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
const targetRoot = resolveFolderPath(targetFolder);
await tp.file.move(joinVaultPath(targetRoot, newTitle));

// --- USA LA CARPETA POR DEFECTO SIN PREGUNTAR ---
const searchPath = resolveFolderPath(defaultSearchPath);

const formattedTerm1 = `[[${term1}]]`;
const formattedTerm2 = `[[${term2}]]`;

// --- WIKILINK MATCHING (alias, path, display|target) ---
// Data notes often use [[Display|path/to/Code]] instead of [[Code]].
function normalizeWikiTarget(s) {
    return s.replace(/[#^].*$/, "").trim();
}

function basenameNoExt(p) {
    const last = p.split("/").pop() ?? p;
    return last.replace(/\.md$/i, "");
}

function wikiInnerMentionsCode(inner, term) {
    if (!inner) return false;
    const pipeIdx = inner.indexOf("|");
    const left = pipeIdx === -1 ? inner : inner.slice(0, pipeIdx);
    const right = pipeIdx === -1 ? "" : inner.slice(pipeIdx + 1);
    const candidates = [left, right].filter(Boolean).map(normalizeWikiTarget);
    for (const c of candidates) {
        if (basenameNoExt(c) === term) return true;
        if (c === term || c.endsWith("/" + term)) return true;
    }
    return false;
}

function lineMentionsCode(line, term) {
    const re = /\[\[([^\]]+)\]\]/g;
    let m;
    while ((m = re.exec(line))) {
        if (wikiInnerMentionsCode(m[1], term)) return true;
    }
    return false;
}
// --- END WIKILINK MATCHING ---

// --- SCRIPT LOGIC using Obsidian API ---

// Get all files in the specified search path
const pages = searchPath
    ? app.vault.getMarkdownFiles().filter(f => f.path.startsWith(searchPath + "/"))
    : app.vault.getMarkdownFiles();
let results = [];

for (const page of pages) {
    // Use Obsidian's API to read the file content
    const content = await app.vault.cachedRead(page);
    const lines = content.split('\n');

    for (const line of lines) {
        if (lineMentionsCode(line, term1) && lineMentionsCode(line, term2)) {
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