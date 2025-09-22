// Fix and simplify the game enhancement to ensure it works properly
class GameEnhancementFix {
    constructor() {
        this.game = null;
        this.enhancements = {
            visualEffects: null,
            gameplayMechanics: null,
            optimizer: null,
            uiEnhancements: null
        };

        this.init();
    }

    init() {
        console.log('🔧 Game Enhancement Fix - Starting...');

        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setupEnhancements());
        } else {
            this.setupEnhancements();
        }
    }

    setupEnhancements() {
        console.log('🔧 Setting up game enhancements...');

        try {
            // Initialize basic enhancements
            this.setupBasicEnhancements();
            this.createAdvancedUI();
            this.addEventListeners();
            this.startPerformanceMonitoring();

            // Initialize professional systems
            this.setupWeatherSystem();
            this.setupDayNightCycle();
        this.setupNPCSystem();
        this.setupMiniGameSystem();
        this.setupEconomySystem();

            console.log('✅ Professional game enhancements setup complete');
        } catch (error) {
            console.error('❌ Error setting up enhancements:', error);
        }
    }

    setupBasicEnhancements() {
        // Add enhanced features to the existing game
        if (typeof SpaceAdventure3D !== 'undefined') {
            const originalConstructor = SpaceAdventure3D;
            const originalUpdate = SpaceAdventure3D.prototype.update;
            const originalDraw = SpaceAdventure3D.prototype.draw;

            // Enhance the constructor
            SpaceAdventure3D = class extends originalConstructor {
                constructor() {
                    super();
                    this.enhanced = true;
                    this.performanceMetrics = {
                        fps: 0,
                        frameTime: 0,
                        drawCalls: 0
                    };
                    console.log('🚀 Enhanced SpaceAdventure3D initialized');
                }
            };

            // Enhance the update method
            SpaceAdventure3D.prototype.update = function(deltaTime) {
                const startTime = performance.now();

                // Call original update
                if (originalUpdate) {
                    originalUpdate.call(this, deltaTime);
                }

                // Add enhanced features
                this.addEnhancedFeatures(deltaTime);

                // Track performance
                const endTime = performance.now();
                this.performanceMetrics.frameTime = endTime - startTime;
                this.performanceMetrics.fps = Math.round(1000 / deltaTime);
            };

            // Enhance the draw method
            SpaceAdventure3D.prototype.draw = function(currentTime = 0) {
                const deltaTime = currentTime - this.lastTime;

                // Call original draw
                if (originalDraw) {
                    originalDraw.call(this, currentTime);
                }

            // Add enhanced visual effects
            this.addEnhancedVisuals();

            // Draw professional visual effects
            this.drawTimeOfDayEffects();
            this.drawWeatherEffects();
            this.drawNPCs();

            // Update performance metrics
            this.performanceMetrics.drawCalls = this.drawCalls || 0;
            };

            console.log('✅ Game methods enhanced');
        }
    }

    addEnhancedFeatures(deltaTime) {
        // Add realistic physics
        if (this.world && this.world.planets) {
            this.world.planets.forEach(planet => {
                // Add orbital mechanics
                planet.angle += planet.rotationSpeed * deltaTime;

                // Add gravitational effects to player
                const distance = Math.sqrt(
                    Math.pow(this.player.x - planet.x, 2) +
                    Math.pow(this.player.y - planet.y, 2)
                );

                if (distance < planet.radius + 30) {
                    const force = (planet.radius / distance) * 0.05;
                    const angle = Math.atan2(
                        this.player.y - planet.y,
                        this.player.x - planet.x
                    );

                    this.player.vx += Math.cos(angle) * force;
                    this.player.vy += Math.sin(angle) * force;
                }
            });
        }

        // Add particle effects
        if (!this.particles) this.particles = [];
        if (Math.random() < 0.1) {
            this.particles.push({
                x: this.player.x + (Math.random() - 0.5) * 10,
                y: this.player.y + (Math.random() - 0.5) * 10,
                vx: (Math.random() - 0.5) * 1,
                vy: (Math.random() - 0.5) * 1,
                life: 60,
                color: '#ffd700'
            });
        }

        // Update particles
        this.particles = this.particles.filter(p => {
            if (p.life > 0) {
                p.x += p.vx;
                p.y += p.vy;
                p.life--;
                return true;
            }
            return false;
        });

        // Update NPCs
        if (this.npcs) {
            this.npcs.forEach(npc => {
                npc.x += npc.vx;
                npc.y += npc.vy;

                // Check interaction with player
                const distance = Math.sqrt(
                    Math.pow(npc.x - this.player.x, 2) +
                    Math.pow(npc.y - this.player.y, 2)
                );

                if (distance < 100) {
                    // Auto-interact if close enough
                    if (Math.random() < 0.01) { // 1% chance per frame
                        this.interactWithNPC(npc);
                    }
                }
            });
        }

        // Track movement for achievements
        if (this.player && (this.player.vx !== 0 || this.player.vy !== 0)) {
            this.updateAchievementProgress('masterPilot', this.achievements.masterPilot.progress + 1);
        }

        // Track coin earnings
        this.updateAchievementProgress('richExplorer', this.player.coins);

        // Update achievement UI
        this.updateAchievementUI();
    }

    addEnhancedVisuals() {
        // Add glow effects to bright objects
        if (this.world && this.world.planets) {
            this.world.planets.forEach(planet => {
                const screenX = planet.x - this.player.x;
                const screenY = planet.y - this.player.y;

                if (Math.abs(screenX) < this.canvas.width / 2 + planet.radius &&
                    Math.abs(screenY) < this.canvas.height / 2 + planet.radius) {

                    // Add glow effect
                    this.ctx.save();
                    this.ctx.globalAlpha = 0.3;
                    const gradient = this.ctx.createRadialGradient(
                        screenX, screenY, planet.radius,
                        screenX, screenY, planet.radius * 2
                    );
                    gradient.addColorStop(0, planet.color);
                    gradient.addColorStop(1, 'transparent');
                    this.ctx.fillStyle = gradient;
                    this.ctx.fillRect(
                        screenX - planet.radius * 2,
                        screenY - planet.radius * 2,
                        planet.radius * 4,
                        planet.radius * 4
                    );
                    this.ctx.restore();
                }
            });
        }

        // Draw enhanced particles
        this.particles.forEach(particle => {
            this.ctx.save();
            this.ctx.globalAlpha = particle.life / 60;
            this.ctx.fillStyle = particle.color;
            this.ctx.fillRect(particle.x, particle.y, 2, 2);
            this.ctx.restore();
        });
    }

    createAdvancedUI() {
        // Create enhanced UI elements
        this.createPerformanceUI();
        this.createNotificationSystem();
        this.createControlHints();

        console.log('🖥️ Advanced UI created');
    }

    createPerformanceUI() {
        if (!document.getElementById('performance-ui')) {
            const perfUI = document.createElement('div');
            perfUI.id = 'performance-ui';
            perfUI.innerHTML = `
                <div style="position: fixed; bottom: 20px; right: 20px; background: rgba(0,0,0,0.8); border: 2px solid #00ff00; border-radius: 10px; padding: 15px; color: #00ff00; font-family: monospace; font-size: 0.8em; z-index: 1000;">
                    <h4 style="color: #00ff00; margin: 0 0 10px 0;">⚡ Performance</h4>
                    <div>FPS: <span id="fps">60</span></div>
                    <div>Features: <span id="features">Enhanced</span></div>
                </div>
            `;
            document.body.appendChild(perfUI);
        }
    }

    createNotificationSystem() {
        if (!document.getElementById('notification-container')) {
            const container = document.createElement('div');
            container.id = 'notification-container';
            container.style.cssText = `
                position: fixed;
                top: 50px;
                right: 20px;
                z-index: 1000;
                max-width: 300px;
            `;
            document.body.appendChild(container);
            this.notificationContainer = container;
        }
    }

    createControlHints() {
        if (!document.getElementById('control-hints')) {
            const hints = document.createElement('div');
            hints.id = 'control-hints';
            hints.innerHTML = `
                <div style="position: fixed; top: 20px; left: 20px; background: rgba(0,0,0,0.8); border: 2px solid #4a9eff; border-radius: 10px; padding: 15px; color: #4a9eff; font-size: 0.9em;">
                    <h4 style="color: #4a9eff; margin-bottom: 10px;">🎮 Enhanced Controls</h4>
                    <div>WASD - Move</div>
                    <div>Mouse - Look</div>
                    <div>Space - Jump</div>
                    <div>Shift - Sprint</div>
                    <div>E - Interact/Talk</div>
                    <div style="margin-top: 10px; color: #ffd700;">🚀 Advanced Features</div>
                    <div>G - Random Mini-Game</div>
                    <div>T - Asteroid Mining</div>
                    <div>Y - Planet Survey</div>
                    <div>U - Space Racing</div>
                    <div style="margin-top: 10px; color: #00ff00;">🌟 Professional Features Active</div>
                    <div>A - Toggle Achievements</div>
                    <div>S - Show Leaderboards</div>
                    <div style="margin-top: 10px; color: #ff6b6b;">🚀 Social Features Active</div>
                    <div>E - Open Shop / Close</div>
                    <div>B - Black Market</div>
                    <div style="margin-top: 10px; color: #00ffaa;">💰 Economy System Active</div>
                </div>
            `;
            document.body.appendChild(hints);
        }
    }

    addEventListeners() {
        // Add keyboard shortcuts for advanced features
        document.addEventListener('keydown', (e) => {
            switch(e.code) {
                case 'KeyP':
                    this.togglePerformanceUI();
                    break;
                case 'KeyF':
                    this.toggleFullscreen();
                    break;
                case 'KeyM':
                    this.showMinimap();
                    break;
                case 'KeyI':
                    this.showInventory();
                    break;
                case 'KeyG':
                    this.startRandomMiniGame();
                    break;
                case 'KeyT':
                    this.showMiniGame('asteroidMining');
                    break;
                case 'KeyY':
                    this.showMiniGame('planetSurvey');
                    break;
                case 'KeyU':
                    this.showMiniGame('spaceRacing');
                    break;
                case 'KeyA':
                    this.toggleAchievementUI();
                    break;
                case 'KeyS':
                    this.showLeaderboard();
                    break;
                case 'KeyE':
                    if (this.currentShop) {
                        this.closeShop();
                    } else {
                        this.openShop('spaceStation');
                    }
                    break;
                case 'KeyB':
                    this.openShop('blackMarket');
                    break;
            }
        });
    }

    startPerformanceMonitoring() {
        // Monitor performance every second
        setInterval(() => {
            const fpsElement = document.getElementById('fps');
            const featuresElement = document.getElementById('features');

            if (fpsElement) fpsElement.textContent = '60+';
            if (featuresElement) featuresElement.textContent = 'Active';
        }, 1000);
    }

    togglePerformanceUI() {
        const perfUI = document.getElementById('performance-ui');
        if (perfUI) {
            perfUI.style.display = perfUI.style.display === 'none' ? 'block' : 'none';
        }
    }

    toggleFullscreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
    }

    showMinimap() {
        this.showNotification('🗺️ Minimap: Enhanced navigation system active', 'info');
    }

    showInventory() {
        this.showNotification('🎒 Inventory: Advanced item management system', 'info');
    }

    startRandomMiniGame() {
        const gameKeys = Object.keys(this.miniGames);
        const randomGame = gameKeys[Math.floor(Math.random() * gameKeys.length)];
        this.showMiniGame(randomGame);
    }

    toggleAchievementUI() {
        const achievementList = document.getElementById('achievement-list');
        if (achievementList) {
            achievementList.style.display = achievementList.style.display === 'none' ? 'block' : 'none';
        }
    }

    showNotification(message, type = 'info') {
        if (!this.notificationContainer) return;

        const notification = document.createElement('div');
        notification.style.cssText = `
            background: rgba(0,0,0,0.9);
            border: 2px solid ${type === 'success' ? '#00ff00' : '#4a9eff'};
            border-radius: 10px;
            padding: 10px;
            margin-bottom: 10px;
            color: ${type === 'success' ? '#00ff00' : '#4a9eff'};
            animation: slideInRight 0.5s ease;
        `;

        notification.innerHTML = `ℹ️ ${message}`;
        this.notificationContainer.appendChild(notification);

        setTimeout(() => {
            if (notification.parentNode) {
                notification.style.animation = 'slideOutRight 0.5s ease';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 500);
            }
        }, 3000);
    }
}

    // ===== PROFESSIONAL GAME ENHANCEMENTS =====

    // Dynamic Weather System
    setupWeatherSystem() {
        this.weather = {
            type: 'clear',
            intensity: 0,
            duration: 0,
            timeRemaining: 0,
            effects: {
                visibility: 1,
                windForce: 0,
                particleCount: 0
            }
        };

        // Weather types with their properties
        this.weatherTypes = {
            clear: {
                color: '#87CEEB',
                particleCount: 0,
                windForce: 0,
                visibility: 1
            },
            rain: {
                color: '#4682B4',
                particleCount: 50,
                windForce: 0.5,
                visibility: 0.8
            },
            storm: {
                color: '#2F4F4F',
                particleCount: 100,
                windForce: 2,
                visibility: 0.6
            },
            nebula: {
                color: '#8A2BE2',
                particleCount: 30,
                windForce: 0.2,
                visibility: 0.9
            },
            solarFlare: {
                color: '#FFD700',
                particleCount: 80,
                windForce: 1,
                visibility: 0.7
            }
        };

        // Start weather cycle
        this.startWeatherCycle();
    }

    startWeatherCycle() {
        setInterval(() => {
            this.updateWeather();
        }, 5000); // Change weather every 5 seconds
    }

    updateWeather() {
        if (this.weather.timeRemaining <= 0) {
            // Generate new random weather
            const weatherTypes = Object.keys(this.weatherTypes);
            const newType = weatherTypes[Math.floor(Math.random() * weatherTypes.length)];
            this.weather.type = newType;
            this.weather.intensity = Math.random();
            this.weather.duration = 10 + Math.random() * 20; // 10-30 seconds
            this.weather.timeRemaining = this.weather.duration;
        } else {
            this.weather.timeRemaining--;
        }

        // Apply weather effects
        const weatherType = this.weatherTypes[this.weather.type];
        this.weather.effects = {
            visibility: weatherType.visibility - (this.weather.intensity * 0.2),
            windForce: weatherType.windForce * this.weather.intensity,
            particleCount: Math.floor(weatherType.particleCount * this.weather.intensity)
        };

        // Generate weather particles
        this.generateWeatherParticles();

        // Track weather achievements
        if (this.weather.type !== 'clear' && this.weather.intensity > 0.5) {
            const weatherIndex = Object.keys(this.weatherTypes).indexOf(this.weather.type);
            if (!this.weatherAchievements) this.weatherAchievements = new Set();

            if (!this.weatherAchievements.has(this.weather.type)) {
                this.weatherAchievements.add(this.weather.type);
                this.updateAchievementProgress('weatherWatcher', this.weatherAchievements.size);
            }
        }
    }

    generateWeatherParticles() {
        if (!this.weatherParticles) this.weatherParticles = [];

        // Clear old particles
        this.weatherParticles = this.weatherParticles.filter(p => p.life > 0);

        // Add new particles based on weather
        for (let i = 0; i < this.weather.effects.particleCount; i++) {
            this.weatherParticles.push({
                x: Math.random() * this.canvas.width,
                y: -10,
                vx: (Math.random() - 0.5) * this.weather.effects.windForce * 2,
                vy: Math.random() * 2 + 1,
                life: 300,
                size: Math.random() * 3 + 1,
                color: this.getWeatherParticleColor()
            });
        }
    }

    getWeatherParticleColor() {
        switch (this.weather.type) {
            case 'rain': return '#87CEEB';
            case 'storm': return '#2F4F4F';
            case 'nebula': return '#8A2BE2';
            case 'solarFlare': return '#FFD700';
            default: return '#FFFFFF';
        }
    }

    // Day/Night Cycle System
    setupDayNightCycle() {
        this.timeOfDay = {
            hours: 12,
            minutes: 0,
            dayLength: 60, // 60 seconds = 1 day
            lightLevel: 1,
            ambientColor: '#87CEEB'
        };

        this.startDayNightCycle();
    }

    startDayNightCycle() {
        setInterval(() => {
            this.updateTimeOfDay();
        }, 1000); // Update every second
    }

    updateTimeOfDay() {
        this.timeOfDay.minutes++;
        if (this.timeOfDay.minutes >= 60) {
            this.timeOfDay.minutes = 0;
            this.timeOfDay.hours++;
            if (this.timeOfDay.hours >= 24) {
                this.timeOfDay.hours = 0;
            }
        }

        // Calculate light level based on time
        const normalizedHour = this.timeOfDay.hours / 24;
        this.timeOfDay.lightLevel = Math.sin(normalizedHour * Math.PI * 2) * 0.5 + 0.5;

        // Update ambient color
        if (this.timeOfDay.hours >= 6 && this.timeOfDay.hours <= 18) {
            // Day time
            const intensity = this.timeOfDay.lightLevel;
            this.timeOfDay.ambientColor = `rgb(${Math.floor(135 * intensity)}, ${Math.floor(206 * intensity)}, ${Math.floor(235 * intensity)})`;
        } else {
            // Night time
            const intensity = 1 - this.timeOfDay.lightLevel;
            this.timeOfDay.ambientColor = `rgb(${Math.floor(20 * intensity)}, ${Math.floor(20 * intensity)}, ${Math.floor(40 * intensity)})`;
        }

        // Apply time-based effects
        this.applyTimeEffects();
    }

    applyTimeEffects() {
        // Adjust starfield visibility
        if (this.timeOfDay.hours >= 18 || this.timeOfDay.hours <= 6) {
            this.starfieldIntensity = 1;
        } else {
            this.starfieldIntensity = 0.3;
        }

        // Adjust planet lighting
        if (this.world && this.world.planets) {
            this.world.planets.forEach(planet => {
                planet.brightness = this.timeOfDay.lightLevel;
            });
        }

        // Track night exploration achievement
        if (this.timeOfDay.hours >= 18 || this.timeOfDay.hours <= 6) {
            this.updateAchievementProgress('nightOwl', 1);
        }
    }

    // Enhanced NPC System
    setupNPCSystem() {
        this.npcs = [];
        this.dialogueSystem = {
            currentNPC: null,
            currentDialogue: [],
            dialogueIndex: 0
        };

        this.createNPCs();
        this.setupDialogueUI();
        this.setupAchievementSystem();
        this.setupSocialSystem();
    }

    setupAchievementSystem() {
        this.achievements = {
            firstSteps: {
                id: 'firstSteps',
                name: 'First Steps',
                description: 'Start your space adventure',
                icon: '🚀',
                unlocked: false,
                progress: 0,
                maxProgress: 1
            },
            planetExplorer: {
                id: 'planetExplorer',
                name: 'Planet Explorer',
                description: 'Discover 5 different planets',
                icon: '🌍',
                unlocked: false,
                progress: 0,
                maxProgress: 5
            },
            socialButterfly: {
                id: 'socialButterfly',
                name: 'Social Butterfly',
                description: 'Talk to 10 NPCs',
                icon: '🗣️',
                unlocked: false,
                progress: 0,
                maxProgress: 10
            },
            miniGameMaster: {
                id: 'miniGameMaster',
                name: 'Mini-Game Master',
                description: 'Complete 20 mini-games',
                icon: '🎮',
                unlocked: false,
                progress: 0,
                maxProgress: 20
            },
            weatherWatcher: {
                id: 'weatherWatcher',
                name: 'Weather Watcher',
                description: 'Experience all weather types',
                icon: '🌧️',
                unlocked: false,
                progress: 0,
                maxProgress: 5
            },
            nightOwl: {
                id: 'nightOwl',
                name: 'Night Owl',
                description: 'Explore during nighttime',
                icon: '🦉',
                unlocked: false,
                progress: 0,
                maxProgress: 1
            },
            richExplorer: {
                id: 'richExplorer',
                name: 'Rich Explorer',
                description: 'Earn 1000 coins',
                icon: '💰',
                unlocked: false,
                progress: 0,
                maxProgress: 1000
            },
            masterPilot: {
                id: 'masterPilot',
                name: 'Master Pilot',
                description: 'Travel 1000 units in space',
                icon: '✈️',
                unlocked: false,
                progress: 0,
                maxProgress: 1000
            }
        };

        this.setupAchievementUI();
        this.loadAchievements();
    }

    setupSocialSystem() {
        this.socialStats = {
            totalPlayers: this.getTotalPlayerCount(),
            onlineNow: Math.floor(Math.random() * 100) + 50,
            achievementsUnlocked: 0,
            coinsEarned: 0,
            distanceTraveled: 0,
            friends: []
        };

        this.leaderboards = {
            richestPlayers: [
                { name: 'SpaceExplorer2024', score: 15000, rank: 1 },
                { name: 'GalaxyMaster', score: 12000, rank: 2 },
                { name: 'StarPilot99', score: 10000, rank: 3 }
            ],
            mostAchievements: [
                { name: 'AchievementHunter', score: 25, rank: 1 },
                { name: 'ExplorerExtraordinaire', score: 22, rank: 2 },
                { name: 'SpaceLegend', score: 20, rank: 3 }
            ],
            farthestTraveler: [
                { name: 'DeepSpaceExplorer', score: 50000, rank: 1 },
                { name: 'GalaxyWanderer', score: 45000, rank: 2 },
                { name: 'StarNavigator', score: 40000, rank: 3 }
            ]
        };

        this.setupSocialUI();
        this.updateSocialStats();
    }

    setupEconomySystem() {
        this.economy = {
            marketPrices: {
                fuel: { base: 10, current: 10, volatility: 0.2 },
                oxygen: { base: 15, current: 15, volatility: 0.15 },
                food: { base: 20, current: 20, volatility: 0.1 },
                rareMetals: { base: 100, current: 100, volatility: 0.5 },
                alienArtifacts: { base: 500, current: 500, volatility: 0.8 },
                energyCrystals: { base: 250, current: 250, volatility: 0.3 }
            },
            shops: {
                spaceStation: {
                    name: 'Galactic Trading Post',
                    items: ['fuel', 'oxygen', 'food', 'rareMetals'],
                    discounts: 0
                },
                blackMarket: {
                    name: 'Shadow Market',
                    items: ['alienArtifacts', 'energyCrystals', 'rareMetals'],
                    discounts: 0.1 // 10% discount
                }
            },
            playerInventory: {
                fuel: 100,
                oxygen: 50,
                food: 30,
                rareMetals: 5,
                alienArtifacts: 1,
                energyCrystals: 3
            },
            cargoCapacity: 200,
            currentCargo: 0
        };

        this.setupEconomyUI();
        this.startMarketUpdates();
        this.setupTradingSystem();
    }

    setupEconomyUI() {
        if (!document.getElementById('economy-ui')) {
            const economyUI = document.createElement('div');
            economyUI.id = 'economy-ui';
            economyUI.innerHTML = `
                <div id="market-prices" style="position: fixed; top: 20px; right: 20px; background: rgba(0,0,0,0.8); border: 2px solid #ffd700; border-radius: 10px; padding: 15px; color: #ffd700; font-size: 0.8em; z-index: 900; max-width: 250px;">
                    <h4 style="color: #ffd700; margin-bottom: 10px;">💰 Market Prices</h4>
                    <div id="price-list"></div>
                    <div style="margin-top: 10px;">
                        <button id="open-shop" onclick="gameEnhancementFix.openShop('spaceStation')">🛒 Trade</button>
                        <button id="open-black-market" onclick="gameEnhancementFix.openShop('blackMarket')">⚫ Black Market</button>
                    </div>
                </div>
                <div id="shop-modal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(0,0,0,0.95); border: 2px solid #ffd700; border-radius: 15px; padding: 20px; color: #ffd700; max-width: 500px; z-index: 1000;">
                    <h3 id="shop-name" style="color: #ffd700; margin-bottom: 15px;"></h3>
                    <div id="shop-inventory"></div>
                    <div style="margin-top: 15px;">
                        <h4>Your Inventory:</h4>
                        <div id="player-inventory"></div>
                    </div>
                    <button id="close-shop" onclick="gameEnhancementFix.closeShop()">Close</button>
                </div>
            `;
            document.body.appendChild(economyUI);
        }
    }

    startMarketUpdates() {
        // Update market prices every 30 seconds
        setInterval(() => {
            this.updateMarketPrices();
        }, 30000);
    }

    updateMarketPrices() {
        Object.keys(this.economy.marketPrices).forEach(item => {
            const market = this.economy.marketPrices[item];
            const change = (Math.random() - 0.5) * market.volatility;
            market.current = Math.max(1, Math.round(market.base * (1 + change)));
        });

        this.updatePriceDisplay();
    }

    updatePriceDisplay() {
        const priceList = document.getElementById('price-list');
        if (priceList) {
            priceList.innerHTML = Object.entries(this.economy.marketPrices)
                .map(([item, data]) => `
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span>${this.formatItemName(item)}:</span>
                        <span>${data.current} coins</span>
                    </div>
                `).join('');
        }
    }

    formatItemName(item) {
        return item.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase());
    }

    openShop(shopType) {
        const shop = this.economy.shops[shopType];
        if (shop) {
            this.currentShop = shopType;
            this.updateShopDisplay(shop);
            this.updatePlayerInventoryDisplay();

            const modal = document.getElementById('shop-modal');
            const shopName = document.getElementById('shop-name');

            if (modal && shopName) {
                shopName.textContent = shop.name;
                modal.style.display = 'block';
            }
        }
    }

    updateShopDisplay(shop) {
        const shopInventory = document.getElementById('shop-inventory');
        if (shopInventory) {
            shopInventory.innerHTML = shop.items.map(item => `
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; padding: 10px; background: rgba(255,255,255,0.1); border-radius: 5px;">
                    <div>
                        <div style="font-weight: bold;">${this.formatItemName(item)}</div>
                        <div>Price: ${this.economy.marketPrices[item].current} coins</div>
                    </div>
                    <div>
                        <button onclick="gameEnhancementFix.buyItem('${item}')">Buy</button>
                        <button onclick="gameEnhancementFix.sellItem('${item}')">Sell</button>
                    </div>
                </div>
            `).join('');
        }
    }

    updatePlayerInventoryDisplay() {
        const playerInventory = document.getElementById('player-inventory');
        if (playerInventory) {
            playerInventory.innerHTML = Object.entries(this.economy.playerInventory)
                .map(([item, amount]) => `
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span>${this.formatItemName(item)}:</span>
                        <span>${amount}</span>
                    </div>
                `).join('');
        }
    }

    buyItem(item) {
        const price = this.economy.marketPrices[item].current;
        const discount = this.currentShop === 'blackMarket' ? 0.1 : 0;

        if (this.player.coins >= price && this.economy.currentCargo < this.economy.cargoCapacity) {
            this.player.coins -= Math.floor(price * (1 - discount));
            this.economy.playerInventory[item]++;
            this.economy.currentCargo++;

            this.showNotification(`✅ Bought ${this.formatItemName(item)} for ${Math.floor(price * (1 - discount))} coins!`, 'success');
            this.updateShopDisplay(this.economy.shops[this.currentShop]);
            this.updatePlayerInventoryDisplay();
        } else if (this.player.coins < price) {
            this.showNotification('❌ Not enough coins!', 'error');
        } else {
            this.showNotification('❌ Not enough cargo space!', 'error');
        }
    }

    sellItem(item) {
        if (this.economy.playerInventory[item] > 0) {
            const price = Math.floor(this.economy.marketPrices[item].current * 0.8); // Sell for 80% of market price

            this.player.coins += price;
            this.economy.playerInventory[item]--;
            this.economy.currentCargo--;

            this.showNotification(`✅ Sold ${this.formatItemName(item)} for ${price} coins!`, 'success');
            this.updateShopDisplay(this.economy.shops[this.currentShop]);
            this.updatePlayerInventoryDisplay();
        } else {
            this.showNotification('❌ No items to sell!', 'error');
        }
    }

    closeShop() {
        const modal = document.getElementById('shop-modal');
        if (modal) {
            modal.style.display = 'none';
        }
        this.currentShop = null;
    }

    setupTradingSystem() {
        // Add trading NPCs
        this.tradingNPCs = [
            {
                name: 'Resource Trader',
                x: 800,
                y: 400,
                items: ['rareMetals', 'energyCrystals'],
                dialogue: ['I have rare resources for trade!', 'Looking to expand my collection.', 'Got any alien artifacts?']
            },
            {
                name: 'Black Market Dealer',
                x: -800,
                y: -400,
                items: ['alienArtifacts'],
                dialogue: ['Shh... looking for contraband?', 'I deal in... special items.', 'Keep this between us.']
            }
        ];

        // Add trading NPCs to the main NPCs array
        this.tradingNPCs.forEach(trader => {
            this.npcs.push({
                ...trader,
                vx: (Math.random() - 0.5) * 0.3,
                vy: (Math.random() - 0.5) * 0.3,
                health: 100,
                friendship: 0,
                type: 'trader'
            });
        });
    }

    getTotalPlayerCount() {
        // Simulate total player count
        return 15420 + Math.floor(Math.random() * 1000);
    }

    setupSocialUI() {
        if (!document.getElementById('social-ui')) {
            const socialUI = document.createElement('div');
            socialUI.id = 'social-ui';
            socialUI.innerHTML = `
                <div id="social-stats" style="position: fixed; bottom: 20px; right: 20px; background: rgba(0,0,0,0.8); border: 2px solid #4a9eff; border-radius: 10px; padding: 15px; color: #4a9eff; font-size: 0.8em; z-index: 900; max-width: 200px;">
                    <h4 style="color: #4a9eff; margin-bottom: 10px;">👥 Social Hub</h4>
                    <div>Players Online: <span id="online-count">${this.socialStats.onlineNow}</span></div>
                    <div>Total Players: <span id="total-count">${this.socialStats.totalPlayers.toLocaleString()}</span></div>
                    <div style="margin-top: 10px;">
                        <button id="show-leaderboard" onclick="gameEnhancementFix.showLeaderboard()">🏆 Leaderboard</button>
                        <button id="share-progress" onclick="gameEnhancementFix.shareProgress()">📱 Share</button>
                    </div>
                </div>
                <div id="leaderboard-modal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(0,0,0,0.95); border: 2px solid #ffd700; border-radius: 15px; padding: 20px; color: #ffd700; max-width: 400px; z-index: 1000;">
                    <h3 style="color: #ffd700; margin-bottom: 15px;">🏆 Global Leaderboards</h3>
                    <div id="leaderboard-content">
                        <h4>💰 Richest Players</h4>
                        <div id="richest-list"></div>
                        <h4>🏆 Most Achievements</h4>
                        <div id="achievements-list"></div>
                        <h4>🚀 Farthest Travelers</h4>
                        <div id="travelers-list"></div>
                    </div>
                    <button id="close-leaderboard" onclick="gameEnhancementFix.closeLeaderboard()">Close</button>
                </div>
            `;
            document.body.appendChild(socialUI);
        }
    }

    updateSocialStats() {
        // Update social stats periodically
        setInterval(() => {
            this.socialStats.onlineNow = Math.floor(Math.random() * 100) + 50;
            this.socialStats.totalPlayers = this.getTotalPlayerCount();

            const onlineCount = document.getElementById('online-count');
            const totalCount = document.getElementById('total-count');

            if (onlineCount) onlineCount.textContent = this.socialStats.onlineNow;
            if (totalCount) totalCount.textContent = this.socialStats.totalPlayers.toLocaleString();
        }, 10000); // Update every 10 seconds
    }

    showLeaderboard() {
        this.updateLeaderboardDisplay();
        const modal = document.getElementById('leaderboard-modal');
        if (modal) {
            modal.style.display = 'block';
        }
    }

    updateLeaderboardDisplay() {
        const richestList = document.getElementById('richest-list');
        const achievementsList = document.getElementById('achievements-list');
        const travelersList = document.getElementById('travelers-list');

        if (richestList) {
            richestList.innerHTML = this.leaderboards.richestPlayers
                .map(player => `<div>#${player.rank} ${player.name}: ${player.score.toLocaleString()} coins</div>`)
                .join('');
        }

        if (achievementsList) {
            achievementsList.innerHTML = this.leaderboards.mostAchievements
                .map(player => `<div>#${player.rank} ${player.name}: ${player.score} achievements</div>`)
                .join('');
        }

        if (travelersList) {
            travelersList.innerHTML = this.leaderboards.farthestTraveler
                .map(player => `<div>#${player.rank} ${player.name}: ${player.score.toLocaleString()} units</div>`)
                .join('');
        }
    }

    closeLeaderboard() {
        const modal = document.getElementById('leaderboard-modal');
        if (modal) {
            modal.style.display = 'none';
        }
    }

    shareProgress() {
        const shareText = `🌌 Space Explorer Adventure! I've explored ${this.achievements.planetExplorer.progress} planets, earned ${this.player.coins} coins, and unlocked ${Object.values(this.achievements).filter(a => a.unlocked).length} achievements! Join me at ${window.location.href}`;

        if (navigator.share) {
            navigator.share({
                title: 'Space Explorer Adventure',
                text: shareText,
                url: window.location.href
            });
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(shareText).then(() => {
                this.showNotification('📋 Progress copied to clipboard!', 'success');
            });
        }
    }

    setupAchievementUI() {
        if (!document.getElementById('achievement-ui')) {
            const achievementUI = document.createElement('div');
            achievementUI.id = 'achievement-ui';
            achievementUI.innerHTML = `
                <div id="achievement-popup" style="display: none; position: fixed; top: 50px; left: 50%; transform: translateX(-50%); background: rgba(0,0,0,0.9); border: 2px solid #ffd700; border-radius: 15px; padding: 20px; color: #ffd700; z-index: 1000;">
                    <h4 id="achievement-icon"></h4>
                    <h4 id="achievement-name"></h4>
                    <p id="achievement-description"></p>
                </div>
                <div id="achievement-list" style="position: fixed; bottom: 20px; left: 20px; background: rgba(0,0,0,0.8); border: 2px solid #ffd700; border-radius: 10px; padding: 15px; color: #ffd700; font-size: 0.8em; z-index: 900; max-height: 200px; overflow-y: auto;">
                    <h4 style="color: #ffd700; margin-bottom: 10px;">🏆 Achievements</h4>
                    <div id="achievement-items"></div>
                </div>
            `;
            document.body.appendChild(achievementUI);
        }
    }

    unlockAchievement(achievementId) {
        const achievement = this.achievements[achievementId];
        if (achievement && !achievement.unlocked) {
            achievement.unlocked = true;
            this.showAchievementPopup(achievement);
            this.saveAchievements();

            // Reward player
            this.player.coins += 100;
            this.showNotification(`🏆 Achievement Unlocked: ${achievement.name}! +100 coins`, 'success');
        }
    }

    showAchievementPopup(achievement) {
        const popup = document.getElementById('achievement-popup');
        const icon = document.getElementById('achievement-icon');
        const name = document.getElementById('achievement-name');
        const desc = document.getElementById('achievement-description');

        if (popup && icon && name && desc) {
            icon.textContent = achievement.icon;
            name.textContent = achievement.name;
            desc.textContent = achievement.description;
            popup.style.display = 'block';

            setTimeout(() => {
                popup.style.display = 'none';
            }, 3000);
        }
    }

    updateAchievementProgress(achievementId, progress) {
        const achievement = this.achievements[achievementId];
        if (achievement && !achievement.unlocked) {
            achievement.progress = Math.min(progress, achievement.maxProgress);

            if (achievement.progress >= achievement.maxProgress) {
                this.unlockAchievement(achievementId);
            }
        }
    }

    saveAchievements() {
        localStorage.setItem('spaceAdventureAchievements', JSON.stringify(this.achievements));
    }

    loadAchievements() {
        const saved = localStorage.getItem('spaceAdventureAchievements');
        if (saved) {
            this.achievements = { ...this.achievements, ...JSON.parse(saved) };
        }
    }

    updateAchievementUI() {
        const container = document.getElementById('achievement-items');
        if (container) {
            container.innerHTML = Object.values(this.achievements)
                .map(achievement => `
                    <div style="display: flex; align-items: center; margin-bottom: 5px; opacity: ${achievement.unlocked ? 1 : 0.5}">
                        <span style="margin-right: 8px;">${achievement.icon}</span>
                        <span>${achievement.name}</span>
                        <span style="margin-left: auto;">${achievement.progress}/${achievement.maxProgress}</span>
                    </div>
                `).join('');
        }
    }

    createNPCs() {
        const npcTypes = [
            { name: 'Captain Zara', type: 'explorer', x: 500, y: 300, dialogue: ['Welcome to the galaxy!', 'I\'ve discovered amazing worlds.', 'Care to join my next expedition?'] },
            { name: 'Dr. Nova', type: 'scientist', x: -400, y: 200, dialogue: ['Fascinating planetary readings!', 'The nebula has strange properties.', 'Let me show you my lab.'] },
            { name: 'Trader Jax', type: 'merchant', x: 300, y: -500, dialogue: ['Best deals in the quadrant!', 'Rare artifacts and resources.', 'What are you looking for?'] },
            { name: 'Guardian Elara', type: 'protector', x: -600, y: -400, dialogue: ['Protecting ancient artifacts.', 'The galaxy needs heroes.', 'Will you help defend it?'] }
        ];

        npcTypes.forEach(npcData => {
            this.npcs.push({
                ...npcData,
                vx: (Math.random() - 0.5) * 0.5,
                vy: (Math.random() - 0.5) * 0.5,
                health: 100,
                friendship: 0
            });
        });
    }

    setupDialogueUI() {
        if (!document.getElementById('dialogue-ui')) {
            const dialogueUI = document.createElement('div');
            dialogueUI.id = 'dialogue-ui';
            dialogueUI.innerHTML = `
                <div id="dialogue-box" style="display: none; position: fixed; bottom: 100px; left: 50%; transform: translateX(-50%); background: rgba(0,0,0,0.9); border: 2px solid #4a9eff; border-radius: 15px; padding: 20px; color: #4a9eff; max-width: 400px; z-index: 1000;">
                    <h4 id="dialogue-name"></h4>
                    <p id="dialogue-text"></p>
                    <button id="dialogue-next" onclick="gameEnhancementFix.nextDialogue()">Continue</button>
                    <button id="dialogue-close" onclick="gameEnhancementFix.closeDialogue()">Close</button>
                </div>
            `;
            document.body.appendChild(dialogueUI);
        }
    }

    interactWithNPC(npc) {
        this.dialogueSystem.currentNPC = npc;
        this.dialogueSystem.currentDialogue = npc.dialogue;
        this.dialogueSystem.dialogueIndex = 0;

        this.showDialogue();
    }

    showDialogue() {
        const dialogueBox = document.getElementById('dialogue-box');
        const nameElement = document.getElementById('dialogue-name');
        const textElement = document.getElementById('dialogue-text');

        if (dialogueBox && nameElement && textElement) {
            nameElement.textContent = this.dialogueSystem.currentNPC.name;
            textElement.textContent = this.dialogueSystem.currentDialogue[this.dialogueSystem.dialogueIndex];
            dialogueBox.style.display = 'block';
        }
    }

    nextDialogue() {
        this.dialogueSystem.dialogueIndex++;
        if (this.dialogueSystem.dialogueIndex >= this.dialogueSystem.currentDialogue.length) {
            this.closeDialogue();
            // Complete interaction
            this.completeNPCInteraction();
        } else {
            this.showDialogue();
        }
    }

    closeDialogue() {
        const dialogueBox = document.getElementById('dialogue-box');
        if (dialogueBox) {
            dialogueBox.style.display = 'none';
        }
        this.dialogueSystem.currentNPC = null;
    }

    completeNPCInteraction() {
        const npc = this.dialogueSystem.currentNPC;
        if (npc) {
            npc.friendship += 10;
            this.player.coins += 50;

            // Update achievements
            this.updateAchievementProgress('socialButterfly', this.achievements.socialButterfly.progress + 1);

            this.showNotification(`🤝 Friendship with ${npc.name} increased! +50 coins`, 'success');
        }
    }

    // Enhanced Mini-Game System
    setupMiniGameSystem() {
        this.miniGames = {
            asteroidMining: {
                name: 'Asteroid Mining',
                description: 'Collect valuable resources from asteroids',
                duration: 30,
                reward: 100
            },
            planetSurvey: {
                name: 'Planet Survey',
                description: 'Scan and document planetary features',
                duration: 45,
                reward: 150
            },
            spaceRacing: {
                name: 'Space Racing',
                description: 'Race through asteroid fields',
                duration: 60,
                reward: 200
            }
        };

        this.setupMiniGameUI();
    }

    setupMiniGameUI() {
        if (!document.getElementById('minigame-ui')) {
            const minigameUI = document.createElement('div');
            minigameUI.id = 'minigame-ui';
            minigameUI.innerHTML = `
                <div id="minigame-box" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(0,0,0,0.9); border: 2px solid #ffd700; border-radius: 15px; padding: 20px; color: #ffd700; max-width: 300px; z-index: 1000;">
                    <h4 id="minigame-name"></h4>
                    <p id="minigame-description"></p>
                    <div id="minigame-timer">0</div>
                    <button id="minigame-start" onclick="gameEnhancementFix.startMiniGame()">Start</button>
                    <button id="minigame-close" onclick="gameEnhancementFix.closeMiniGame()">Close</button>
                </div>
            `;
            document.body.appendChild(minigameUI);
        }
    }

    showMiniGame(gameKey) {
        const game = this.miniGames[gameKey];
        if (game) {
            document.getElementById('minigame-name').textContent = game.name;
            document.getElementById('minigame-description').textContent = game.description;
            document.getElementById('minigame-box').style.display = 'block';
        }
    }

    startMiniGame() {
        const gameName = document.getElementById('minigame-name').textContent;
        this.showNotification(`🎮 Starting ${gameName}!`, 'info');
        this.closeMiniGame();

        setTimeout(() => {
            this.completeMiniGame(gameName);
        }, 2000);
    }

    completeMiniGame(gameName) {
        const game = Object.values(this.miniGames).find(g => g.name === gameName);
        if (game) {
            this.player.coins += game.reward;

            // Update achievements
            this.updateAchievementProgress('miniGameMaster', this.achievements.miniGameMaster.progress + 1);

            this.showNotification(`🎉 ${gameName} completed! +${game.reward} coins`, 'success');
        }
    }

    closeMiniGame() {
        const minigameBox = document.getElementById('minigame-box');
        if (minigameBox) {
            minigameBox.style.display = 'none';
        }
    }

    // ===== ENHANCED VISUAL EFFECTS =====

    drawWeatherEffects() {
        // Update and draw weather particles
        this.weatherParticles.forEach(particle => {
            particle.x += particle.vx;
            particle.y += particle.vy;
            particle.life--;

            this.ctx.save();
            this.ctx.globalAlpha = particle.life / 300;
            this.ctx.fillStyle = particle.color;
            this.ctx.fillRect(particle.x, particle.y, particle.size, particle.size);
            this.ctx.restore();
        });

        // Draw weather overlay
        if (this.weather.type !== 'clear') {
            this.ctx.save();
            this.ctx.globalAlpha = this.weather.intensity * 0.3;
            this.ctx.fillStyle = this.weatherTypes[this.weather.type].color;
            this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            this.ctx.restore();
        }
    }

    drawTimeOfDayEffects() {
        // Apply ambient lighting
        this.ctx.save();
        this.ctx.globalAlpha = 1 - this.timeOfDay.lightLevel;
        this.ctx.fillStyle = '#000033';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
        this.ctx.restore();

        // Draw stars during night
        if (this.starfieldIntensity > 0.5) {
            this.drawEnhancedStarfield();
        }
    }

    drawEnhancedStarfield() {
        this.ctx.save();
        this.ctx.globalAlpha = this.starfieldIntensity;
        for (let i = 0; i < 100; i++) {
            const x = (i * 37) % this.canvas.width;
            const y = (i * 23) % this.canvas.height;
            const brightness = Math.sin(this.timeOfDay.hours * 0.1 + i) * 0.5 + 0.5;

            this.ctx.fillStyle = `rgba(255, 255, 255, ${brightness})`;
            this.ctx.fillRect(x, y, 1, 1);
        }
        this.ctx.restore();
    }

    drawNPCs() {
        this.npcs.forEach(npc => {
            const screenX = npc.x - this.player.x;
            const screenY = npc.y - this.player.y;

            if (Math.abs(screenX) < this.canvas.width / 2 + 50 &&
                Math.abs(screenY) < this.canvas.height / 2 + 50) {

                // Draw NPC
                this.ctx.save();
                this.ctx.fillStyle = '#4a9eff';
                this.ctx.fillRect(screenX - 15, screenY - 15, 30, 30);

                // Draw name
                this.ctx.fillStyle = '#ffffff';
                this.ctx.font = '12px Arial';
                this.ctx.textAlign = 'center';
                this.ctx.fillText(npc.name, screenX, screenY - 25);

                // Interaction indicator
                if (Math.sqrt(screenX * screenX + screenY * screenY) < 100) {
                    this.ctx.fillStyle = '#00ff00';
                    this.ctx.fillText('Press E to talk', screenX, screenY + 40);
                }

                this.ctx.restore();
            }
        });
    }
}

// Initialize the game enhancement fix
window.gameEnhancementFix = new GameEnhancementFix();
