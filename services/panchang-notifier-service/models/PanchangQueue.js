import mongoose from "mongoose";
const schema = new mongoose.Schema({
  userId: String,
  timestamp: Date,
  payload: Object
});
export const PanchangQueue = mongoose.models.PanchangQueue || mongoose.model("PanchangQueue", schema);
