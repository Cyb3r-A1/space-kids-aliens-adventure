#!/bin/bash

# Simple Docker Auto-Launch for Space Kids & Aliens Adventure
# This script creates a minimal Docker setup for the game

echo "🚀 Space Kids & Aliens Adventure - Simple Docker Setup"
echo "====================================================="

# Create a simple Dockerfile
cat > Dockerfile.simple << 'EOF'
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    x11vnc \
    fluxbox \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa \
    libxrandr2 \
    libxinerama1 \
    libxcursor1 \
    libxi6 \
    libxext6 \
    libxrender1 \
    libxss1 \
    libgconf-2-4 \
    libxtst6 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Download Godot
RUN wget -O godot.zip "https://downloads.tuxfamily.org/godotengine/4.4.1/Godot_v4.4.1-stable_linux.x86_64.zip" \
    && unzip godot.zip \
    && mv Godot_v4.4.1-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm godot.zip

WORKDIR /app
COPY . /app/

# Create startup script
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &\n\
fluxbox &\n\
sleep 2\n\
echo "Starting Space Kids & Aliens Adventure..."\n\
godot project.godot\n\
' > /app/start.sh && chmod +x /app/start.sh

ENV DISPLAY=:99
EXPOSE 5900
CMD ["/app/start.sh"]
EOF

echo "✅ Simple Dockerfile created"

# Create docker run command
cat > run-game.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting Space Kids & Aliens Adventure in Docker..."

# Build the image
docker build -f Dockerfile.simple -t space-kids-game .

# Run the container
docker run -it --rm \
    -p 5900:5900 \
    -e DISPLAY=:99 \
    --name space-kids-aliens-adventure \
    space-kids-game

echo "🎮 Game started! Connect via VNC to localhost:5900"
EOF

chmod +x run-game.sh

echo "✅ Run script created"

# Create a one-liner command
cat > quick-start.sh << 'EOF'
#!/bin/bash
# One-liner to build and run the game
docker build -f Dockerfile.simple -t space-kids-game . && docker run -it --rm -p 5900:5900 -e DISPLAY=:99 --name space-kids-aliens-adventure space-kids-game
EOF

chmod +x quick-start.sh

echo ""
echo "🎉 Docker setup complete!"
echo "========================="
echo ""
echo "📋 Available commands:"
echo "  ./run-game.sh          - Build and run the game"
echo "  ./quick-start.sh       - Quick one-liner start"
echo "  docker-compose up -d   - Full setup with web UI"
echo ""
echo "🔗 VNC Connection: vnc://localhost:5900"
echo "🌐 Web Interface: http://localhost:8080 (if using docker-compose)"
echo ""
echo "🎮 Game will auto-launch when container starts!"
