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

// Game route - serve the Unreal WebGL build
app.get('/game', (req, res) => {
    res.redirect('/unreal-game.html');
});

// API endpoint for game data (for future enhancements)
app.get('/api/game-data', (req, res) => {
    res.json({
        gameName: 'Space Explorer Adventure - 3D Browser Game',
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

// Simple AI mission endpoint (deterministic pseudo-AI)
app.get('/api/mission', (req, res) => {
    const planets = [
        { name: 'Terranova', biome: 'Oceanic' },
        { name: 'Mars Prime', biome: 'Arid' },
        { name: 'Jupiter Station', biome: 'Gas Giant' },
        { name: 'Ice World', biome: 'Frozen' },
        { name: 'Lava Planet', biome: 'Volcanic' }
    ];
    const objectives = [
        'Scan anomalies', 'Collect rare minerals', 'Rescue stranded probe',
        'Map subterranean caverns', 'Stabilize climate outpost', 'Neutralize pirate beacon'
    ];
    const rewards = ['500 credits', 'Prototype thrusters', 'Alien artifact', 'Rare blueprint', 'Ancient coordinates', 'Cosmic shard'];
    const difficulties = ['Easy', 'Normal', 'Hard', 'Elite'];
    const times = ['5 min', '10 min', '15 min', '20 min'];

    function pick(a) { return a[Math.floor(Math.random() * a.length)]; }
    const planet = pick(planets);
    const objective = pick(objectives);
    const reward = pick(rewards);
    const difficulty = pick(difficulties);
    const timeLimit = pick(times);
    const briefing = `Intel suggests ${planet.name} (${planet.biome}) shows signs of ${objective.toLowerCase()}. Navigate to the mission zone, complete objectives, and extract safely.`;

    res.json({ planet: planet.name, biome: planet.biome, objective, reward, difficulty, timeLimit, briefing });
});

app.listen(PORT, () => {
    console.log(`🚀 Space Explorer Adventure server running on port ${PORT}`);
    console.log(`🌐 Game available at: http://localhost:${PORT}`);
    console.log(`🎮 Direct game link: http://localhost:${PORT}/game`);
});

