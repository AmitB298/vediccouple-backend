const express = require('express');
const router = express.Router();
const inviteController = require('../controllers/inviteController');
router.post('/create', inviteController.createInviteCode);
router.post('/validate', inviteController.validateInviteCode);
module.exports = router;
