{% persist "annotations" %}
{% set anns = annotations %}
{% if anns and anns.length > 0 %}
### Imported on {{importDate | format("YYYY-MM-DD h:mm a")}}

{# ---------- collect dynamic code list from tags ---------- #}
{% set CODES = [] %}
{% for a in anns %}
  {# get highlight body (only highlights) #}
  {% set body = "" %}
  {% if a.text %}{% set body = a.text %}{% endif %}
  {% if body == "" and a.annotatedText %}{% set body = a.annotatedText %}{% endif %}
  {% if body == "" and a.highlight %}{% set body = a.highlight %}{% endif %}
  {% if body == "" and a.annotationText %}{% set body = a.annotationText %}{% endif %}
  {% if body == "" and a.content %}{% set body = a.content %}{% endif %}
  {% if body == "" and a.selection %}{% set body = a.selection %}{% endif %}

  {% if body != "" and a.tags %}
    {% if a.tags.length and a.tags[0] and (a.tags[0].tag is not undefined) %}
      {# tags are objects: [{tag:"..."}] #}
      {% for t in a.tags %}
        {% if t and t.tag %}
          {% set code = t.tag | trim %}
          {% if code and not (code in CODES) %}{% set CODES = CODES.concat([code]) %}{% endif %}
        {% endif %}
      {% endfor %}
    {% elif a.tags.length %}
      {# tags are strings: ["...","..."] #}
      {% for t in a.tags %}
        {% if t %}
          {% set code = t | trim %}
          {% if code and not (code in CODES) %}{% set CODES = CODES.concat([code]) %}{% endif %}
        {% endif %}
      {% endfor %}
    {% else %}
      {# single string (cannot split in this templater) -> treated as one tag #}
      {% set code = a.tags | trim %}
      {% if code and not (code in CODES) %}{% set CODES = CODES.concat([code]) %}{% endif %}
    {% endif %}
  {% endif %}
{% endfor %}

{% set CODES = CODES | sort %}

{# ---------- render per code (multi-membership when tags are arrays) ---------- #}
{% for code in CODES %}
### {{ code }}

{% for a in anns %}
  {% set body = "" %}
  {% if a.text %}{% set body = a.text %}{% endif %}
  {% if body == "" and a.annotatedText %}{% set body = a.annotatedText %}{% endif %}
  {% if body == "" and a.highlight %}{% set body = a.highlight %}{% endif %}
  {% if body == "" and a.annotationText %}{% set body = a.annotationText %}{% endif %}
  {% if body == "" and a.content %}{% set body = a.content %}{% endif %}
  {% if body == "" and a.selection %}{% set body = a.selection %}{% endif %}

  {% if body != "" and a.tags %}
    {% set belongs = false %}
    {% if a.tags.length and a.tags[0] and (a.tags[0].tag is not undefined) %}
      {# objects[] #}
      {% for t in a.tags %}
        {% if t and t.tag and (t.tag | trim) == (code | trim) %}{% set belongs = true %}{% endif %}
      {% endfor %}
    {% elif a.tags.length %}
      {# strings[] #}
      {% for t in a.tags %}
        {% if t and (t | trim) == (code | trim) %}{% set belongs = true %}{% endif %}
      {% endfor %}
    {% else %}
      {# single string: only exact equality (no multi-split possible here) #}
      {% if (a.tags | trim) == (code | trim) %}{% set belongs = true %}{% endif %}
    {% endif %}

    {% if belongs %}
      {# Zotero link #}
      {% set page = a.pageLabel or null -%}
      {% if a.attachment and a.attachment.itemKey %}
        {% set base = "zotero://open-pdf/library/items/" + a.attachment.itemKey -%}
        {% if page %}
          {% set pdfLink = base + "?page=" + page + "&annotation=" + a.id -%}
        {% else %}
          {% set pdfLink = base + "?annotation=" + a.id -%}
        {% endif %}
      {% else %}
        {% set pdfLink = null %}
      {% endif %}

{{ body }}{% if page %} *(p. {{page}})*{% endif %}{% if pdfLink %} [open]({{pdfLink}}){% endif %}
  {% if a.comment %}  
  **Note:** {{ a.comment }}
  {% endif %}

    {% endif %}
  {% endif %}
{% endfor %}

{% endfor %}

{# ---------- optional: UNCODED (highlights with NO tags at all) ---------- #}
### UNCODED
{% for a in anns %}
  {% set body = "" %}
  {% if a.text %}{% set body = a.text %}{% endif %}
  {% if body == "" and a.annotatedText %}{% set body = a.annotatedText %}{% endif %}
  {% if body == "" and a.highlight %}{% set body = a.highlight %}{% endif %}
  {% if body == "" and a.annotationText %}{% set body = a.annotationText %}{% endif %}
  {% if body == "" and a.content %}{% set body = a.content %}{% endif %}
  {% if body == "" and a.selection %}{% set body = a.selection %}{% endif %}

  {% set no_tags = (not a.tags) or (a.tags.length and a.tags.length == 0) %}
  {% if body != "" and no_tags %}
 {{ body }}{% if a.pageLabel %} *(p. {{a.pageLabel}})*{% endif %}
  {% if a.comment %}  
  **Note:** {{ a.comment }}
  {% endif %}
  {% endif %}
{% endfor %}

{% endif %}
{% endpersist %}