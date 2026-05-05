<%*
const title = await tp.system.prompt("Título del memo");
if (!title) {
  new Notice("❌ No se ingresó título. Cancelado.");
  return;
}
// Define el nuevo nombre y la carpeta de destino
const folder = "Memos";
const sanitizedTitle = title.replace(/[\/\\:*?"<>|]/g, "-"); // limpia caracteres ilegales
const newFilePath = `${folder}/${sanitizedTitle}.md`;

// Si el archivo no está en la carpeta correcta, lo mueve
if (tp.file.path(true) !== newFilePath) {
  await tp.file.move(newFilePath);
}
%>---
date: <% tp.date.now("YYYY-MM-DD") %>
author: <% tp.frontmatter.author || "Marcos" %>
memo type: <% await tp.system.suggester(["Teórico", "Metodológico", "Reflexivo"], ["Teórico", "Metodológico", "Reflexivo"]) %>
related_data:
related_code:
related_extraction:
data-type: memo
Tags: memo
---

## 🧩 Contexto / Desencadenante
> ¿Qué motivó este memo? (p. ej., un código específico, una cita, un evento o un patrón en los datos, o simplemente la necesidad de hacer una síntesis o reflexión)

---

## 🔍 Descripción / Resumen de Observaciones
> Descripción de categoría, campo, evento, observaciones, interlocutores, reflexión teórica o metodológica.
---

## 💭 Interpretación / Reflexión Analítica
> ¿Qué podría significar esto? ¿Cómo se conecta con códigos, categorías o teorías existentes?  
> ¿Qué tensiones o relaciones surgen? ¿Que consecuencias tiene sobre el proceso de investigación?
---

## 🔗 Vínculos Conceptuales
> ¿Cómo se relaciona esto con otros memos, temas, códigos o dimensiones? ¿Sugiere fusionar, dividir o redefinir categorías? (Agregar vínculos a otros doumentos)
---

## 🧭 Próximos Pasos / Preguntas
> ¿A qué se le debe dar seguimiento? ¿Hay alguna hipótesis, pista o acción analítica sugerida por este memo?
---
