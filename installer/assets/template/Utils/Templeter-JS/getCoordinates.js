module.exports = async function () {
  // Try GPS first
  try {
    const pos = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true,
        timeout: 5000,
      });
    });
    return [pos.coords.latitude, pos.coords.longitude];
  } catch (err) {
    // If GPS fails, fall back to IP-based geolocation
    try {
      const response = await fetch("https://ipapi.co/json/");
      const data = await response.json();
      return [data.latitude, data.longitude];
    } catch (e) {
      return [null, null];
    }
  }
};
