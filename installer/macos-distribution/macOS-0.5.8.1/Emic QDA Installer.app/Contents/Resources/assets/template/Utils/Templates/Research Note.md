{% persist "annotations" %}
{% set annotations = annotations | filterby("date", "dateafter", lastImportDate) -%}
{% if annotations.length > 0 %}
### Imported on {{importDate | format("YYYY-MM-DD h:mm a")}}

{% set last_page = "" -%}
{% for annotation in annotations -%}

{# ---------- Build page + link safely ---------- #}
{% set page = annotation.pageLabel or null -%}
{% if annotation.attachment and annotation.attachment.itemKey -%}
  {% set base = "zotero://open-pdf/library/items/" + annotation.attachment.itemKey -%}
  {% if page -%}
    {% set pdfLink = base + "?page=" + page + "&annotation=" + annotation.id -%}
  {% else -%}
    {% set pdfLink = base + "?annotation=" + annotation.id -%}
  {% endif -%}
{% else -%}
  {% set pdfLink = null -%}
{% endif -%}

{# ---------- Page separator ---------- #}
{% if last_page != "" and page and page != last_page -%}
---
{% endif -%}
{% if page and page != last_page -%}
##### Page {{page}}
{% set last_page = page -%}
{% endif -%}

{# ---------- Tags as plain comma-separated text ---------- #}
{% set tag_line = "" -%}
{% if annotation.tags -%}
  {% if annotation.tags.length and annotation.tags[0] and (annotation.tags[0].tag is not undefined) -%}
    {# objects[]: [{tag:"…"}] #}
    {% for t in annotation.tags -%}
      {% if t and t.tag -%}
        {% if tag_line != "" %}{% set tag_line = tag_line + ", " -%}{% endif -%}
        {% set tag_line = tag_line + (t.tag | trim) -%}
      {% endif -%}
    {% endfor -%}
  {% elif annotation.tags.length -%}
    {# strings[]: ["…","…"] #}
    {% for t in annotation.tags -%}
      {% if t -%}
        {% if tag_line != "" %}{% set tag_line = tag_line + ", " -%}{% endif -%}
        {% set tag_line = tag_line + (t | trim) -%}
      {% endif -%}
    {% endfor -%}
  {% else -%}
    {# single string; shown as-is #}
    {% set tag_line = annotation.tags | trim -%}
  {% endif -%}
{% endif -%}

{# ---------- Extract text (highlight or note) ---------- #}
{% set body = "" -%}
{% if annotation.text %}{% set body = annotation.text -%}{% endif -%}
{% if body == "" and annotation.annotatedText %}{% set body = annotation.annotatedText -%}{% endif -%}
{% if body == "" and annotation.highlight %}{% set body = annotation.highlight -%}{% endif -%}
{% if body == "" and annotation.annotationText %}{% set body = annotation.annotationText -%}{% endif -%}
{% if body == "" and annotation.content %}{% set body = annotation.content -%}{% endif -%}
{% if body == "" and annotation.selection %}{% set body = annotation.selection -%}{% endif -%}

{# ---------- Render: highlight box (quote) OR independent note box ---------- #}
{% if body -%}
{# Highlight -> colored callout box (tinted by annotation.color if present) #}
> [!quote{% if annotation.color %}|{{annotation.color}}{% endif %}] Highlight
>
> {{ body | nl2br | replace('\n','\n> ') }}{%if annotation.imageRelativePath %}
>
> ![[{{annotation.imageRelativePath}}]]{%endif -%}{%if annotation.ocrText %}
>
> {{ annotation.ocrText | replace('\n','\n> ') }}{%endif -%}{%if annotation.comment %}
>
> Note: {{ annotation.comment | nl2br | replace('\n','\n> ') }}{%endif -%}{%if tag_line != "" %}
>
> Tags: {{ tag_line }}{%endif -%}{%if pdfLink %}
>
> - {% if page %}(p. {{page}}){% else %}(note){% endif %} [open in PDF]({{pdfLink}}){%endif %}

{% elseif annotation.comment -%}
{# Independent note -> note callout #}
> [!note]
> {{ annotation.comment | nl2br | replace('\n','\n> ') }}{%if tag_line != "" %}
>
> Tags: {{ tag_line }}{%endif -%}{%if pdfLink %}
>
> - {% if page %}(p. {{page}}){% else %}(note){% endif %} [open in PDF]({{pdfLink}}){%endif %}

{% endif -%}

{% endfor -%}
{% endif -%}
{% endpersist %}