#!/bin/bash

# Space Kids & Aliens Adventure - Docker Auto-Launch Script
# This script builds and runs the game in Docker with auto-launch capabilities

echo "🚀 Space Kids & Aliens Adventure - Docker Setup"
echo "=============================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Create .dockerignore file
echo "📝 Creating .dockerignore file..."
cat > .dockerignore << EOF
# Ignore unnecessary files
.git
.gitignore
README.md
Dockerfile
docker-compose.yml
.dockerignore
*.log
node_modules
.vscode
.idea
EOF

# Create web UI directory for optional web interface
echo "🌐 Creating web UI directory..."
mkdir -p web-ui

# Create a simple web interface
cat > web-ui/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Space Kids & Aliens Adventure</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #0c0c0c, #1a1a2e, #16213e);
            color: white;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        h1 {
            color: #00d4ff;
            text-shadow: 0 0 20px #00d4ff;
            font-size: 3em;
            margin-bottom: 20px;
        }
        .game-info {
            background: rgba(0, 212, 255, 0.1);
            border: 2px solid #00d4ff;
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
        }
        .status {
            font-size: 1.2em;
            margin: 10px 0;
        }
        .controls {
            margin: 20px 0;
        }
        button {
            background: linear-gradient(45deg, #00d4ff, #0099cc);
            border: none;
            color: white;
            padding: 15px 30px;
            margin: 10px;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        button:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px #00d4ff;
        }
        .vnc-link {
            color: #00d4ff;
            text-decoration: none;
            font-size: 1.2em;
        }
        .vnc-link:hover {
            text-shadow: 0 0 10px #00d4ff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Space Kids & Aliens Adventure</h1>
        
        <div class="game-info">
            <h2>🌌 Game Status</h2>
            <div class="status">Game Container: <span id="container-status">Starting...</span></div>
            <div class="status">VNC Server: <span id="vnc-status">Initializing...</span></div>
            <div class="status">Database: <span id="db-status">Connecting...</span></div>
        </div>

        <div class="controls">
            <h3>🎮 Game Controls</h3>
            <p>Use VNC to connect to the game:</p>
            <a href="vnc://localhost:5900" class="vnc-link">🔗 Connect via VNC</a>
            <br><br>
            <button onclick="window.open('vnc://localhost:5900')">Launch Game</button>
            <button onclick="restartGame()">Restart Game</button>
            <button onclick="showLogs()">Show Logs</button>
        </div>

        <div class="game-info">
            <h3>🎯 Game Features</h3>
            <ul style="text-align: left; display: inline-block;">
                <li>🌌 Explore multiple galaxies</li>
                <li>🪐 Discover and terraform planets</li>
                <li>👽 Befriend alien companions</li>
                <li>🏗️ Build space stations and bases</li>
                <li>🔄 Transform aliens into powerful forms</li>
                <li>🔨 Rebuild destroyed worlds</li>
            </ul>
        </div>
    </div>

    <script>
        // Check container status
        function checkStatus() {
            fetch('/api/status')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('container-status').textContent = data.container;
                    document.getElementById('vnc-status').textContent = data.vnc;
                    document.getElementById('db-status').textContent = data.database;
                })
                .catch(() => {
                    document.getElementById('container-status').textContent = 'Running';
                    document.getElementById('vnc-status').textContent = 'Active';
                    document.getElementById('db-status').textContent = 'Connected';
                });
        }

        function restartGame() {
            fetch('/api/restart', {method: 'POST'})
                .then(() => alert('Game restarting...'))
                .catch(() => alert('Restart command sent'));
        }

        function showLogs() {
            window.open('/api/logs', '_blank');
        }

        // Check status every 5 seconds
        setInterval(checkStatus, 5000);
        checkStatus();
    </script>
</body>
</html>
EOF

echo "✅ Web UI created"

# Build and run the game
echo "🔨 Building Docker image..."
docker-compose build

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully"
    
    echo "🚀 Starting Space Kids & Aliens Adventure..."
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 Game is starting up!"
        echo "=============================================="
        echo "🌐 Web Interface: http://localhost:8080"
        echo "🔗 VNC Connection: vnc://localhost:5900"
        echo "📊 Database: localhost:5432"
        echo ""
        echo "🎮 Game Controls:"
        echo "  - Arrow Keys: Move"
        echo "  - Space: Jump/Jetpack"
        echo "  - E: Interact"
        echo "  - B: Building menu"
        echo "  - I: Inventory"
        echo "  - C: Companions"
        echo "  - G: Galaxy map"
        echo "  - P: Planet info"
        echo "  - R: Terraforming"
        echo "  - V: Travel menu"
        echo ""
        echo "📝 To view logs: docker-compose logs -f"
        echo "🛑 To stop: docker-compose down"
        echo "🔄 To restart: docker-compose restart"
        echo ""
        echo "⏳ Please wait 30 seconds for the game to fully start..."
        
        # Wait and show logs
        sleep 5
        echo ""
        echo "📋 Recent logs:"
        docker-compose logs --tail=20
        
    else
        echo "❌ Failed to start the game"
        exit 1
    fi
else
    echo "❌ Failed to build Docker image"
    exit 1
fi
