# 🌐 Web Export Guide for Space Kids & Aliens Adventure

## 🚀 Quick Start - Export to Web

### Step 1: Open Godot Editor
1. Open your project in Godot Editor
2. Make sure the game runs properly (press F5 to test)

### Step 2: Set Up Web Export
1. Go to **Project → Export**
2. Click **Add...** and select **Web (HTML5)**
3. If prompted to download export templates:
   - Click **Download and Install**
   - Wait for the download to complete
4. In the export settings:
   - **Export Path**: Set to `web/index.html`
   - **Custom HTML Shell**: Leave empty (we'll use our custom one)
   - **Canvas Resize Policy**: Set to "Fit Width"
   - **Focus Canvas on Start**: Check this box

### Step 3: Export the Game
1. Click **Export Project**
2. Choose the export path: `web/index.html`
3. Wait for the export to complete

### Step 4: Start Web Server
1. Run the web server script:
   ```bash
   ./start-web-server.sh
   ```
2. Open your browser to: `http://localhost:8000`
3. Your game should now be playable in the browser!

## 🌍 Sharing Your Game

### Option 1: Local Network Sharing
- Find your computer's IP address: `ifconfig | grep inet`
- Share: `http://YOUR_IP:8000` with friends on the same network

### Option 2: Online Hosting
1. **GitHub Pages** (Free):
   - Create a GitHub repository
   - Upload the `web/` folder contents
   - Enable GitHub Pages in repository settings
   - Your game will be available at: `https://YOUR_USERNAME.github.io/YOUR_REPO`

2. **Netlify** (Free):
   - Go to [netlify.com](https://netlify.com)
   - Drag and drop your `web/` folder
   - Get instant hosting with a custom URL

3. **Itch.io** (Free):
   - Create an account at [itch.io](https://itch.io)
   - Upload your `web/` folder as a web game
   - Get a custom URL and community features

## 🎮 Web Game Features

Your exported game will include:
- ✅ **Full 3D Graphics** - Complete space environment
- ✅ **Character Movement** - Arrow keys + Space for jetpack
- ✅ **Interactive UI** - All menus and panels
- ✅ **Galaxy Exploration** - Travel between galaxies
- ✅ **Planet Terraforming** - Transform worlds
- ✅ **Alien Companions** - Meet and befriend aliens
- ✅ **Space Building** - Construct space stations
- ✅ **Inventory System** - Manage items and resources

## 🔧 Troubleshooting

### Export Template Issues
If you get "No export template found":
1. Go to **Editor → Manage Export Templates**
2. Download the Web export template
3. Restart Godot and try again

### Performance Issues
- Reduce texture quality in export settings
- Lower particle effects if needed
- Test on different devices

### Browser Compatibility
- **Chrome/Edge**: Best performance
- **Firefox**: Good performance
- **Safari**: May have some limitations
- **Mobile**: Works but may be slower

## 📱 Mobile Support

The game will work on mobile devices with:
- Touch controls for movement
- Virtual keyboard for text input
- Responsive UI scaling

## 🎯 Next Steps

1. **Export your game** using the steps above
2. **Test in browser** to ensure everything works
3. **Share with friends** using the web server
4. **Upload to hosting** for permanent sharing
5. **Get feedback** and improve your game!

---

**Happy Gaming! 🚀🌌👽**
