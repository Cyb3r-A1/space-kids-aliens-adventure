// Advanced Gameplay Mechanics for Space Explorer Adventure
class AdvancedGameplayMechanics {
    constructor(game) {
        this.game = game;
        this.canvas = game.canvas;
        this.ctx = game.ctx;

        // Advanced gameplay systems
        this.systems = {
            missionSystem: this.createMissionSystem(),
            inventorySystem: this.createInventorySystem(),
            craftingSystem: this.createCraftingSystem(),
            reputationSystem: this.createReputationSystem(),
            explorationSystem: this.createExplorationSystem(),
            eventSystem: this.createEventSystem(),
            weatherSystem: this.createWeatherSystem(),
            timeSystem: this.createTimeSystem()
        };

        // Interactive elements
        this.interactiveElements = [];
        this.npcs = [];
        this.collectibles = [];
        this.quests = [];

        this.init();
    }

    init() {
        this.setupAdvancedMechanics();
        this.createInteractiveWorld();
        this.setupAdvancedUI();
        console.log('🚀 Advanced Gameplay Mechanics System Initialized');
    }

    setupAdvancedMechanics() {
        // Add advanced mechanics to the game
        this.game.advancedMechanics = {
            missions: this.systems.missionSystem.getAvailableMissions(),
            inventory: this.systems.inventorySystem.getInventory(),
            reputation: this.systems.reputationSystem.getReputation(),
            exploration: this.systems.explorationSystem.getExplorationData(),
            events: this.systems.eventSystem.getActiveEvents(),
            weather: this.systems.weatherSystem.getCurrentWeather(),
            time: this.systems.timeSystem.getCurrentTime()
        };
    }

    createInteractiveWorld() {
        // Create interactive NPCs
        this.createNPCs();
        this.createCollectibles();
        this.createInteractiveObjects();
        this.createQuestItems();
    }

    setupAdvancedUI() {
        // Create advanced UI elements
        this.createMissionTracker();
        this.createInventoryUI();
        this.createReputationUI();
        this.createNotificationSystem();
    }

    // Mission System
    createMissionSystem() {
        return {
            missions: [
                {
                    id: 'first_contact',
                    title: 'First Contact',
                    description: 'Establish contact with an alien species',
                    objectives: [
                        { description: 'Land on Terranova', completed: false },
                        { description: 'Find alien settlement', completed: false },
                        { description: 'Communicate with aliens', completed: false }
                    ],
                    rewards: { credits: 500, reputation: 10, item: 'translator' },
                    difficulty: 'Easy'
                },
                {
                    id: 'resource_hunt',
                    title: 'Resource Hunt',
                    description: 'Gather rare resources from asteroid fields',
                    objectives: [
                        { description: 'Mine 10 crystals', completed: false },
                        { description: 'Avoid asteroid collisions', completed: false },
                        { description: 'Return safely to station', completed: false }
                    ],
                    rewards: { credits: 1000, reputation: 15, item: 'mining_laser' },
                    difficulty: 'Medium'
                },
                {
                    id: 'space_rescue',
                    title: 'Space Rescue',
                    description: 'Rescue stranded spacecraft in asteroid field',
                    objectives: [
                        { description: 'Locate distress signal', completed: false },
                        { description: 'Navigate asteroid field', completed: false },
                        { description: 'Rescue crew members', completed: false }
                    ],
                    rewards: { credits: 2000, reputation: 25, item: 'rescue_beacon' },
                    difficulty: 'Hard'
                }
            ],

            getAvailableMissions() {
                return this.missions.filter(mission => !mission.completed);
            },

            completeMission(missionId) {
                const mission = this.missions.find(m => m.id === missionId);
                if (mission) {
                    mission.completed = true;
                    console.log(`🎯 Mission Completed: ${mission.title}`);
                    return mission.rewards;
                }
                return null;
            }
        };
    }

    // Inventory System
    createInventorySystem() {
        return {
            items: [
                { id: 'medkit', name: 'Med Kit', type: 'consumable', quantity: 5, description: 'Restores 50 HP' },
                { id: 'fuel_cell', name: 'Fuel Cell', type: 'resource', quantity: 20, description: 'Spacecraft fuel' },
                { id: 'crystal', name: 'Energy Crystal', type: 'resource', quantity: 0, description: 'Valuable energy source' },
                { id: 'translator', name: 'Universal Translator', type: 'tool', quantity: 0, description: 'Communicate with aliens' }
            ],

            getInventory() {
                return this.items;
            },

            addItem(itemId, quantity = 1) {
                const item = this.items.find(i => i.id === itemId);
                if (item) {
                    item.quantity += quantity;
                    console.log(`📦 Added ${quantity} x ${item.name} to inventory`);
                }
            },

            removeItem(itemId, quantity = 1) {
                const item = this.items.find(i => i.id === itemId);
                if (item && item.quantity >= quantity) {
                    item.quantity -= quantity;
                    console.log(`📦 Removed ${quantity} x ${item.name} from inventory`);
                    return true;
                }
                return false;
            }
        };
    }

    // Crafting System
    createCraftingSystem() {
        return {
            recipes: [
                {
                    id: 'advanced_fuel',
                    name: 'Advanced Fuel',
                    ingredients: [{ id: 'fuel_cell', quantity: 5 }, { id: 'crystal', quantity: 2 }],
                    result: { id: 'advanced_fuel', quantity: 1 },
                    description: 'More efficient spacecraft fuel'
                },
                {
                    id: 'repair_kit',
                    name: 'Repair Kit',
                    ingredients: [{ id: 'crystal', quantity: 1 }, { id: 'medkit', quantity: 2 }],
                    result: { id: 'repair_kit', quantity: 1 },
                    description: 'Repairs spacecraft hull damage'
                }
            ],

            craft(recipeId) {
                const recipe = this.recipes.find(r => r.id === recipeId);
                if (recipe) {
                    // Check if player has ingredients
                    // Implementation would go here
                    console.log(`🔧 Crafting: ${recipe.name}`);
                    return recipe.result;
                }
                return null;
            }
        };
    }

    // Reputation System
    createReputationSystem() {
        return {
            factions: [
                { id: 'terrans', name: 'Terran Alliance', reputation: 0, color: '#6bb6ff' },
                { id: 'aliens', name: 'Alien Collective', reputation: 0, color: '#ff6b35' },
                { id: 'traders', name: 'Space Traders', reputation: 0, color: '#ffd700' },
                { id: 'explorers', name: 'Explorer Guild', reputation: 0, color: '#4a9eff' }
            ],

            getReputation() {
                return this.factions;
            },

            modifyReputation(factionId, amount) {
                const faction = this.factions.find(f => f.id === factionId);
                if (faction) {
                    faction.reputation = Math.max(-100, Math.min(100, faction.reputation + amount));
                    console.log(`🏆 ${faction.name} reputation: ${faction.reputation}`);
                }
            }
        };
    }

    // Exploration System
    createExplorationSystem() {
        return {
            discoveredLocations: [],
            scannedObjects: [],
            explorationScore: 0,

            getExplorationData() {
                return {
                    locations: this.discoveredLocations.length,
                    objects: this.scannedObjects.length,
                    score: this.explorationScore,
                    completion: Math.min(100, (this.discoveredLocations.length + this.scannedObjects.length) * 10)
                };
            },

            discoverLocation(locationId) {
                if (!this.discoveredLocations.includes(locationId)) {
                    this.discoveredLocations.push(locationId);
                    this.explorationScore += 10;
                    console.log(`🗺️ Discovered location: ${locationId}`);
                }
            },

            scanObject(objectId) {
                if (!this.scannedObjects.includes(objectId)) {
                    this.scannedObjects.push(objectId);
                    this.explorationScore += 5;
                    console.log(`🔍 Scanned object: ${objectId}`);
                }
            }
        };
    }

    // Event System
    createEventSystem() {
        return {
            activeEvents: [
                {
                    id: 'meteor_shower',
                    name: 'Meteor Shower',
                    description: 'Increased meteor activity - collect rare materials',
                    duration: 300, // seconds
                    effects: { resource_multiplier: 2, danger_level: 'high' }
                },
                {
                    id: 'alien_festival',
                    name: 'Alien Cultural Festival',
                    description: 'Aliens are celebrating - improved trading rates',
                    duration: 600,
                    effects: { trade_bonus: 1.5, reputation_gain: 2 }
                }
            ],

            getActiveEvents() {
                return this.activeEvents.filter(event => event.duration > 0);
            },

            updateEvents(deltaTime) {
                this.activeEvents.forEach(event => {
                    event.duration -= deltaTime;
                });
            }
        };
    }

    // Weather System
    createWeatherSystem() {
        return {
            weatherTypes: [
                { name: 'Clear', effects: { visibility: 1.0, movement_speed: 1.0 } },
                { name: 'Asteroid Storm', effects: { visibility: 0.6, movement_speed: 0.8 } },
                { name: 'Solar Flare', effects: { visibility: 0.9, energy_regen: 1.5 } },
                { name: 'Nebula', effects: { visibility: 0.7, stealth_bonus: 1.3 } }
            ],

            currentWeather: 'Clear',
            weatherTimer: 0,

            getCurrentWeather() {
                return this.currentWeather;
            },

            updateWeather(deltaTime) {
                this.weatherTimer += deltaTime;
                if (this.weatherTimer > 60) { // Change weather every minute
                    this.currentWeather = this.weatherTypes[Math.floor(Math.random() * this.weatherTypes.length)].name;
                    this.weatherTimer = 0;
                    console.log(`🌤️ Weather changed to: ${this.currentWeather}`);
                }
            }
        };
    }

    // Time System
    createTimeSystem() {
        return {
            gameTime: 0,
            timeScale: 1,
            dayNightCycle: true,

            getCurrentTime() {
                const hours = Math.floor(this.gameTime / 3600) % 24;
                const minutes = Math.floor((this.gameTime % 3600) / 60);
                return { hours, minutes, dayPhase: this.getDayPhase() };
            },

            getDayPhase() {
                const hours = Math.floor(this.gameTime / 3600) % 24;
                if (hours < 6) return 'night';
                if (hours < 12) return 'morning';
                if (hours < 18) return 'day';
                return 'evening';
            },

            updateTime(deltaTime) {
                this.gameTime += deltaTime * this.timeScale;
            }
        };
    }

    createNPCs() {
        // Create interactive NPCs
        this.npcs = [
            {
                id: 'alien_trader',
                x: 400,
                y: 300,
                name: 'Zog the Trader',
                type: 'merchant',
                dialogue: [
                    'Greetings, space explorer!',
                    'I have rare goods from distant worlds.',
                    'Show me what you have to trade!'
                ],
                inventory: ['energy_crystal', 'alien_artifact', 'navigation_chip']
            },
            {
                id: 'space_pilot',
                x: 600,
                y: 400,
                name: 'Captain Nova',
                type: 'quest_giver',
                dialogue: [
                    'I need help with a dangerous mission.',
                    'There are stranded ships in the asteroid field.',
                    'Can you rescue them for me?'
                ],
                quests: ['space_rescue']
            },
            {
                id: 'scientist',
                x: 300,
                y: 500,
                name: 'Dr. Elara',
                type: 'scientist',
                dialogue: [
                    'Fascinating readings from this planet!',
                    'The alien technology here is incredible.',
                    'Would you help me collect samples?'
                ],
                research: ['planet_scanning', 'alien_tech']
            }
        ];

        console.log(`👥 Created ${this.npcs.length} interactive NPCs`);
    }

    createCollectibles() {
        // Create collectible items
        this.collectibles = [
            { id: 'energy_crystal', x: 500, y: 200, value: 100, rarity: 'rare' },
            { id: 'data_chip', x: 350, y: 450, value: 50, rarity: 'common' },
            { id: 'alien_artifact', x: 650, y: 300, value: 500, rarity: 'epic' },
            { id: 'fuel_canister', x: 450, y: 550, value: 25, rarity: 'common' }
        ];

        console.log(`💎 Created ${this.collectibles.length} collectible items`);
    }

    createInteractiveObjects() {
        // Create interactive objects
        this.interactiveElements = [
            {
                id: 'trading_console',
                x: 400,
                y: 250,
                type: 'trading_terminal',
                name: 'Trading Terminal',
                description: 'Buy and sell goods with automated systems'
            },
            {
                id: 'repair_station',
                x: 550,
                y: 350,
                type: 'repair_station',
                name: 'Repair Station',
                description: 'Repair spacecraft and equipment'
            },
            {
                id: 'research_lab',
                x: 300,
                y: 450,
                type: 'research_lab',
                name: 'Research Laboratory',
                description: 'Analyze samples and conduct experiments'
            }
        ];

        console.log(`🏗️ Created ${this.interactiveElements.length} interactive objects`);
    }

    createQuestItems() {
        // Create quest-specific items
        this.quests = [
            {
                id: 'distress_beacon',
                name: 'Distress Beacon',
                description: 'Locate and activate the distress beacon',
                location: { x: 700, y: 200 },
                reward: 1000
            },
            {
                id: 'alien_datapad',
                name: 'Alien Datapad',
                description: 'Retrieve the stolen alien datapad',
                location: { x: 200, y: 600 },
                reward: 750
            }
        ];

        console.log(`📋 Created ${this.quests.length} quest objectives`);
    }

    createMissionTracker() {
        // Create mission tracking UI
        const missionTracker = document.createElement('div');
        missionTracker.id = 'mission-tracker';
        missionTracker.innerHTML = `
            <div style="background: rgba(0,0,0,0.9); border: 2px solid #ffd700; border-radius: 15px; padding: 15px; color: #ffd700; margin: 10px;">
                <h4 style="color: #ffd700; margin-bottom: 10px;">🚀 Active Missions</h4>
                <div id="mission-list"></div>
            </div>
        `;
        document.body.appendChild(missionTracker);
    }

    createInventoryUI() {
        // Create inventory management UI
        const inventoryUI = document.createElement('div');
        inventoryUI.id = 'inventory-ui';
        inventoryUI.innerHTML = `
            <div style="background: rgba(0,0,0,0.9); border: 2px solid #4a9eff; border-radius: 15px; padding: 15px; color: #4a9eff; margin: 10px;">
                <h4 style="color: #4a9eff; margin-bottom: 10px;">🎒 Inventory</h4>
                <div id="inventory-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;"></div>
            </div>
        `;
        document.body.appendChild(inventoryUI);
    }

    createReputationUI() {
        // Create reputation tracking UI
        const reputationUI = document.createElement('div');
        reputationUI.id = 'reputation-ui';
        reputationUI.innerHTML = `
            <div style="background: rgba(0,0,0,0.9); border: 2px solid #ff6b35; border-radius: 15px; padding: 15px; color: #ff6b35; margin: 10px;">
                <h4 style="color: #ff6b35; margin-bottom: 10px;">🏆 Reputation</h4>
                <div id="reputation-list"></div>
            </div>
        `;
        document.body.appendChild(reputationUI);
    }

    createNotificationSystem() {
        // Create notification system
        this.notificationContainer = document.createElement('div');
        this.notificationContainer.id = 'notifications';
        this.notificationContainer.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            max-width: 300px;
        `;
        document.body.appendChild(this.notificationContainer);
    }

    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.style.cssText = `
            background: rgba(0,0,0,0.9);
            border: 2px solid ${type === 'success' ? '#00ff00' : type === 'warning' ? '#ffff00' : '#4a9eff'};
            border-radius: 10px;
            padding: 10px;
            margin-bottom: 10px;
            color: ${type === 'success' ? '#00ff00' : type === 'warning' ? '#ffff00' : '#4a9eff'};
            animation: slideInRight 0.5s ease;
        `;

        const emoji = type === 'success' ? '✅' : type === 'warning' ? '⚠️' : 'ℹ️';
        notification.innerHTML = `${emoji} ${message}`;

        this.notificationContainer.appendChild(notification);

        // Remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.style.animation = 'slideOutRight 0.5s ease';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 500);
            }
        }, 5000);
    }

    updateUI() {
        // Update mission tracker
        const missionList = document.getElementById('mission-list');
        if (missionList) {
            missionList.innerHTML = this.game.advancedMechanics.missions.slice(0, 3).map(mission =>
                `<div style="padding: 5px; border-bottom: 1px solid #ffd700;">
                    <strong>${mission.title}</strong><br>
                    <small>${mission.objectives.filter(obj => !obj.completed).length} objectives remaining</small>
                </div>`
            ).join('');
        }

        // Update inventory
        const inventoryGrid = document.getElementById('inventory-grid');
        if (inventoryGrid) {
            inventoryGrid.innerHTML = this.game.advancedMechanics.inventory.slice(0, 6).map(item =>
                `<div style="text-align: center; padding: 5px; background: rgba(74,158,255,0.1); border-radius: 5px;">
                    <div style="font-size: 0.8em;">${item.name}</div>
                    <div style="font-size: 0.6em; color: #ffd700;">${item.quantity}</div>
                </div>`
            ).join('');
        }

        // Update reputation
        const reputationList = document.getElementById('reputation-list');
        if (reputationList) {
            reputationList.innerHTML = this.game.advancedMechanics.reputation.map(faction =>
                `<div style="padding: 5px; border-bottom: 1px solid #ff6b35;">
                    <span style="color: ${faction.reputation > 50 ? '#00ff00' : faction.reputation > 0 ? '#ffff00' : '#ff6b35'};">${faction.name}</span>
                    <span style="float: right;">${faction.reputation}</span>
                </div>`
            ).join('');
        }
    }

    // Advanced interaction methods
    interactWithNPC(npcId) {
        const npc = this.npcs.find(n => n.id === npcId);
        if (npc) {
            this.showNotification(`Interacting with ${npc.name}`, 'info');
            console.log(`👥 Interacting with NPC: ${npc.name}`);
        }
    }

    collectItem(itemId) {
        this.game.advancedMechanics.inventory.forEach(item => {
            if (item.id === itemId) {
                item.quantity++;
                this.showNotification(`Collected ${item.name}`, 'success');
                console.log(`💎 Collected: ${item.name}`);
            }
        });
    }

    checkProximity() {
        const player = this.game.player;
        const proximityRange = 50;

        // Check NPC proximity
        this.npcs.forEach(npc => {
            const distance = Math.sqrt(
                Math.pow(player.x - npc.x, 2) +
                Math.pow(player.y - npc.y, 2)
            );

            if (distance < proximityRange) {
                this.showNotification(`Press E to talk to ${npc.name}`, 'info');
            }
        });

        // Check collectible proximity
        this.collectibles.forEach(item => {
            const distance = Math.sqrt(
                Math.pow(player.x - item.x, 2) +
                Math.pow(player.y - item.y, 2)
            );

            if (distance < proximityRange) {
                this.showNotification(`Press E to collect ${item.id}`, 'info');
            }
        });
    }
}

// Export for use in the main game
window.AdvancedGameplayMechanics = AdvancedGameplayMechanics;
