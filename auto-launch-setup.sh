#!/bin/bash

# Space Kids & Aliens Adventure - Auto-Launch Setup
# This script sets up automatic launching of the game on system startup

echo "🚀 Space Kids & Aliens Adventure - Auto-Launch Setup"
echo "==================================================="

# Detect operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
else
    OS="unknown"
fi

echo "🖥️  Detected OS: $OS"

# Function to setup Linux systemd service
setup_linux() {
    echo "🐧 Setting up Linux systemd service..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        echo "⚠️  Running as root. Please run as regular user for systemd user service."
        exit 1
    fi
    
    # Create systemd user service directory
    mkdir -p ~/.config/systemd/user
    
    # Copy service file
    cp space-kids-game.service ~/.config/systemd/user/
    
    # Reload systemd
    systemctl --user daemon-reload
    
    # Enable service
    systemctl --user enable space-kids-game.service
    
    echo "✅ Linux systemd service installed"
    echo "📋 Commands:"
    echo "  systemctl --user start space-kids-game.service    # Start now"
    echo "  systemctl --user stop space-kids-game.service     # Stop"
    echo "  systemctl --user status space-kids-game.service   # Check status"
    echo "  systemctl --user disable space-kids-game.service  # Disable auto-start"
}

# Function to setup macOS launchd
setup_macos() {
    echo "🍎 Setting up macOS launchd service..."
    
    # Copy plist file to LaunchAgents
    cp com.spacekids.game.plist ~/Library/LaunchAgents/
    
    # Load the service
    launchctl load ~/Library/LaunchAgents/com.spacekids.game.plist
    
    echo "✅ macOS launchd service installed"
    echo "📋 Commands:"
    echo "  launchctl start com.spacekids.game    # Start now"
    echo "  launchctl stop com.spacekids.game     # Stop"
    echo "  launchctl list | grep spacekids       # Check status"
    echo "  launchctl unload ~/Library/LaunchAgents/com.spacekids.game.plist  # Disable"
}

# Function to setup Windows (using Task Scheduler)
setup_windows() {
    echo "🪟 Setting up Windows Task Scheduler..."
    
    # Create a batch file to start the game
    cat > start-game.bat << 'EOF'
@echo off
cd /d "C:\Users\%USERNAME%\warhammerlegends"
docker-compose up -d
EOF
    
    echo "✅ Windows batch file created: start-game.bat"
    echo "📋 Manual setup required:"
    echo "  1. Open Task Scheduler"
    echo "  2. Create Basic Task"
    echo "  3. Name: Space Kids Game"
    echo "  4. Trigger: At startup"
    echo "  5. Action: Start program"
    echo "  6. Program: start-game.bat"
}

# Function to create Docker auto-start script
create_docker_script() {
    echo "🐳 Creating Docker auto-start script..."
    
    cat > auto-start.sh << 'EOF'
#!/bin/bash

# Auto-start script for Space Kids & Aliens Adventure
echo "🚀 Starting Space Kids & Aliens Adventure..."

# Wait for Docker to be ready
while ! docker info > /dev/null 2>&1; do
    echo "⏳ Waiting for Docker to start..."
    sleep 5
done

# Start the game
cd "$(dirname "$0")"
docker-compose up -d

echo "✅ Game started! Connect via VNC to localhost:5900"
EOF
    
    chmod +x auto-start.sh
    echo "✅ Auto-start script created: auto-start.sh"
}

# Function to create cron job
setup_cron() {
    echo "⏰ Setting up cron job for auto-start..."
    
    # Get current directory
    CURRENT_DIR=$(pwd)
    
    # Create cron entry
    CRON_ENTRY="@reboot cd $CURRENT_DIR && ./auto-start.sh >> game-startup.log 2>&1"
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
    
    echo "✅ Cron job added"
    echo "📋 To remove: crontab -e (delete the @reboot line)"
}

# Main setup logic
case $OS in
    "linux")
        echo "🐧 Setting up for Linux..."
        create_docker_script
        setup_linux
        ;;
    "macos")
        echo "🍎 Setting up for macOS..."
        create_docker_script
        setup_macos
        ;;
    "windows")
        echo "🪟 Setting up for Windows..."
        setup_windows
        ;;
    *)
        echo "❓ Unknown OS. Setting up generic auto-start..."
        create_docker_script
        setup_cron
        ;;
esac

echo ""
echo "🎉 Auto-launch setup complete!"
echo "=============================="
echo ""
echo "🎮 The game will now start automatically when your system boots!"
echo ""
echo "📋 Manual commands:"
echo "  ./auto-start.sh           # Start game manually"
echo "  docker-compose up -d      # Start with docker-compose"
echo "  docker-compose down       # Stop game"
echo "  docker-compose logs -f    # View logs"
echo ""
echo "🔗 Game access:"
echo "  VNC: vnc://localhost:5900"
echo "  Web: http://localhost:8080"
echo ""
echo "🛑 To disable auto-start:"
if [[ "$OS" == "linux" ]]; then
    echo "  systemctl --user disable space-kids-game.service"
elif [[ "$OS" == "macos" ]]; then
    echo "  launchctl unload ~/Library/LaunchAgents/com.spacekids.game.plist"
else
    echo "  crontab -e (remove the @reboot line)"
fi
