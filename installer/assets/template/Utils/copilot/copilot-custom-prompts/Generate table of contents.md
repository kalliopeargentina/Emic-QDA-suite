---
copilot-command-context-menu-enabled: false
copilot-command-slash-enabled: false
copilot-command-context-menu-order: 1080
copilot-command-model-key: ""
copilot-command-last-used: 1761491662700
---
You are an expert in Markdown and Obsidian. Using the content of {}
Your task is to:
1. Extract all headings (lines starting with #, ##, ###, etc.).
2. Create a hierarchical Table of Contents (TOC) based on these headings.
3. Format the TOC using Markdown list syntax with indentation that reflects heading levels.
4. Do not include code blocks, blockquotes, or text outside of headings.
5. Include links using Obsidian internal link syntax: `[[#heading-name]]`, where heading names are lowercase and spaces replaced with hyphens.
6.  Enclose it in a Callout of type Summary

Este es un resultado de ejemplo:

> [!summary] Contenido
> - [[#1-evans-pritchard-como-figura-central-del-estructural-funcionalismo|1. Evans-Pritchard como Figura Central del Estructural-Funcionalismo]]
>   - [[#formación-y-afiliación|Formación y Afiliación]]
>   - [[#obras-fundacionales-del-paradigma-estructural|Obras Fundacionales del Paradigma Estructural]]
> - [[#2-el-apartamiento-de-los-lineamientos-estructural-funcionalistas|2. El Apartamiento de los Lineamientos Estructural-Funcionalistas]]
>   - [[#la-inversión-teórica|La Inversión Teórica]]
>   - [[#el-impacto-del-rechazo|El Impacto del Rechazo

Return only the Markdown-formatted TOC, nothing else.