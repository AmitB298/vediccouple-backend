import fs from 'fs';
import path from 'path';
import Handlebars from 'handlebars';
import mongoose from 'mongoose';
import { SchedulerConfig } from '../config/scheduler.config.js';
import { fetchEligibleUsers } from '../utils/userFetcher.js';
import { fetchPanchangForUser } from '../utils/panchangFetcher.js';
import { getTimeInUserZone } from '../utils/timeUtils.js';
const PanchangQueue = mongoose.model('PanchangQueue', new mongoose.Schema({
  userId: mongoose.Schema.Types.ObjectId,
  date: String,
  timezone: String,
  messages: [
    {
      id: String,
      time: String,
      content: String,
      status: { type: String, default: 'pending' }
    }
  ],
  createdAt: { type: Date, default: Date.now }
}));
function loadTemplate(templateName) {
  const templatePath = path.resolve("templates", `${templateName}.hbs`);
  const content = fs.readFileSync(templatePath, 'utf-8');
  return Handlebars.compile(content);
}
export async function createQueue() {
  console.log("✅ Queue created successfully.");
  const users = await fetchEligibleUsers();
  const sunriseTemplate = loadTemplate('sunrise_blessing');
  const muhurtaTemplate = loadTemplate('muhurta_window');
  const eveningTemplate = loadTemplate('evening_ritual');
  const nightTemplate = loadTemplate('night_reflection');
  for (const user of users) {
    try {
      const today = new Date().toISOString().slice(0, 10);
      const panchang = await fetchPanchangForUser(user);
      const sunriseTime = getTimeInUserZone(panchang.sunrise, user.timezone);
      const abhijitTime = getTimeInUserZone(panchang.muhurta.abhijit.split('-')[0], user.timezone);
      const eveningTime = getTimeInUserZone("18:30", user.timezone);
      const nightTime = getTimeInUserZone("21:00", user.timezone);
      const messages = [
        {
          id: 'sunrise_blessing',
          time: sunriseTime,
          content: sunriseTemplate({ name: user.name, nakshatra: panchang.nakshatra })
        },
        {
          id: 'muhurta_window',
          time: abhijitTime,
          content: muhurtaTemplate({ muhurtaTime: panchang.muhurta.abhijit })
        },
        {
          id: 'evening_ritual',
          time: eveningTime,
          content: eveningTemplate({ mantra: panchang.recommendations.mantra })
        },
        {
          id: 'night_reflection',
          time: nightTime,
          content: nightTemplate({ dasha: panchang.dasha })
        }
      ];
      await PanchangQueue.findOneAndUpdate(
        { userId: user._id, date: today },
        {
          userId: user._id,
          date: today,
          timezone: user.timezone,
          messages
        },
        { upsert: true }
      );
      console.log("✅ Queue created successfully.");
    } catch (err) {
      console.error("❌ Failed to create queue for user:", err.message);
    }
  }
  console.log("✅ Queue created successfully.");
}
