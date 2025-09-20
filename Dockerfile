# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    x11vnc \
    fluxbox \
    xterm \
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
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Godot
RUN wget -O godot.zip "https://downloads.tuxfamily.org/godotengine/4.4.1/Godot_v4.4.1-stable_linux.x86_64.zip" \
    && unzip godot.zip \
    && mv Godot_v4.4.1-stable_linux.x86_64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm godot.zip

# Create app directory
WORKDIR /app

# Copy game files
COPY . /app/

# Create startup script
RUN echo '#!/bin/bash\n\
# Start Xvfb\n\
Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &\n\
\n\
# Start window manager\n\
fluxbox &\n\
\n\
# Start VNC server (optional, for remote access)\n\
x11vnc -display :99 -nopw -listen localhost -xkb -rfbport 5900 &\n\
\n\
# Wait for X server to start\n\
sleep 2\n\
\n\
# Launch Godot game\n\
echo "Starting Space Kids & Aliens Adventure Game..."\n\
godot --headless --main-pack project.pck || godot project.godot\n\
' > /app/start_game.sh && chmod +x /app/start_game.sh

# Expose VNC port (optional)
EXPOSE 5900

# Set display
ENV DISPLAY=:99

# Run the game
CMD ["/app/start_game.sh"]
