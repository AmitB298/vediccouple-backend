const authRoutes = require('./routes/authRoutes');
const familyProfileRoutes = require('./routes/familyProfileRoutes');
const inviteCodeRoutes = require('./routes/inviteCodeRoutes');
require('dotenv').config({ path: '../.env' });
const express = require('express');
const cors = require('cors');
const app = express();
app.use('/api/auth', authRoutes);
app.use(cors());
app.use('/api/auth', authRoutes);
app.use(express.json());
app.get('/', (req, res) => res.send('✅ VedicMatchMaking backend is running!'));
const PORT = process.env.NODE_PORT || 5000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
app.use('/api/auth', authRoutes);
app.use('/api/invite-codes', inviteCodeRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/family-profiles', familyProfileRoutes);
// ⭐️ To protect routes:
const { verifyToken } = require('./middleware/authMiddleware');
// app.use('/api/protected', verifyToken, yourProtectedRouter);
