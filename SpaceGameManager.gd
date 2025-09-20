extends Node
class_name SpaceGameManager

# Game state management
var game_state: GameState = GameState.MAIN_MENU
var space_kid: SpaceKid = null
var game_ui: SpaceGameUI = null
var exploration_ui: SpaceExplorationUI = null
var space_travel_system: SpaceTravelSystem = null
var current_scene: Node3D = null

# Galaxy and planet systems
var galaxies: Array[Galaxy] = []
var current_galaxy: Galaxy = null
var current_planet_system: PlanetSystem = null
var current_planet: Planet = null

# Alien spawning and management
var alien_spawn_timer: Timer = null
var max_wild_aliens: int = 15
var wild_aliens: Array[AlienCompanion] = []
var spawn_points: Array[Vector3] = []

# Spaceship system
var spaceships: Array[Spaceship] = []
var current_spaceship: Spaceship = null

# Galaxy progression
var game_time: float = 0.0
var day_length: float = 240.0  # 4 minutes per cosmic day
var current_day: int = 1
var current_galaxy_name: String = "Andromeda"
var current_sector: String = "Alpha"

# Galaxy resources and buildings
var galaxy_resources: Dictionary = {
	"Dark Matter": 0,
	"Cosmic Dust": 0,
	"Stellar Energy": 0,
	"Quantum Crystals": 0
}
var active_buildings: Array[SpaceBuilding] = []

# Visual effects
var star_field: Node3D = null
var nebula_effects: Array[Node3D] = []
var cosmic_particles: CPUParticles3D = null

# Signals
signal game_started()
signal day_changed(new_day: int)
signal galaxy_changed(new_galaxy: String)
signal alien_spawned(alien: AlienCompanion)
signal building_constructed(building: SpaceBuilding)
signal spaceship_spawned(ship: Spaceship)

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

func _ready():
	# Wait a frame to ensure scene is fully loaded
	await get_tree().process_frame
	setup_space_game()
	print("🌌 Space Game Manager initialized!")

func setup_space_game():
	# Generate galaxies
	generate_galaxies()
	
	# Setup spawn points in space
	spawn_points = [
		Vector3(0, 1, 0),
		Vector3(15, 1, 8),
		Vector3(-8, 1, 12),
		Vector3(20, 1, -5),
		Vector3(-15, 1, -8),
		Vector3(25, 1, 15),
		Vector3(-20, 1, 20),
		Vector3(30, 1, -10)
	]
	
	# Setup alien spawn timer
	alien_spawn_timer = Timer.new()
	alien_spawn_timer.wait_time = 25.0  # Spawn alien every 25 seconds
	alien_spawn_timer.timeout.connect(_on_alien_spawn_timer)
	add_child(alien_spawn_timer)
	alien_spawn_timer.start()
	
	# Create cosmic visual effects
	create_cosmic_effects()
	
	# Start game
	start_game()

func create_cosmic_effects():
	# Create star field background
	star_field = Node3D.new()
	star_field.name = "StarField"
	get_tree().current_scene.add_child(star_field)
	
	# Create multiple star layers
	for i in range(3):
		var star_layer = create_star_layer(i)
		star_field.add_child(star_layer)
	
	# Create nebula effects
	create_nebula_effects()
	
	# Create cosmic particle system
	create_cosmic_particles()

func create_star_layer(layer: int):
	var star_layer = Node3D.new()
	star_layer.name = "StarLayer" + str(layer)
	
	# Create stars
	for i in range(50):
		var star = create_star()
		var distance = 100 + layer * 50
		var angle = randf() * 2 * PI
		var height = randf_range(-20, 20)
		
		star.position = Vector3(
			cos(angle) * distance,
			height,
			sin(angle) * distance
		)
		star_layer.add_child(star)
	
	return star_layer

func create_star():
	var star = MeshInstance3D.new()
	star.mesh = SphereMesh.new()
	star.scale = Vector3(0.1, 0.1, 0.1)
	
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy = randf_range(0.5, 2.0)
	star.material_override = material
	
	return star

func create_nebula_effects():
	var nebula_colors = [
		Color(1.0, 0.3, 0.8),  # Pink nebula
		Color(0.3, 0.8, 1.0),  # Blue nebula
		Color(0.8, 1.0, 0.3),  # Green nebula
		Color(1.0, 0.8, 0.3)   # Orange nebula
	]
	
	for i in range(4):
		var nebula = create_nebula(nebula_colors[i])
		var angle = i * PI / 2
		var distance = 80
		
		nebula.position = Vector3(
			cos(angle) * distance,
			randf_range(-10, 10),
			sin(angle) * distance
		)
		
		get_tree().current_scene.add_child(nebula)
		nebula_effects.append(nebula)

func create_nebula(color: Color):
	var nebula = MeshInstance3D.new()
	nebula.mesh = BoxMesh.new()
	nebula.scale = Vector3(20, 15, 20)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.3
	material.emission_enabled = true
	material.emission = color
	material.emission_energy = 0.5
	nebula.material_override = material
	
	return nebula

func create_cosmic_particles():
	cosmic_particles = CPUParticles3D.new()
	cosmic_particles.name = "CosmicParticles"
	cosmic_particles.position = Vector3(0, 10, 0)
	cosmic_particles.emitting = true
	cosmic_particles.amount = 100
	cosmic_particles.lifetime = 10.0
	cosmic_particles.direction = Vector3(0, -1, 0)
	cosmic_particles.spread = 45.0
	cosmic_particles.initial_velocity_min = 1.0
	cosmic_particles.initial_velocity_max = 3.0
	
	get_tree().current_scene.add_child(cosmic_particles)

func generate_galaxies():
	var galaxy_names = ["Andromeda", "Milky Way", "Triangulum", "Sombrero", "Whirlpool", "Pinwheel", "Cartwheel", "Antennae"]
	var galaxy_types = Galaxy.GalaxyType.values()
	
	for i in range(galaxy_names.size()):
		var galaxy = Galaxy.new()
		galaxy.galaxy_name = galaxy_names[i]
		galaxy.galaxy_type = galaxy_types[i % galaxy_types.size()]
		galaxy.size = randf_range(80, 120)
		
		# Position galaxies in space
		var angle = (i * 2 * PI) / galaxy_names.size()
		var distance = 200 + i * 50
		galaxy.position = Vector3(
			cos(angle) * distance,
			randf_range(-20, 20),
			sin(angle) * distance
		)
		
		galaxies.append(galaxy)
		# Add to scene safely
		if get_tree().current_scene:
			get_tree().current_scene.add_child(galaxy)
		else:
			print("❌ No current scene found for galaxy: ", galaxy.galaxy_name)
	
	# Set first galaxy as current
	if galaxies.size() > 0:
		current_galaxy = galaxies[0]
		print("✅ Generated ", galaxies.size(), " galaxies")

func start_game():
	game_state = GameState.PLAYING
	create_space_kid()
	setup_ui()
	setup_travel_system()
	spawn_initial_aliens()
	spawn_spaceships()
	game_started.emit()
	print("🌟 Cosmic adventure game started!")

func create_space_kid():
	# Find the existing SpaceKid instance in the scene
	space_kid = get_tree().current_scene.get_node("SpaceKidInstance")
	if not space_kid:
		print("❌ SpaceKid instance not found!")
		return
	
	print("👦 Space kid character found and ready!")

func setup_ui():
	# Find the existing GameUI instance in the scene
	game_ui = get_tree().current_scene.get_node("GameUI")
	if not game_ui:
		print("❌ GameUI instance not found!")
		return
	
	game_ui.set_space_kid(space_kid)
	
	# Create exploration UI
	var exploration_scene = preload("res://SpaceExplorationUI.tscn")
	exploration_ui = exploration_scene.instantiate()
	
	# Add to scene
	get_tree().current_scene.add_child(exploration_ui)
	exploration_ui.set_space_kid(space_kid)
	exploration_ui.set_space_travel_system(space_travel_system)
	
	print("🎮 Space Game UI setup complete!")

func setup_travel_system():
	# Create space travel system
	space_travel_system = SpaceTravelSystem.new()
	space_travel_system.name = "SpaceTravelSystem"
	
	# Add to scene
	get_tree().current_scene.add_child(space_travel_system)
	space_travel_system.set_space_kid(space_kid)
	
	# Set available galaxies
	space_travel_system.available_galaxies = galaxies.duplicate()
	
	print("🚀 Space Travel System setup complete!")

func spawn_initial_aliens():
	# Spawn some initial wild aliens
	for i in range(5):
		spawn_wild_alien()

func spawn_wild_alien():
	if wild_aliens.size() >= max_wild_aliens:
		return
	
	var alien_scene = preload("res://AlienCompanion.tscn")
	var alien = alien_scene.instantiate()
	
	# Randomize alien type
	var alien_types = AlienCompanion.AlienType.values()
	alien.alien_type = alien_types[randi() % alien_types.size()]
	alien.alien_name = generate_alien_name()
	
	# Position at random spawn point
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	alien.position = spawn_point
	
	# Add to scene
	get_tree().current_scene.add_child(alien)
	wild_aliens.append(alien)
	
	print("👽 Wild ", alien.get_alien_type_name(), " spawned!")
	alien_spawned.emit(alien)

func generate_alien_name() -> String:
	var names = [
		"Zorg", "Xyph", "Nebula", "Quantum", "Void",
		"Stellar", "Cosmic", "Plasma", "Dark", "Crystal",
		"Galaxy", "Star", "Moon", "Solar", "Nova"
	]
	return names[randi() % names.size()]

func spawn_spaceships():
	# Spawn some spaceships in the distance
	for i in range(3):
		spawn_spaceship()

func spawn_spaceship():
	var spaceship = Spaceship.new()
	
	# Position spaceship in the distance
	var angle = randf() * 2 * PI
	var distance = randf_range(50, 100)
	var height = randf_range(5, 15)
	
	spaceship.position = Vector3(
		cos(angle) * distance,
		height,
		sin(angle) * distance
	)
	
	# Add to scene
	get_tree().current_scene.add_child(spaceship)
	spaceships.append(spaceship)
	
	print("🚀 Spaceship spawned!")
	spaceship_spawned.emit(spaceship)

func _on_alien_spawn_timer():
	spawn_wild_alien()

func _process(delta):
	if game_state == GameState.PLAYING:
		update_game_time(delta)
		update_galaxy_resources(delta)
		check_cosmic_cycle()
		update_spaceships(delta)

func update_game_time(delta):
	game_time += delta

func update_galaxy_resources(delta):
	# Regenerate some resources over time
	if randf() < 0.015:  # 1.5% chance per frame
		var resource_types = galaxy_resources.keys()
		var resource_type = resource_types[randi() % resource_types.size()]
		galaxy_resources[resource_type] += 1

func check_cosmic_cycle():
	var new_day = int(game_time / day_length) + 1
	if new_day != current_day:
		current_day = new_day
		day_changed.emit(current_day)
		
		# Change galaxy every 10 days
		var galaxy_index = (current_day - 1) / 10
		var galaxies = ["Andromeda", "Milky Way", "Triangulum", "Sombrero", "Whirlpool"]
		var new_galaxy = galaxies[galaxy_index % galaxies.size()]
		
		if new_galaxy != current_galaxy_name:
			current_galaxy_name = new_galaxy
			galaxy_changed.emit(current_galaxy_name)
			print("🌌 Galaxy changed to ", current_galaxy_name, "!")

func update_spaceships(delta):
	for spaceship in spaceships:
		if spaceship:
			spaceship.update_movement(delta)

# Building management
func construct_building(building_type: SpaceBuilding.BuildingType, position: Vector3) -> bool:
	if not space_kid:
		return false
	
	var building_scene = preload("res://SpaceBuilding.tscn")
	var building = building_scene.instantiate()
	building.building_type = building_type
	building.position = position
	
	# Check if kid has required materials
	if not can_afford_building(building):
		print("❌ Not enough materials to build!")
		return false
	
	# Consume materials
	consume_building_materials(building)
	
	# Add to scene
	get_tree().current_scene.add_child(building)
	active_buildings.append(building)
	
	print("🏗️ Space building construction started!")
	building_constructed.emit(building)
	return true

func can_afford_building(building: SpaceBuilding) -> bool:
	for material in building.required_materials:
		var required_amount = building.required_materials[material]
		if not space_kid.building_materials.has(material) or space_kid.building_materials[material] < required_amount:
			return false
	return true

func consume_building_materials(building: SpaceBuilding):
	for material in building.required_materials:
		var required_amount = building.required_materials[material]
		space_kid.building_materials[material] -= required_amount

# Alien interaction
func try_catch_alien(alien: AlienCompanion) -> bool:
	if not space_kid:
		return false
	
	# Check if kid can catch this alien
	var catch_chance = calculate_catch_chance(alien)
	if randf() < catch_chance:
		# Successfully caught alien
		if space_kid.add_companion(alien):
			# Remove from wild aliens list
			var index = wild_aliens.find(alien)
			if index != -1:
				wild_aliens.remove_at(index)
			
			print("🎉 Successfully caught ", alien.alien_name, "!")
			return true
	
	print("😔 Failed to catch ", alien.alien_name, "...")
	return false

func calculate_catch_chance(alien: AlienCompanion) -> float:
	var base_chance = 0.25  # 25% base chance
	
	# Modify based on alien happiness (if it's been fed)
	if alien.happiness > 50:
		base_chance += 0.25
	
	# Modify based on kid's alien care skill
	base_chance += space_kid.alien_care_skill * 0.06
	
	# Modify based on alien loyalty
	base_chance += alien.loyalty * 0.001
	
	return min(0.95, base_chance)  # Max 95% chance

# Resource management
func add_galaxy_resource(resource_type: String, amount: int):
	if galaxy_resources.has(resource_type):
		galaxy_resources[resource_type] += amount
	else:
		galaxy_resources[resource_type] = amount

func get_galaxy_resource(resource_type: String) -> int:
	return galaxy_resources.get(resource_type, 0)

# Game progression
func complete_objective(objective_type: String):
	match objective_type:
		"build_first_station":
			space_kid.add_experience(150)
			print("🏆 Objective completed: Build your first space station!")
		"catch_first_alien":
			space_kid.add_experience(75)
			print("🏆 Objective completed: Catch your first alien!")
		"transform_alien":
			space_kid.add_experience(300)
			print("🏆 Objective completed: Transform an alien!")
		"build_teleporter":
			space_kid.add_experience(500)
			print("🏆 Objective completed: Build a teleporter hub!")

# Utility functions
func get_game_time_string() -> String:
	var hours = int(game_time / 60) % 24
	var minutes = int(game_time) % 60
	return str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2)

func get_current_galaxy() -> String:
	return current_galaxy_name

func get_current_day() -> int:
	return current_day

func pause_game():
	game_state = GameState.PAUSED
	get_tree().paused = true
	print("⏸️ Game paused")

func resume_game():
	game_state = GameState.PLAYING
	get_tree().paused = false
	print("▶️ Game resumed")

func save_game():
	# Implement save game functionality
	print("💾 Game saved!")

func load_game():
	# Implement load game functionality
	print("📁 Game loaded!")
