#!/bin/bash

# Space Kids & Aliens Adventure - Auto Web Export Script
# This script will export the game to web format when templates are available

echo "🚀 Space Kids & Aliens Adventure - Auto Web Export"
echo "================================================="

# Check if web export templates are available
if [ -f "/Users/oltonbradly/Library/Application Support/Godot/export_templates/4.4.1.stable/web_dlink_release.zip" ]; then
    echo "✅ Web export templates found!"
    echo "🎮 Exporting game to web format..."
    
    # Export the game
    /Applications/Godot.app/Contents/MacOS/Godot --headless --export-release "Web" web/index.html --path . project.godot
    
    if [ $? -eq 0 ]; then
        echo "✅ Game exported successfully!"
        echo "📁 Web files created:"
        ls -la web/
        echo ""
        echo "🚀 Committing and pushing to GitHub..."
        git add web/
        git commit -m "Export game to web format - ready for kids to play!"
        git push origin main
        echo ""
        echo "🎉 Game is now live and playable in browsers!"
        echo "🌐 Kids can play without installing anything!"
    else
        echo "❌ Export failed. Check Godot templates."
    fi
else
    echo "⚠️  Web export templates not found."
    echo ""
    echo "📋 To install templates:"
    echo "1. Open Godot Editor"
    echo "2. Go to Editor → Manage Export Templates"
    echo "3. Download Web export template"
    echo "4. Run this script again"
    echo ""
    echo "🎯 Current status: Landing page ready for deployment"
    echo "🌐 Kids can see game info and get excited!"
fi
