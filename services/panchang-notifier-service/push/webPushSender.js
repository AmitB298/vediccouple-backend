/**
 * Hardened webPushSender.js — safe logging + ESM export
 */
export function sendToWebPush(userId, title, body) {
  console.log(`🌐 [WebPush] Sent to: ${userId} — ${title}`);
  // Simulate web push logic
  return {
    status: "sent",
    user: userId,
    method: "web-push"
  };
}
