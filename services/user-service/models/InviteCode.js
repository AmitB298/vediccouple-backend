const mongoose = require('mongoose');
const InviteCodeSchema = new mongoose.Schema({
  code: { type: String, unique: true },
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  expiresAt: Date,
  maxUses: Number,
  usedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }]
});
module.exports = mongoose.model('InviteCode', InviteCodeSchema);
