module.exports = async function () {
  const toNums = (lat, lon) => {
    const la = Number(lat);
    const lo = Number(lon);
    if (!Number.isFinite(la) || !Number.isFinite(lo)) return [null, null];
    return [la, lo];
  };

  // GPS first
  try {
    const pos = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 12000,
        maximumAge: 60000,
      });
    });

    return toNums(pos.coords.latitude, pos.coords.longitude);
  } catch (e) {
    // fall back
  }

  // IP fallback (CORS-friendly)
  try {
    const r = await fetch("https://ipwho.is/");
    const d = await r.json();
    if (d && d.success === false) return [null, null];
    return toNums(d.latitude, d.longitude);
  } catch (e) {
    return [null, null];
  }
};
