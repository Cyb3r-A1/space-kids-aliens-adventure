extends CharacterBody3D
class_name SpaceKid

# Space Kid character stats and abilities
@export var kid_name: String = "Space Explorer"
@export var level: int = 1
@export var experience: int = 0
@export var max_health: int = 100
@export var current_health: int = 100
@export var energy: int = 100
@export var max_energy: int = 100
@export var building_skill: int = 1
@export var alien_care_skill: int = 1
@export var transformation_skill: int = 1

# Movement and interaction
@export var speed: float = 6.0
@export var jump_velocity: float = 6.0
@export var interaction_range: float = 4.0
@export var jetpack_boost: float = 8.0

# Inventory system
var inventory: Dictionary = {}
var max_inventory_slots: int = 25

# Space building materials
var building_materials: Dictionary = {
	"space_metal": 0,
	"energy_crystal": 0,
	"alien_tech": 0,
	"dark_matter": 0,
	"quantum_dust": 0,
	"plasma_core": 0
}

# Alien companions
var alien_companions: Array[AlienCompanion] = []
var max_companions: int = 5

# Building and crafting
var known_recipes: Array[String] = ["space_station", "alien_pen", "upgrade_lab", "transformation_chamber"]
var current_building: SpaceBuilding = null

# Space equipment
var has_jetpack: bool = true
var has_force_field: bool = false
var has_teleporter: bool = false

# Signals
signal health_changed(current_health: int, max_health: int)
signal energy_changed(current_energy: int, max_energy: int)
signal level_up(new_level: int)
signal inventory_changed()
signal companion_added(companion: AlienCompanion)
signal building_started(building: SpaceBuilding)

func _ready():
	# Initialize space kid character
	current_health = max_health
	energy = max_energy
	
	# Add some starting materials
	building_materials["space_metal"] = 15
	building_materials["energy_crystal"] = 8
	
	# Add some starting items
	add_item("Health Pack", 3)
	add_item("Energy Cell", 2)
	add_item("Space Metal", 10)
	add_item("Energy Crystal", 5)
	
	print("🚀 Space Explorer '", kid_name, "' is ready for cosmic adventure!")

func _physics_process(delta):
	handle_movement()
	handle_interaction()
	handle_building()
	handle_jetpack()

func handle_movement():
	# Get input direction
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	
	# Apply gravity (reduced in space)
	if not is_on_floor():
		velocity.y -= 6.0 * get_physics_process_delta_time()
	
	# Handle jump and jetpack
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	elif Input.is_action_pressed("ui_accept") and has_jetpack and energy > 0:
		velocity.y = jetpack_boost
		use_energy(1)
	
	# Apply movement
	if input_dir != Vector2.ZERO:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func handle_jetpack():
	if has_jetpack and Input.is_action_pressed("ui_accept") and not is_on_floor():
		# Add jetpack particle effects
		pass

func handle_interaction():
	if Input.is_action_just_pressed("interact"):
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			get_global_position(),
			get_global_position() + get_global_transform().basis.z * -interaction_range
		)
		var result = space_state.intersect_ray(query)
		
		if result:
			var collider = result["collider"]
			if collider.has_method("interact"):
				collider.interact(self)

func handle_building():
	if Input.is_action_just_pressed("build") and not current_building:
		start_building()
	elif Input.is_action_just_pressed("cancel") and current_building:
		cancel_building()

func start_building():
	# Show space building menu
	print("🏗️ Space building menu opened!")
	# This would open a UI for selecting what to build

func cancel_building():
	if current_building:
		current_building.queue_free()
		current_building = null
		print("❌ Building cancelled")

# Experience and leveling
func add_experience(amount: int):
	experience += amount
	print("✨ Gained ", amount, " cosmic experience!")
	
	# Check for level up
	var exp_needed = level * 100
	if experience >= exp_needed:
		perform_level_up()

func perform_level_up():
	level += 1
	experience = 0
	max_health += 25
	current_health = max_health
	max_energy += 15
	energy = max_energy
	
	# Increase skills
	building_skill += 1
	alien_care_skill += 1
	transformation_skill += 1
	
	# Unlock new equipment
	if level >= 3 and not has_force_field:
		has_force_field = true
		print("🛡️ Force field unlocked!")
	elif level >= 5 and not has_teleporter:
		has_teleporter = true
		print("🌀 Teleporter unlocked!")
	
	print("🎉 Level up! Now level ", level)
	level_up.emit(level)

# Inventory management
func add_item(item_name: String, quantity: int = 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
	
	print("📦 Added ", quantity, " ", item_name, " to inventory")
	inventory_changed.emit()

func remove_item(item_name: String, quantity: int = 1) -> bool:
	if inventory.has(item_name) and inventory[item_name] >= quantity:
		inventory[item_name] -= quantity
		if inventory[item_name] <= 0:
			inventory.erase(item_name)
		inventory_changed.emit()
		return true
	return false

func has_item(item_name: String, quantity: int = 1) -> bool:
	return inventory.has(item_name) and inventory[item_name] >= quantity

# Building materials
func add_material(material_type: String, amount: int):
	if building_materials.has(material_type):
		building_materials[material_type] += amount
		print("🔨 Gained ", amount, " ", material_type)

func can_build(recipe_name: String) -> bool:
	# Check if player knows the recipe and has materials
	return recipe_name in known_recipes

# Alien companion management
func add_companion(companion: AlienCompanion):
	if alien_companions.size() < max_companions:
		alien_companions.append(companion)
		companion.set_owner_kid(self)
		print("👽 Added ", companion.alien_name, " as companion!")
		companion_added.emit(companion)
		return true
	else:
		print("❌ Cannot add more companions (max: ", max_companions, ")")
		return false

func remove_companion(companion: AlienCompanion):
	var index = alien_companions.find(companion)
	if index != -1:
		alien_companions.remove_at(index)
		print("👋 ", companion.alien_name, " is no longer a companion")

# Health and energy management
func take_damage(amount: int):
	if has_force_field and energy >= 10:
		use_energy(10)
		print("🛡️ Force field absorbed damage!")
		return
	
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		print("💀 Space Explorer is defeated!")
		# Handle defeat logic

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func use_energy(amount: int) -> bool:
	if energy >= amount:
		energy -= amount
		energy_changed.emit(energy, max_energy)
		return true
	return false

func restore_energy(amount: int):
	energy = min(max_energy, energy + amount)
	energy_changed.emit(energy, max_energy)

func use_item(item_name: String):
	if inventory.has(item_name) and inventory[item_name] > 0:
		inventory[item_name] -= 1
		if inventory[item_name] <= 0:
			inventory.erase(item_name)
		
		print("🔧 Used ", item_name)
		inventory_changed.emit()
		
		# Add some basic item effects
		match item_name:
			"Health Pack":
				heal(25)
			"Energy Cell":
				restore_energy(30)
			"Space Metal":
				add_material("space_metal", 5)
			"Energy Crystal":
				add_material("energy_crystal", 3)
	else:
		print("❌ No ", item_name, " available!")

func select_companion(companion: AlienCompanion):
	if companion in alien_companions:
		print("👽 Selected companion: ", companion.alien_name)
		# Add companion interaction logic here
	else:
		print("❌ Companion not found!")
