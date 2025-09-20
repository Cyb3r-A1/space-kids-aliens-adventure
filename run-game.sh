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
