const mongoose = require('mongoose');
const FamilyProfileSchema = new mongoose.Schema({
  linkedUserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  familyName: String,
  location: String,
  introduction: String,
  members: [{
    name: String,
    relation: String,
    photoUrl: String
  }],
  visibility: { type: String, default: 'approved_matches_only' }
});
module.exports = mongoose.model('FamilyProfile', FamilyProfileSchema);
