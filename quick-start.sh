#!/bin/bash
# One-liner to build and run the game
docker build -f Dockerfile.simple -t space-kids-game . && docker run -it --rm -p 5900:5900 -e DISPLAY=:99 --name space-kids-aliens-adventure space-kids-game
