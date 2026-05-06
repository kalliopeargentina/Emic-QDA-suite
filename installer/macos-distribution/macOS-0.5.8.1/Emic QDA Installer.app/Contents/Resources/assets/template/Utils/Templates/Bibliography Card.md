{%set y = "" -%}
{%if date == "1114916400000" -%}
  {%set y = "2005" -%}
{%elif date and date | int > 1000000000000 -%}
  {%set y = "1970" -%} {# fallback if it’s numeric but unexpected #}
{%endif -%}

---
title: "{{ title | trim }}"
shortTitle: "{{ shortTitle | default(title) | trim }}"
year: {% if y %} {{ y }}{% endif %}
entryType: "{{ itemType | capitalize }}"
venue: "{% if publicationTitle %}{{ publicationTitle }}{% elif proceedingsTitle %}{{ proceedingsTitle }}{% elif bookTitle %}{{ bookTitle }}{% else %}{{ publisher | default('') }}{% endif %}"
{# ==== AUTHORS (only author role; [] if none) ==== #}
authors:
{%set had_authors = false -%}
{%if creators and creators.length -%}
{%for c in creators -%}
{%if c.creatorType == "author" -%}
{%set lname = c.lastName | default('') -%}
{%set fname = c.firstName | default('') -%}
{%set corp  = c.name | default('') -%}
  - "{% if corp and not (lname or fname) %}{{ corp | replace('\"','\\\"') }}{% else %}{{ lname | trim }}{% if fname %}, {{ fname | trim }}{% endif %}{% endif %}"
{%set had_authors = true -%}
{%endif -%}
{%endfor -%}
{%endif -%}

{# ==== EDITORS (only editor role; [] if none) ==== #}
editors:
{%set had_editors = false -%}
{%if creators and creators.length -%}
{%for c in creators -%}
{%if c.creatorType == "editor" -%}
{%set lname = c.lastName | default('') -%}
{%set fname = c.firstName | default('') -%}
{%set corp  = c.name | default('') -%}
  - "{% if corp and not (lname or fname) %}{{ corp | replace('\"','\\\"') }}{% else %}{{ lname | trim }}{% if fname %}, {{ fname | trim }}{% endif %}{% endif %}"
{%set had_editors = true -%}
{%endif -%}
{%endfor -%}
{%endif -%}

{# ==== OTHER CREATORS (neither author nor editor) ==== #}
other_creators:
{%set had_others = false -%}
{%if creators and creators.length -%}
{%for c in creators -%}
{%if c.creatorType != "author" and c.creatorType != "editor" -%}
{%set lname = c.lastName | default('') -%}
{%set fname = c.firstName | default('') -%}
{%set corp  = c.name | default('') -%}
  - role: "{{ c.creatorType | default('unknown') }}"
    name: "{% if corp and not (lname or fname) %}{{ corp | replace('\"','\\\"') }}{% else %}{{ lname | trim }}{% if fname %}, {{ fname | trim }}{% endif %}{% endif %}"
{%set had_others = true -%}
{%endif -%}
{%endfor -%}
{%endif -%}

{# ==== COLLECTION (avoid [object Object]) ==== #}
{%set coll = "" -%}
{%if collections and collections.length -%}
  {%if collections[0].name -%}
    {%set coll = collections[0].name -%}
  {%elif collections[0] and (collections[0] is string) -%}
    {%set coll = collections[0] -%}
  {%endif -%}
{%endif -%}
collection: "{{ coll | default('') }}"
language: "{{ language | default('') }}"
doi: "{{ DOI | default('') }}"
isbn: "{{ ISBN | default('') }}"
url: "{{ url | default('') }}"
pages: "{{ pages | default('') }}"
volume: "{{ volume | default('') }}"
issue: "{{ issue | default('') }}"
publisher: "{{ publisher | default('') }}"
place: "{{ place | default('') }}"
tags: [{% for t in tags -%}
{{ '"' ~ (t.tag | default(t) | lower | replace(' ', '_') | replace('"','')) ~ '"' }}{% if not loop.last %}, {% endif %}{%endfor %}]
zoteroKey: "{{ key }}"
citekey: "{{ citekey | default(key) }}"

---

> [!info]+ **{{ title | trim }}**{% if y %} ({{ y }}){% endif %}
>  **Authors:** {%set printed = 0 -%}{%for c in creators if c.creatorType == "author" -%}{%set lname = c.lastName | default('') -%}{%set fname = c.firstName | default('') -%}{%set corp = c.name | default('') -%}{%if printed > 0 -%}; {% endif -%}{%if corp and not (lname or fname) -%}{{ corp }}{%else -%}{{ lname }}{% if fname %}, {{ fname }}{% endif %}{%endif -%}{%set printed = printed + 1 -%}{%endfor -%}{%if printed == 0 and creators and creators.length -%}{%for c in creators -%}{%set lname = c.lastName | default('') -%}{%set fname = c.firstName | default('') -%}{%set corp = c.name | default('') -%}{%if not loop.first -%}; {% endif -%}{%if corp and not (lname or fname) -%}{{ corp }}{%else -%}{{ lname }}{% if fname %}, {{ fname }}{% endif %}{%endif -%}{%endfor -%}{% endif %}
>  **Type:** {% if itemType == "journalArticle" -%}Journal article{% elif itemType == "conferencePaper" -%}Conference paper{% else -%}{{ itemType | capitalize }}{% endif -%}
>  **Venue:** {{ publicationTitle }}
>  **DOI:** {{ DOI }}
>  **Link:** {{ url }}
>  **Zotero:** [Open item](zotero://select/items/{{ libraryID }}_{{ key }})

> [!abstract] Abstract
>{{ abstractNote | default('_No abstract available._') }}


> [!cite] Citation
>- Pandoc: [@{{ citekey | default(key) }}]
>- APA: {{ bibliography | trim }}