---
date: <% tp.date.now("YYYY-MM-DD") %>
location: <% tp.user.getLocation() %>
<%*
const [lat, lon] = await tp.user.getCoordinates();

if (Number.isFinite(lat) && Number.isFinite(lon)) {
  tR += `coordinates:\n  - ${lat}\n  - ${lon}\n`;
} else {
  // either write nothing, or write an empty value
  // tR += `coordinates: []\n`;
}
%>
icon: notebook
color: blue
data-type: Nota de Campo
---


