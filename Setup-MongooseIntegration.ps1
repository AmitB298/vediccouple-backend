<#
.SYNOPSIS
    Automates Node.js + Mongoose integration setup
.DESCRIPTION
    - Creates Mongoose config
    - Generates models
    - Generates routes
    - Modifies server.js
#>
param (
    [string]$ProjectRoot = "."
)
Write-Host "ðŸ› ï¸  Starting Node.js + MongoDB + Mongoose integration..."
$ConfigDir = Join-Path $ProjectRoot "config"
$ModelsDir = Join-Path $ProjectRoot "models"
$RoutesDir = Join-Path $ProjectRoot "routes"
$ServerFile = Join-Path $ProjectRoot "server.js"
New-Item -ItemType Directory -Force -Path $ConfigDir, $ModelsDir, $RoutesDir | Out-Null
# 1ï¸âƒ£ Create Mongoose connection file
$mongooseConfig = @"
const mongoose = require('mongoose');
const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/vedic_matchmaking', {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('âœ… MongoDB connected');
    } catch (err) {
        console.error('âŒ MongoDB connection error:', err);
        process.exit(1);
    }
};
module.exports = connectDB;
"@
$mongooseConfig | Out-File (Join-Path $ConfigDir "mongoose.js") -Encoding UTF8
Write-Host "âœ… Created: config/mongoose.js"
# 2ï¸âƒ£ Create Kundli model
$kundliModel = @"
const mongoose = require('mongoose');
const KundliSchema = new mongoose.Schema({
    name: String,
    birth_date: String,
    birth_time: String,
    birth_place: String,
    latitude: Number,
    longitude: Number,
    match_result: Object
});
module.exports = mongoose.model('Kundli', KundliSchema);
"@
$kundliModel | Out-File (Join-Path $ModelsDir "Kundli.js") -Encoding UTF8
Write-Host "âœ… Created: models/Kundli.js"
# 3ï¸âƒ£ Create User model
$userModel = @"
const mongoose = require('mongoose');
const UserSchema = new mongoose.Schema({
    name: String,
    email: String,
    password: String,
    kundli: { type: mongoose.Schema.Types.ObjectId, ref: 'Kundli' }
});
module.exports = mongoose.model('User', UserSchema);
"@
$userModel | Out-File (Join-Path $ModelsDir "User.js") -Encoding UTF8
Write-Host "âœ… Created: models/User.js"
# 4ï¸âƒ£ Create Match model
$matchModel = @"
const mongoose = require('mongoose');
const MatchSchema = new mongoose.Schema({
    person1: { type: mongoose.Schema.Types.ObjectId, ref: 'Kundli' },
    person2: { type: mongoose.Schema.Types.ObjectId, ref: 'Kundli' },
    result: Object
});
module.exports = mongoose.model('Match', MatchSchema);
"@
$matchModel | Out-File (Join-Path $ModelsDir "Match.js") -Encoding UTF8
Write-Host "âœ… Created: models/Match.js"
# 5ï¸âƒ£ Create Routes
$routesContent = @"
const express = require('express');
const router = express.Router();
const Kundli = require('../models/Kundli');
router.post('/save', async (req, res) => {
    try {
        const kundli = new Kundli(req.body);
        await kundli.save();
        res.json({ status: 'success', data: kundli });
    } catch (err) {
        console.error(err);
        res.status(500).json({ status: 'error', message: err.message });
    }
});
router.get('/all', async (req, res) => {
    try {
        const kundlis = await Kundli.find();
        res.json({ status: 'success', data: kundlis });
    } catch (err) {
        res.status(500).json({ status: 'error', message: err.message });
    }
});
module.exports = router;
"@
$routesContent | Out-File (Join-Path $RoutesDir "kundliRoutes.js") -Encoding UTF8
Write-Host "âœ… Created: routes/kundliRoutes.js"
# 6ï¸âƒ£ Ensure server.js includes integration
if (Test-Path $ServerFile) {
    $serverContent = Get-Content $ServerFile -Raw
    if ($serverContent -notmatch "connectDB") {
        $newContent = @"
const express = require('express');
const app = express();
require('dotenv').config();
app.use(express.json());
const connectDB = require('./config/mongoose');
connectDB();
const kundliRoutes = require('./routes/kundliRoutes');
app.use('/api/kundli', kundliRoutes);
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
"@
        $newContent | Out-File $ServerFile -Encoding UTF8
        Write-Host "âœ… Overwrote server.js with MongoDB integration"
    } else {
        Write-Host "âœ… server.js already includes connectDB"
    }
} else {
    $defaultServer = @"
const express = require('express');
const app = express();
require('dotenv').config();
app.use(express.json());
const connectDB = require('./config/mongoose');
connectDB();
const kundliRoutes = require('./routes/kundliRoutes');
app.use('/api/kundli', kundliRoutes);
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
"@
    $defaultServer | Out-File $ServerFile -Encoding UTF8
    Write-Host "âœ… Created new server.js with MongoDB integration"
}
Write-Host "ðŸŽ¯ All done! Mongoose integration boilerplate is ready. ðŸš€"
