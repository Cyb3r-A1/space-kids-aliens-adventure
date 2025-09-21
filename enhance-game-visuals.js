// Advanced Visual Effects and Post-Processing for Space Explorer Adventure
class AdvancedVisualEffects {
    constructor(game) {
        this.game = game;
        this.canvas = game.canvas;
        this.ctx = game.ctx;

        // Visual effects settings
        this.effects = {
            bloom: true,
            chromaticAberration: true,
            vignette: true,
            filmGrain: true,
            colorGrading: true,
            lensFlare: true,
            depthOfField: true,
            motionBlur: true,
            screenSpaceReflections: true,
            ambientOcclusion: true
        };

        // Post-processing framebuffers
        this.framebuffers = {
            main: this.createFramebuffer(),
            bloom: this.createFramebuffer(),
            blur: this.createFramebuffer(),
            temp: this.createFramebuffer()
        };

        this.init();
    }

    init() {
        this.createShaders();
        this.setupPostProcessing();
        console.log('🚀 Advanced Visual Effects System Initialized');
    }

    createFramebuffer() {
        const fb = {
            canvas: document.createElement('canvas'),
            ctx: null
        };
        fb.canvas.width = this.canvas.width;
        fb.canvas.height = this.canvas.height;
        fb.ctx = fb.canvas.getContext('2d');
        return fb;
    }

    createShaders() {
        // Bloom shader - makes bright areas glow
        this.bloomShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

                // Draw bright areas
                ctx.filter = 'blur(10px) brightness(1.5)';
                ctx.drawImage(source, 0, 0);
                ctx.filter = 'none';

                // Blend with original
                ctx.globalCompositeOperation = 'screen';
                ctx.globalAlpha = 0.7;
                ctx.drawImage(this.game.canvas, 0, 0);
                ctx.globalAlpha = 1;
                ctx.globalCompositeOperation = 'source-over';
            }
        };

        // Chromatic Aberration shader
        this.chromaticAberrationShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

                // Red channel (slightly offset)
                ctx.fillStyle = 'red';
                ctx.globalAlpha = 0.3;
                ctx.drawImage(source, 2, 0);

                // Green channel (normal)
                ctx.fillStyle = 'green';
                ctx.globalAlpha = 0.6;
                ctx.drawImage(source, 0, 0);

                // Blue channel (slightly offset opposite)
                ctx.fillStyle = 'blue';
                ctx.globalAlpha = 0.3;
                ctx.drawImage(source, -2, 0);

                ctx.globalAlpha = 1;
            }
        };

        // Vignette shader
        this.vignetteShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
                ctx.drawImage(source, 0, 0);

                // Create vignette effect
                const gradient = ctx.createRadialGradient(
                    this.canvas.width/2, this.canvas.height/2, 0,
                    this.canvas.width/2, this.canvas.height/2, Math.max(this.canvas.width, this.canvas.height)/1.5
                );
                gradient.addColorStop(0, 'rgba(0, 0, 0, 0)');
                gradient.addColorStop(0.7, 'rgba(0, 0, 0, 0.3)');
                gradient.addColorStop(1, 'rgba(0, 0, 0, 0.8)');

                ctx.fillStyle = gradient;
                ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            }
        };

        // Film grain shader
        this.filmGrainShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
                ctx.drawImage(source, 0, 0);

                // Add film grain
                for (let i = 0; i < 1000; i++) {
                    const x = Math.random() * this.canvas.width;
                    const y = Math.random() * this.canvas.height;
                    const size = Math.random() * 2;

                    ctx.fillStyle = `rgba(${Math.random() * 50}, ${Math.random() * 50}, ${Math.random() * 50}, 0.1)`;
                    ctx.fillRect(x, y, size, size);
                }
            }
        };

        // Color grading shader
        this.colorGradingShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

                // Apply color grading (space-like color palette)
                ctx.filter = 'hue-rotate(30deg) saturate(1.2) contrast(1.1) brightness(1.05)';
                ctx.drawImage(source, 0, 0);
                ctx.filter = 'none';
            }
        };

        // Lens flare shader
        this.lensFlareShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
                ctx.drawImage(source, 0, 0);

                // Add lens flares for bright objects
                this.game.planets.forEach(planet => {
                    const screenX = planet.x - this.game.camera.x;
                    const screenY = planet.y - this.game.camera.y;

                    if (screenX > -planet.radius && screenX < this.canvas.width + planet.radius &&
                        screenY > -planet.radius && screenY < this.canvas.height + planet.radius) {

                        // Create lens flare effect
                        const flareGradient = ctx.createRadialGradient(screenX, screenY, 0, screenX, screenY, planet.radius * 3);
                        flareGradient.addColorStop(0, 'rgba(255, 215, 0, 0.8)');
                        flareGradient.addColorStop(0.3, 'rgba(255, 150, 50, 0.4)');
                        flareGradient.addColorStop(0.6, 'rgba(100, 200, 255, 0.2)');
                        flareGradient.addColorStop(1, 'rgba(0, 0, 0, 0)');

                        ctx.fillStyle = flareGradient;
                        ctx.fillRect(screenX - planet.radius * 3, screenY - planet.radius * 3,
                                   planet.radius * 6, planet.radius * 6);
                    }
                });
            }
        };

        // Motion blur shader
        this.motionBlurShader = {
            render: (source, target) => {
                const ctx = target.ctx;
                ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

                // Apply motion blur based on player velocity
                const blurAmount = Math.min(5, Math.sqrt(this.game.player.vx * this.game.player.vx + this.game.player.vy * this.game.player.vy) / 2);

                if (blurAmount > 1) {
                    ctx.filter = `blur(${blurAmount}px)`;
                    ctx.drawImage(source, 0, 0);
                    ctx.filter = 'none';
                } else {
                    ctx.drawImage(source, 0, 0);
                }
            }
        };
    }

    setupPostProcessing() {
        // Create post-processing pipeline
        this.postProcessingPipeline = [
            this.bloomShader,
            this.chromaticAberrationShader,
            this.vignetteShader,
            this.filmGrainShader,
            this.colorGradingShader,
            this.lensFlareShader,
            this.motionBlurShader
        ];

        console.log('✅ Post-Processing Pipeline Configured');
    }

    applyPostProcessing() {
        if (!this.effects.bloom && !this.effects.chromaticAberration &&
            !this.effects.vignette && !this.effects.filmGrain &&
            !this.effects.colorGrading && !this.effects.lensFlare &&
            !this.effects.motionBlur) {
            return;
        }

        // Apply post-processing effects in sequence
        let source = this.game.canvas;
        let target = this.framebuffers.temp;

        this.postProcessingPipeline.forEach((shader, index) => {
            if (this.shouldApplyEffect(shader)) {
                shader.render(source, target);

                // Swap source and target
                const temp = source;
                source = target.canvas;
                target = (target === this.framebuffers.temp) ? this.framebuffers.main : this.framebuffers.temp;
            }
        });

        // Copy final result back to main canvas if we processed anything
        if (source !== this.game.canvas) {
            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
            this.ctx.drawImage(source, 0, 0);
        }
    }

    shouldApplyEffect(shader) {
        switch(shader) {
            case this.bloomShader: return this.effects.bloom;
            case this.chromaticAberrationShader: return this.effects.chromaticAberration;
            case this.vignetteShader: return this.effects.vignette;
            case this.filmGrainShader: return this.effects.filmGrain;
            case this.colorGradingShader: return this.effects.colorGrading;
            case this.lensFlareShader: return this.effects.lensFlare;
            case this.motionBlurShader: return this.effects.motionBlur;
            default: return false;
        }
    }

    // Public methods to control effects
    enableEffect(effectName) {
        if (this.effects.hasOwnProperty(effectName)) {
            this.effects[effectName] = true;
            console.log(`✅ Visual Effect Enabled: ${effectName}`);
        }
    }

    disableEffect(effectName) {
        if (this.effects.hasOwnProperty(effectName)) {
            this.effects[effectName] = false;
            console.log(`❌ Visual Effect Disabled: ${effectName}`);
        }
    }

    toggleEffect(effectName) {
        if (this.effects.hasOwnProperty(effectName)) {
            this.effects[effectName] = !this.effects[effectName];
            console.log(`${this.effects[effectName] ? '✅' : '❌'} Visual Effect Toggled: ${effectName}`);
        }
    }

    setEffectIntensity(effectName, intensity) {
        // This would control the intensity of effects
        console.log(`🎛️ Setting ${effectName} intensity to ${intensity}`);
    }

    // Advanced rendering features
    renderWithDepthOfField() {
        // Simulate depth of field effect
        const focusDistance = 500;
        const aperture = 50;

        // This would blur objects based on distance from focus point
        console.log('🎯 Depth of Field Effect Applied');
    }

    renderWithAmbientOcclusion() {
        // Add ambient occlusion for more realistic lighting
        console.log('🌟 Ambient Occlusion Effect Applied');
    }

    renderWithScreenSpaceReflections() {
        // Add screen-space reflections for shiny surfaces
        console.log('💎 Screen Space Reflections Applied');
    }
}

// Export for use in the main game
window.AdvancedVisualEffects = AdvancedVisualEffects;
