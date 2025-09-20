extends Node
class_name GameManager

# Game state management
var game_state: GameState = GameState.MAIN_MENU
var kid_character: KidCharacter = null
var game_ui: GameUI = null
var current_scene: Node3D = null

# Game world
var world_resources: Dictionary = {}
var discovered_areas: Array[String] = []
var active_buildings: Array[Building] = []
var spawn_points: Array[Vector3] = []

# Animal spawning and management
var animal_spawn_timer: Timer = null
var max_wild_animals: int = 10
var wild_animals: Array[AnimalCompanion] = []

# Game progression
var game_time: float = 0.0
var day_length: float = 300.0  # 5 minutes per day
var current_day: int = 1
var current_season: String = "Spring"

# Signals
signal game_started()
signal day_changed(new_day: int)
signal season_changed(new_season: String)
signal animal_spawned(animal: AnimalCompanion)
signal building_constructed(building: Building)

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

func _ready():
	setup_game()
	print("🎮 Game Manager initialized!")

func setup_game():
	# Initialize world resources
	world_resources = {
		"wood": 50,
		"stone": 30,
		"metal": 10,
		"crystal": 5,
		"magic_dust": 2
	}
	
	# Setup spawn points
	spawn_points = [
		Vector3(0, 1, 0),
		Vector3(10, 1, 5),
		Vector3(-5, 1, 8),
		Vector3(15, 1, -3),
		Vector3(-10, 1, -5)
	]
	
	# Setup animal spawn timer
	animal_spawn_timer = Timer.new()
	animal_spawn_timer.wait_time = 30.0  # Spawn animal every 30 seconds
	animal_spawn_timer.timeout.connect(_on_animal_spawn_timer)
	add_child(animal_spawn_timer)
	animal_spawn_timer.start()
	
	# Start game
	start_game()

func start_game():
	game_state = GameState.PLAYING
	create_kid_character()
	setup_ui()
	spawn_initial_animals()
	game_started.emit()
	print("🌟 Adventure game started!")

func create_kid_character():
	# Create kid character instance
	var kid_scene = preload("res://KidCharacter.tscn")
	kid_character = kid_scene.instantiate()
	
	# Add to scene
	get_tree().current_scene.add_child(kid_character)
	kid_character.position = Vector3(0, 1, 0)
	
	print("👦 Kid character created!")

func setup_ui():
	# Create and setup UI
	var ui_scene = preload("res://GameUI.tscn")
	game_ui = ui_scene.instantiate()
	
	# Add to scene
	get_tree().current_scene.add_child(game_ui)
	game_ui.set_kid_character(kid_character)
	
	print("🎮 Game UI setup complete!")

func spawn_initial_animals():
	# Spawn some initial wild animals
	for i in range(3):
		spawn_wild_animal()

func spawn_wild_animal():
	if wild_animals.size() >= max_wild_animals:
		return
	
	var animal_scene = preload("res://AnimalCompanion.tscn")
	var animal = animal_scene.instantiate()
	
	# Randomize animal type
	var animal_types = AnimalCompanion.AnimalType.values()
	animal.animal_type = animal_types[randi() % animal_types.size()]
	animal.animal_name = generate_animal_name()
	
	# Position at random spawn point
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	animal.position = spawn_point
	
	# Add to scene
	get_tree().current_scene.add_child(animal)
	wild_animals.append(animal)
	
	print("🐾 Wild ", animal.get_animal_type_name(), " spawned!")
	animal_spawned.emit(animal)

func generate_animal_name() -> String:
	var names = [
		"Fluffy", "Buddy", "Whiskers", "Shadow", "Sparkle",
		"Thunder", "Lightning", "Crystal", "Ruby", "Sapphire",
		"Midnight", "Sunny", "Rainbow", "Star", "Moon"
	]
	return names[randi() % names.size()]

func _on_animal_spawn_timer():
	spawn_wild_animal()

func _process(delta):
	if game_state == GameState.PLAYING:
		update_game_time(delta)
		update_world_resources(delta)
		check_day_cycle()

func update_game_time(delta):
	game_time += delta

func update_world_resources(delta):
	# Regenerate some resources over time
	if randf() < 0.01:  # 1% chance per frame
		var resource_types = world_resources.keys()
		var resource_type = resource_types[randi() % resource_types.size()]
		world_resources[resource_type] += 1

func check_day_cycle():
	var new_day = int(game_time / day_length) + 1
	if new_day != current_day:
		current_day = new_day
		day_changed.emit(current_day)
		
		# Change season every 7 days
		var season_index = (current_day - 1) / 7
		var seasons = ["Spring", "Summer", "Autumn", "Winter"]
		var new_season = seasons[season_index % seasons.size()]
		
		if new_season != current_season:
			current_season = new_season
			season_changed.emit(current_season)
			print("🍂 Season changed to ", current_season, "!")

# Building management
func construct_building(building_type: Building.BuildingType, position: Vector3) -> bool:
	if not kid_character:
		return false
	
	var building_scene = preload("res://Building.tscn")
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
	
	print("🏗️ Building construction started!")
	building_constructed.emit(building)
	return true

func can_afford_building(building: Building) -> bool:
	for material in building.required_materials:
		var required_amount = building.required_materials[material]
		if not kid_character.building_materials.has(material) or kid_character.building_materials[material] < required_amount:
			return false
	return true

func consume_building_materials(building: Building):
	for material in building.required_materials:
		var required_amount = building.required_materials[material]
		kid_character.building_materials[material] -= required_amount

# Animal interaction
func try_catch_animal(animal: AnimalCompanion) -> bool:
	if not kid_character:
		return false
	
	# Check if kid can catch this animal
	var catch_chance = calculate_catch_chance(animal)
	if randf() < catch_chance:
		# Successfully caught animal
		if kid_character.add_companion(animal):
			# Remove from wild animals list
			var index = wild_animals.find(animal)
			if index != -1:
				wild_animals.remove_at(index)
			
			print("🎉 Successfully caught ", animal.animal_name, "!")
			return true
	
	print("😔 Failed to catch ", animal.animal_name, "...")
	return false

func calculate_catch_chance(animal: AnimalCompanion) -> float:
	var base_chance = 0.3  # 30% base chance
	
	# Modify based on animal happiness (if it's been fed)
	if animal.happiness > 50:
		base_chance += 0.2
	
	# Modify based on kid's animal care skill
	base_chance += kid_character.animal_care_skill * 0.05
	
	# Modify based on animal loyalty
	base_chance += animal.loyalty * 0.001
	
	return min(0.9, base_chance)  # Max 90% chance

# Resource management
func add_world_resource(resource_type: String, amount: int):
	if world_resources.has(resource_type):
		world_resources[resource_type] += amount
	else:
		world_resources[resource_type] = amount

func get_world_resource(resource_type: String) -> int:
	return world_resources.get(resource_type, 0)

# Game progression
func complete_objective(objective_type: String):
	match objective_type:
		"build_first_house":
			kid_character.add_experience(100)
			print("🏆 Objective completed: Build your first house!")
		"catch_first_animal":
			kid_character.add_experience(50)
			print("🏆 Objective completed: Catch your first animal!")
		"transform_animal":
			kid_character.add_experience(200)
			print("🏆 Objective completed: Transform an animal!")

# Utility functions
func get_game_time_string() -> String:
	var hours = int(game_time / 60) % 24
	var minutes = int(game_time) % 60
	return str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2)

func get_current_season() -> String:
	return current_season

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
