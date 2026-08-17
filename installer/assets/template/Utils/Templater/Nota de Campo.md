<%*
let lat = null, lon = null;
let locationStr = "Unknown location";

// 1. Check Hardware GPS (will fail quietly to IP lookup on desktop)
try {
  const pos = await new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject, {
      enableHighAccuracy: true,
      timeout: 3000,
      maximumAge: 60000,
    });
  });
  lat = Number(pos.coords.latitude);
  lon = Number(pos.coords.longitude);
} catch (e) {}

// 2. Fallback to a completely unauthenticated, CORS-safe IP API
if (!lat || !lon) {
  try {
    const r = await fetch("http://ip-api.com/json/");
    const d = await r.json();
    if (d && d.status === "success") {
      lat = Number(d.lat);
      lon = Number(d.lon);
      locationStr = `${d.city}, ${d.regionName}, ${d.country}`;
    }
  } catch (e) {}
}

// 3. Build the safe coordinate block dynamically
let coordsYaml = "";
if (Number.isFinite(lat) && Number.isFinite(lon)) {
  coordsYaml = `\ncoordinates:\n  - ${lat}\n  - ${lon}`;
}

// 4. Construct the complete, clean Frontmatter array out of sight of the Linter
let output = `---
date: ${tp.date.now("YYYY-MM-DD")}
location: ${locationStr}${coordsYaml}
icon: notebook
color: blue
data-type: Nota de Campo
---`;

tR += output;
-%>