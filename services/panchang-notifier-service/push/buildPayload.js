export function buildPayload(message) {
  return {
    title: `Namaste 🌞`,
    body: message.content,
    timestamp: new Date().toISOString()
  };
}
