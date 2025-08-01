import { createQueue } from '../queue/createQueue.js';
import { pushToQueue } from '../queue/sendQueue.js';
(async function testPanchangEngine() {
  console.log("🧪 Creating PanchangQueue...");
  await createQueue();
  console.log("📤 Sending queued messages...");
  await pushToQueue();
  console.log("✅ Panchang flow tested successfully.");
})();
