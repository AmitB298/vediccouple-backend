export function getTimeInUserZone(time, timezone) {
  try {
    const zoned = new Date().toLocaleString("en-IN", { timeZone: timezone });
    return new Date(zoned);
  } catch (err) {
    return new Date(time);
  }
}
