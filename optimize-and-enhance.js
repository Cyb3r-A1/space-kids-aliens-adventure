// Performance Optimization and Complete Enhancement System
class GameOptimizer {
    constructor(game) {
        this.game = game;
        this.canvas = game.canvas;
        this.ctx = game.ctx;

        // Performance metrics
        this.metrics = {
            fps: 0,
            frameTime: 0,
            drawCalls: 0,
            objectsRendered: 0,
            memoryUsage: 0
        };

        // Optimization settings
        this.optimizations = {
            culling: true,
            levelOfDetail: true,
            textureCompression: true,
            batchRendering: true,
            particleOptimization: true,
            memoryManagement: true
        };

        this.init();
    }

    init() {
        this.setupPerformanceMonitoring();
        this.setupOptimizationSystems();
        this.createPerformanceUI();
        console.log('🚀 Game Optimization System Initialized');
    }

    setupPerformanceMonitoring() {
        // Frame rate monitoring
        this.lastFrameTime = performance.now();
        this.frameCount = 0;
        this.fpsUpdateTimer = 0;

        // Memory monitoring
        if (performance.memory) {
            this.memoryInterval = setInterval(() => {
                this.metrics.memoryUsage = performance.memory.usedJSHeapSize / 1024 / 1024; // MB
            }, 1000);
        }
    }

    setupOptimizationSystems() {
        // Frustum culling for 3D objects
        this.setupFrustumCulling();

        // Level of detail system
        this.setupLevelOfDetail();

        // Batch rendering system
        this.setupBatchRendering();

        // Particle optimization
        this.setupParticleOptimization();
    }

    setupFrustumCulling() {
        this.frustum = {
            left: -this.canvas.width / 2,
            right: this.canvas.width / 2,
            top: -this.canvas.height / 2,
            bottom: this.canvas.height / 2,
            near: 0,
            far: 1000
        };
    }

    setupLevelOfDetail() {
        this.lod = {
            high: { maxDistance: 200, detail: 1.0 },
            medium: { maxDistance: 500, detail: 0.6 },
            low: { maxDistance: 1000, detail: 0.3 },
            veryLow: { maxDistance: Infinity, detail: 0.1 }
        };
    }

    setupBatchRendering() {
        this.batchRenderer = {
            stars: [],
            planets: [],
            particles: [],
            ui: []
        };
    }

    setupParticleOptimization() {
        this.particleLimits = {
            maxParticles: 500,
            maxParticlesPerEmitter: 50,
            particleCleanupThreshold: 300
        };
    }

    createPerformanceUI() {
        const perfUI = document.createElement('div');
        perfUI.id = 'performance-ui';
        perfUI.innerHTML = `
            <div style="position: fixed; top: 20px; left: 20px; background: rgba(0,0,0,0.8); border: 2px solid #00ff00; border-radius: 10px; padding: 15px; color: #00ff00; font-family: monospace; z-index: 1000;">
                <h4 style="color: #00ff00; margin: 0 0 10px 0;">⚡ Performance Monitor</h4>
                <div id="perf-stats" style="font-size: 0.8em; line-height: 1.4;">
                    <div>FPS: <span id="fps">60</span></div>
                    <div>Frame: <span id="frameTime">16.7ms</span></div>
                    <div>Draws: <span id="drawCalls">0</span></div>
                    <div>Objects: <span id="objects">0</span></div>
                    <div>Memory: <span id="memory">0MB</span></div>
                </div>
                <div style="margin-top: 10px; font-size: 0.7em; color: #ffff00;">
                    <div>Optimizations: <span id="optimizations">Active</span></div>
                </div>
            </div>
        `;
        document.body.appendChild(perfUI);
    }

    updatePerformanceMetrics(deltaTime) {
        this.frameCount++;
        this.fpsUpdateTimer += deltaTime;

        if (this.fpsUpdateTimer >= 1000) { // Update every second
            this.metrics.fps = Math.round(this.frameCount * 1000 / this.fpsUpdateTimer);
            this.frameCount = 0;
            this.fpsUpdateTimer = 0;
        }

        this.metrics.frameTime = Math.round(deltaTime * 100) / 100;
        this.updatePerformanceUI();
    }

    updatePerformanceUI() {
        const fpsElement = document.getElementById('fps');
        const frameTimeElement = document.getElementById('frameTime');
        const drawCallsElement = document.getElementById('drawCalls');
        const objectsElement = document.getElementById('objects');
        const memoryElement = document.getElementById('memory');

        if (fpsElement) fpsElement.textContent = this.metrics.fps;
        if (frameTimeElement) frameTimeElement.textContent = this.metrics.frameTime + 'ms';
        if (drawCallsElement) drawCallsElement.textContent = this.metrics.drawCalls;
        if (objectsElement) objectsElement.textContent = this.metrics.objectsRendered;
        if (memoryElement) memoryElement.textContent = Math.round(this.metrics.memoryUsage) + 'MB';
    }

    // Frustum culling optimization
    isInFrustum(object, camera) {
        if (!this.optimizations.culling) return true;

        const objX = object.x - camera.x;
        const objY = object.y - camera.y;

        return objX >= this.frustum.left && objX <= this.frustum.right &&
               objY >= this.frustum.top && objY <= this.frustum.bottom;
    }

    // Level of detail optimization
    getLODLevel(object, camera) {
        if (!this.optimizations.levelOfDetail) return 1.0;

        const distance = Math.sqrt(
            Math.pow(object.x - camera.x, 2) +
            Math.pow(object.y - camera.y, 2)
        );

        for (const [level, config] of Object.entries(this.lod)) {
            if (distance <= config.maxDistance) {
                return config.detail;
            }
        }
        return this.lod.veryLow.detail;
    }

    // Batch rendering optimization
    batchRender(objects, renderFunction) {
        if (!this.optimizations.batchRendering) {
            objects.forEach(obj => renderFunction(obj));
            return;
        }

        // Sort objects by type for batching
        const batches = {};
        objects.forEach(obj => {
            const type = obj.constructor.name || 'Unknown';
            if (!batches[type]) batches[type] = [];
            batches[type].push(obj);
        });

        // Render each batch
        Object.entries(batches).forEach(([type, batch]) => {
            this.renderBatch(batch, renderFunction);
        });
    }

    renderBatch(batch, renderFunction) {
        // Set up batch-specific optimizations
        if (batch.length > 10) {
            this.ctx.globalCompositeOperation = 'lighter';
        }

        batch.forEach(obj => renderFunction(obj));

        // Reset composite operation
        this.ctx.globalCompositeOperation = 'source-over';
    }

    // Particle optimization
    optimizeParticles(particles) {
        if (!this.optimizations.particleOptimization) return particles;

        // Limit total particles
        if (particles.length > this.particleLimits.maxParticles) {
            particles = particles.slice(-this.particleLimits.maxParticles);
        }

        // Remove particles that are too far or too old
        return particles.filter(particle => {
            const distance = Math.sqrt(particle.x * particle.x + particle.y * particle.y);
            return distance < 2000 && particle.life > 0;
        });
    }

    // Memory management
    cleanupMemory() {
        if (!this.optimizations.memoryManagement) return;

        // Clear unused objects periodically
        if (Math.random() < 0.01) { // 1% chance each frame
            if (this.game.particles && this.game.particles.length > this.particleLimits.particleCleanupThreshold) {
                this.game.particles = this.game.particles.slice(-this.particleLimits.particleCleanupThreshold);
            }
        }

        // Force garbage collection if available
        if (window.gc) {
            window.gc();
        }
    }

    // Main optimization update
    updateOptimizations(deltaTime) {
        this.updatePerformanceMetrics(deltaTime);
        this.cleanupMemory();

        // Adjust quality based on performance
        if (this.metrics.fps < 30 && this.metrics.fps > 0) {
            this.reduceQuality();
        } else if (this.metrics.fps > 50) {
            this.increaseQuality();
        }
    }

    reduceQuality() {
        console.log('⚡ Reducing quality for better performance');
        // Disable some effects
        if (typeof window.advancedVisualEffects !== 'undefined') {
            window.advancedVisualEffects.disableEffect('bloom');
            window.advancedVisualEffects.disableEffect('chromaticAberration');
        }
    }

    increaseQuality() {
        console.log('✨ Increasing quality - good performance');
        // Enable effects
        if (typeof window.advancedVisualEffects !== 'undefined') {
            window.advancedVisualEffects.enableEffect('bloom');
            window.advancedVisualEffects.enableEffect('chromaticAberration');
        }
    }

    // Advanced rendering optimizations
    optimizeRendering(objects, renderFunction, camera) {
        let drawCalls = 0;
        let objectsRendered = 0;

        // Apply frustum culling
        const visibleObjects = objects.filter(obj => this.isInFrustum(obj, camera));

        // Apply level of detail
        const lodObjects = visibleObjects.map(obj => ({
            ...obj,
            lod: this.getLODLevel(obj, camera)
        }));

        // Batch render
        this.batchRender(lodObjects, (obj) => {
            if (obj.lod > 0.1) { // Only render if LOD is above threshold
                renderFunction(obj);
                drawCalls++;
                objectsRendered++;
            }
        });

        this.metrics.drawCalls = drawCalls;
        this.metrics.objectsRendered = objectsRendered;
    }
}

// Export for use in the main game
window.GameOptimizer = GameOptimizer;
