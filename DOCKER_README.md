# 🐳 Docker Setup for Space Kids & Aliens Adventure

This guide will help you run the Space Kids & Aliens Adventure game in Docker with auto-launch capabilities.

## 🚀 Quick Start

### Option 1: Simple Setup (Recommended)
```bash
# Run the simple setup script
./simple-docker-setup.sh

# Start the game
./run-game.sh
```

### Option 2: Full Setup with Web UI
```bash
# Run the full setup script
./docker-setup.sh

# Or manually with docker-compose
docker-compose up -d
```

### Option 3: One-Liner
```bash
# Quick start with one command
./quick-start.sh
```

## 📋 Prerequisites

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **VNC Viewer**: [Download VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) (for game access)

## 🎮 How to Play

### 1. **Start the Game**
```bash
# Simple method
./run-game.sh

# Or with docker-compose
docker-compose up -d
```

### 2. **Connect to the Game**
- **VNC Connection**: `vnc://localhost:5900`
- **Web Interface**: `http://localhost:8080` (if using docker-compose)
- **Direct VNC**: Open VNC Viewer and connect to `localhost:5900`

### 3. **Game Controls**
| Key | Action |
|-----|--------|
| Arrow Keys | Move space explorer |
| Space | Jump / Jetpack boost |
| E | Interact with objects/aliens |
| B | Open building menu |
| I | Open inventory |
| C | Open alien companion menu |
| U | Open upgrade menu |
| T | Open transformation menu |
| G | Open galaxy map |
| P | Open planet info |
| R | Open terraforming menu |
| V | Open travel menu |
| S | Use alien special ability |
| Escape | Cancel/Cancel building |

## 🐳 Docker Commands

### **Build and Run**
```bash
# Build the image
docker build -t space-kids-game .

# Run the container
docker run -it --rm -p 5900:5900 -e DISPLAY=:99 space-kids-game
```

### **Docker Compose Commands**
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Rebuild and start
docker-compose up --build -d
```

### **Container Management**
```bash
# View running containers
docker ps

# View logs
docker logs space-kids-aliens-adventure

# Stop container
docker stop space-kids-aliens-adventure

# Remove container
docker rm space-kids-aliens-adventure

# Remove image
docker rmi space-kids-game
```

## 🌐 Services

### **Game Container** (`space-kids-game`)
- **Port**: 5900 (VNC)
- **Purpose**: Runs the Godot game
- **Auto-launch**: Game starts automatically when container starts

### **Web UI** (`game-web-ui`)
- **Port**: 8080
- **Purpose**: Web interface for game control
- **URL**: http://localhost:8080

### **Database** (`game-database`)
- **Port**: 5432
- **Purpose**: PostgreSQL database for game saves
- **Credentials**: gamer/cosmic_adventure

## 🔧 Configuration

### **Environment Variables**
```bash
# Display settings
DISPLAY=:99

# Game settings
GAME_MODE=auto
AUTO_SAVE=true
```

### **Volume Mounts**
```bash
# Mount game directory
-v ./:/app

# Mount save data
-v game_data:/var/lib/postgresql/data
```

## 🎯 Game Features in Docker

### **Auto-Launch Capabilities**
- ✅ Game starts automatically when container starts
- ✅ X server (Xvfb) runs in background
- ✅ VNC server provides remote access
- ✅ Window manager (Fluxbox) for GUI
- ✅ Automatic game loading

### **Persistent Data**
- ✅ Game saves persist between container restarts
- ✅ Database storage for multiplayer features
- ✅ Configuration files preserved

### **Remote Access**
- ✅ VNC access for remote gameplay
- ✅ Web interface for game management
- ✅ API endpoints for game control

## 🚨 Troubleshooting

### **Common Issues**

#### **Game Won't Start**
```bash
# Check container logs
docker logs space-kids-aliens-adventure

# Check if X server is running
docker exec space-kids-aliens-adventure ps aux | grep Xvfb
```

#### **VNC Connection Failed**
```bash
# Check VNC port
docker port space-kids-aliens-adventure 5900

# Restart VNC server
docker exec space-kids-aliens-adventure pkill x11vnc
docker exec space-kids-aliens-adventure x11vnc -display :99 -nopw -listen localhost -xkb -rfbport 5900 &
```

#### **Performance Issues**
```bash
# Increase memory limit
docker run -it --rm -p 5900:5900 -e DISPLAY=:99 --memory=2g space-kids-game

# Use GPU acceleration (if available)
docker run -it --rm -p 5900:5900 -e DISPLAY=:99 --gpus all space-kids-game
```

### **Debug Commands**
```bash
# Enter container shell
docker exec -it space-kids-aliens-adventure bash

# Check game process
docker exec space-kids-aliens-adventure ps aux | grep godot

# Check display
docker exec space-kids-aliens-adventure echo $DISPLAY

# Test VNC connection
docker exec space-kids-aliens-adventure netstat -tlnp | grep 5900
```

## 📊 Monitoring

### **Health Checks**
```bash
# Check container health
docker inspect space-kids-aliens-adventure | grep Health

# Monitor resource usage
docker stats space-kids-aliens-adventure
```

### **Logs**
```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View specific service logs
docker-compose logs -f space-kids-game
```

## 🔄 Updates

### **Update Game**
```bash
# Pull latest changes
git pull

# Rebuild container
docker-compose up --build -d
```

### **Update Docker Image**
```bash
# Remove old image
docker rmi space-kids-game

# Rebuild
docker build -t space-kids-game .
```

## 🎉 Success!

Once everything is running, you should see:
- ✅ Game container running
- ✅ VNC server active on port 5900
- ✅ Web interface on port 8080
- ✅ Database connected
- ✅ Game auto-launched and ready to play!

## 🆘 Support

If you encounter issues:
1. Check the logs: `docker-compose logs -f`
2. Verify ports are open: `netstat -tlnp | grep -E "(5900|8080|5432)"`
3. Ensure Docker has enough resources
4. Try restarting: `docker-compose restart`

---

**Enjoy exploring the cosmos in Space Kids & Aliens Adventure!** 🚀🌌👽
