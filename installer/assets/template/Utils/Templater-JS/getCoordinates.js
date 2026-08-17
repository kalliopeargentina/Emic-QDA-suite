module.exports = async function () {
  // 1. Try Hardware GPS First
  try {
    const pos = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 4000,
        maximumAge: 60000,
      });
    });
    const lat = Number(pos.coords.latitude);
    const lon = Number(pos.coords.longitude);
    if (Number.isFinite(lat) && Number.isFinite(lon)) return [lat, lon];
  } catch (e) {
    // GPS unavailable, proceed to IP fallback
  }

  // 2. CORS-Friendly IP Lookup (Using ip-api.com)
  try {
    const response = await fetch("http://ip-api.com/json/");
    const data = await response.json();
    if (data && data.status === "success") {
      return [Number(data.lat), Number(data.lon)];
    }
  } catch (e) {
    // Catch-all
  }

  return [null, null]; // Always returns an iterable array to stop the crash!
};