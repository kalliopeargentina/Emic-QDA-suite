--[[ pandoc `
  --lua-filter="obsidian.lua" `
  --lua-filter="pagebreak-between-files.lua" `
  --file-scope `
  --resource-path=".;D:\Dropbox\Zettlekasten\Antropocaos;D:\Dropbox\Zettlekasten\Antropocaos\attachments\Abity+;D:\Dropbox\Zettlekasten\Antropocaos\assets" `
  (ls "D:\Dropbox\Zettlekasten\Antropocaos\Temas\StartUps\Abity+\Crunchbase\*.md") `
  -o crunchbase.docx
 ]]
-- 1) Convert Obsidian embeds ![[...]] to ![](...)
function Para(p)
  local txt = pandoc.utils.stringify(p)
  local changed = false

  txt = txt:gsub("!%[%[([^%]|]+)%s*|?[^%]]*%]%]", function(target)
    changed = true
    target = target:gsub("^%s+", ""):gsub("%s+$", "")
    if not target:match("^https?://") then
      target = target:gsub("%%20", " ")  -- decode local %20
    end
    return "![](" .. target .. ")"
  end)

  if changed then
    return pandoc.read(txt, "markdown").blocks
  else
    return p
  end
end

-- 2) Fix wrong sizing for remote images
-- Clamp only Crunchbase thumbnail-style remote images
function Image(el)
  local src = el.src or ""

  if src:match("^https?://") then
    -- Heuristic: Crunchbase thumbnails often include c_thumb or w_50 / h_50 params
    if src:match("c_thumb") or src:match("[?&]w_50") or src:match("[?&]h_50") then
      el.attributes.width = "1.5cm"  -- small avatar size in Word
      el.attributes.height = "1.5cm"
    end
  end

  return el
end

