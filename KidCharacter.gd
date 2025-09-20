extends CharacterBody3D
class_name KidCharacter

# Kid character stats and abilities
@export var kid_name: String = "Adventure Kid"
@export var level: int = 1
@export var experience: int = 0
@export var max_health: int = 100
@export var current_health: int = 100
@export var energy: int = 100
@export var max_energy: int = 100
@export var building_skill: int = 1
@export var animal_care_skill: int = 1
@export var transformation_skill: int = 1

# Movement and interaction
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var interaction_range: float = 3.0

# Inventory system
var inventory: Dictionary = {}
var max_inventory_slots: int = 20

# Building materials
var building_materials: Dictionary = {
	"wood": 0,
	"stone": 0,
	"metal": 0,
	"crystal": 0,
	"magic_dust": 0
}

# Animal companions
var animal_companions: Array[AnimalCompanion] = []
var max_companions: int = 3

# Building and crafting
var known_recipes: Array[String] = ["basic_house", "animal_pen", "upgrade_station"]
var current_building: Building = null

# Signals
signal health_changed(new_health: int)
signal energy_changed(new_energy: int)
signal level_up(new_level: int)
signal inventory_changed()
signal companion_added(companion: AnimalCompanion)
signal building_started(building: Building)

func _ready():
	# Initialize kid character
	current_health = max_health
	energy = max_energy
	
	# Add some starting materials
	building_materials["wood"] = 10
	building_materials["stone"] = 5
	
	print("🌟 Kid character '", kid_name, "' is ready for adventure!")

func _physics_process(delta):
	handle_movement()
	handle_interaction()
	handle_building()

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
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * get_physics_process_delta_time()
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# Apply movement
	if input_dir != Vector2.ZERO:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

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
	# Show building menu
	print("🏗️ Building menu opened!")
	# This would open a UI for selecting what to build

func cancel_building():
	if current_building:
		current_building.queue_free()
		current_building = null
		print("❌ Building cancelled")

# Experience and leveling
func add_experience(amount: int):
	experience += amount
	print("✨ Gained ", amount, " experience!")
	
	# Check for level up
	var exp_needed = level * 100
	if experience >= exp_needed:
		perform_level_up()

func perform_level_up():
	level += 1
	experience = 0
	max_health += 20
	current_health = max_health
	max_energy += 10
	energy = max_energy
	
	# Increase skills
	building_skill += 1
	animal_care_skill += 1
	transformation_skill += 1
	
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

# Animal companion management
func add_companion(companion: AnimalCompanion):
	if animal_companions.size() < max_companions:
		animal_companions.append(companion)
		companion.set_owner_kid(self)
		print("🐾 Added ", companion.animal_name, " as companion!")
		companion_added.emit(companion)
		return true
	else:
		print("❌ Cannot add more companions (max: ", max_companions, ")")
		return false

func remove_companion(companion: AnimalCompanion):
	var index = animal_companions.find(companion)
	if index != -1:
		animal_companions.remove_at(index)
		print("👋 ", companion.animal_name, " is no longer a companion")

# Health and energy management
func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		print("💀 Kid character is defeated!")
		# Handle defeat logic

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health)

func use_energy(amount: int) -> bool:
	if energy >= amount:
		energy -= amount
		energy_changed.emit(energy)
		return true
	return false

func restore_energy(amount: int):
	energy = min(max_energy, energy + amount)
	energy_changed.emit(energy)
