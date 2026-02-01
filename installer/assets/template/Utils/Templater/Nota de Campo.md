---
date: <% tp.date.now("YYYY-MM-DD") %>
location: <% tp.user.getLocation() %>
<%*
const [lat, lon] = await tp.user.getCoordinates();
tR += `coordinates:\n  - ${lat}\n  - ${lon}\n`;
%>
icon: notebook
color: blue
data-type: Nota de Campo
---


