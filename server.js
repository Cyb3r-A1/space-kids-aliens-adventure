const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from web directory
app.use(express.static('web'));

// Main route - serve the game
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'web', 'index.html'));
});

// Game route - serve the playable game
app.get('/game', (req, res) => {
    res.sendFile(path.join(__dirname, 'web', 'game.html'));
});

// API endpoint for game data (for future enhancements)
app.get('/api/game-data', (req, res) => {
    res.json({
        gameName: 'Space Kids & Aliens Adventure',
        version: '1.0.0',
        features: [
            'Galaxy Exploration',
            'Planet Terraforming', 
            'Alien Companions',
            'Space Building'
        ],
        status: 'live'
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
    console.log(`🚀 Space Kids & Aliens Adventure server running on port ${PORT}`);
    console.log(`🌐 Game available at: http://localhost:${PORT}`);
    console.log(`🎮 Direct game link: http://localhost:${PORT}/game`);
});
