---
date: <% tp.date.now("YYYY-MM-DD") %>
location: <% tp.user.getLocation() %>
<%*
const [lat, lon] = await tp.user.getCoordinates();
tR += `coordinates:\n  - ${lat}\n  - ${lon}\n`;
%>
icon: document
color: grey
data-type: Documento
Actores: []
read: false
date:  <% tp.date.now("YYYY-MM-DD") %>
---




