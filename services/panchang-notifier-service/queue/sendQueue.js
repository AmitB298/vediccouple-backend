import mongoose from "mongoose";
import { PanchangQueue } from "../models/PanchangQueue.js";
import { sendToFCM } from "../push/fcmSender.js";
import { sendToWebPush } from "../push/webPushSender.js";
export async function pushToQueue(userId, payload) {
  const entry = new PanchangQueue({
    userId,
    timestamp: new Date(),
    payload
  });
  await entry.save();
  await sendToFCM(userId, payload.title, payload.body);
  await sendToWebPush(userId, payload.title, payload.body);
}
