module.exports = async () => {
  const response = await fetch("https://ipwho.is/");
  const data = await response.json();

  if (data && data.success !== false) {
    return `${data.city}, ${data.region}, ${data.country}`;
  }

  return "Unknown location";
};
