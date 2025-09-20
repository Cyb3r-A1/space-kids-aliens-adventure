extends Node3D
class_name Building

# Building types and their properties
enum BuildingType {
	HOUSE, ANIMAL_PEN, UPGRADE_STATION, TRANSFORMATION_SHRINE, 
	STORAGE_CHEST, WORKSHOP, GARDEN, PLAYGROUND
}

# Building properties
@export var building_name: String = "Basic House"
@export var building_type: BuildingType = BuildingType.HOUSE
@export var level: int = 1
@export var max_level: int = 3
@export var health: int = 100
@export var max_health: int = 100

# Construction requirements
var required_materials: Dictionary = {}
var construction_time: float = 10.0
var is_constructed: bool = false
var construction_progress: float = 0.0

# Building functionality
var is_functional: bool = false
var functionality_cooldown: float = 0.0
var last_used: float = 0.0

# Owner reference
var owner_kid: KidCharacter = null

# Signals
signal construction_started()
signal construction_completed()
signal building_upgraded(new_level: int)
signal building_destroyed()
signal functionality_used()

func _ready():
	setup_building_type()
	print("🏗️ Building '", building_name, "' initialized!")

func setup_building_type():
	match building_type:
		BuildingType.HOUSE:
			building_name = "Cozy House"
			required_materials = {"wood": 20, "stone": 10}
			construction_time = 15.0
			max_level = 3
		BuildingType.ANIMAL_PEN:
			building_name = "Animal Pen"
			required_materials = {"wood": 15, "stone": 5}
			construction_time = 10.0
			max_level = 2
		BuildingType.UPGRADE_STATION:
			building_name = "Upgrade Station"
			required_materials = {"wood": 10, "metal": 15, "crystal": 5}
			construction_time = 20.0
			max_level = 2
		BuildingType.TRANSFORMATION_SHRINE:
			building_name = "Transformation Shrine"
			required_materials = {"stone": 20, "crystal": 10, "magic_dust": 5}
			construction_time = 25.0
			max_level = 1
		BuildingType.STORAGE_CHEST:
			building_name = "Storage Chest"
			required_materials = {"wood": 8}
			construction_time = 5.0
			max_level = 3
		BuildingType.WORKSHOP:
			building_name = "Workshop"
			required_materials = {"wood": 25, "metal": 10}
			construction_time = 20.0
			max_level = 2
		BuildingType.GARDEN:
			building_name = "Garden"
			required_materials = {"wood": 5, "stone": 5}
			construction_time = 8.0
			max_level = 2
		BuildingType.PLAYGROUND:
			building_name = "Playground"
			required_materials = {"wood": 30, "metal": 5}
			construction_time = 12.0
			max_level = 2

func _process(delta):
	if not is_constructed:
		update_construction(delta)
	
	if is_functional:
		update_functionality(delta)

func update_construction(delta):
	construction_progress += delta
	var progress_percent = (construction_progress / construction_time) * 100
	
	# Visual feedback for construction progress
	if has_node("Mesh"):
		get_node("Mesh").modulate = Color(1, 1, 1, 0.3 + (progress_percent / 100) * 0.7)
	
	if construction_progress >= construction_time:
		complete_construction()

func complete_construction():
	is_constructed = true
	is_functional = true
	if has_node("Mesh"):
		get_node("Mesh").modulate = Color(1, 1, 1, 1)
	print("✅ ", building_name, " construction completed!")
	construction_completed.emit()

func update_functionality(delta):
	if functionality_cooldown > 0:
		functionality_cooldown -= delta

func interact(kid: KidCharacter):
	if not is_constructed:
		print("🏗️ ", building_name, " is still under construction!")
		return
	
	if not is_functional:
		print("❌ ", building_name, " is not functional yet!")
		return
	
	owner_kid = kid
	use_building_functionality()

func use_building_functionality():
	if functionality_cooldown > 0:
		print("⏰ ", building_name, " is on cooldown for ", functionality_cooldown, " seconds")
		return
	
	match building_type:
		BuildingType.HOUSE:
			use_house_functionality()
		BuildingType.ANIMAL_PEN:
			use_animal_pen_functionality()
		BuildingType.UPGRADE_STATION:
			use_upgrade_station_functionality()
		BuildingType.TRANSFORMATION_SHRINE:
			use_transformation_shrine_functionality()
		BuildingType.STORAGE_CHEST:
			use_storage_chest_functionality()
		BuildingType.WORKSHOP:
			use_workshop_functionality()
		BuildingType.GARDEN:
			use_garden_functionality()
		BuildingType.PLAYGROUND:
			use_playground_functionality()
	
	functionality_used.emit()
	last_used = Time.get_time_dict_from_system()["unix"]

func use_house_functionality():
	print("🏠 Using house functionality!")
	if owner_kid:
		# Restore health and energy
		owner_kid.heal(30)
		owner_kid.restore_energy(50)
		functionality_cooldown = 60.0  # 1 minute cooldown

func use_animal_pen_functionality():
	print("🐾 Using animal pen functionality!")
	if owner_kid:
		# Heal all animal companions
		for companion in owner_kid.animal_companions:
			companion.heal(companion.max_health)
			companion.happiness = min(100, companion.happiness + 20)
			companion.happiness_changed.emit(companion.happiness)
		functionality_cooldown = 120.0  # 2 minutes cooldown

func use_upgrade_station_functionality():
	print("⚡ Using upgrade station functionality!")
	if owner_kid:
		# Show upgrade menu
		show_upgrade_menu()
		functionality_cooldown = 30.0  # 30 seconds cooldown

func use_transformation_shrine_functionality():
	print("🔄 Using transformation shrine functionality!")
	if owner_kid:
		# Show transformation menu
		show_transformation_menu()
		functionality_cooldown = 300.0  # 5 minutes cooldown

func use_storage_chest_functionality():
	print("📦 Using storage chest functionality!")
	if owner_kid:
		# Show storage interface
		show_storage_interface()
		functionality_cooldown = 10.0  # 10 seconds cooldown

func use_workshop_functionality():
	print("🔨 Using workshop functionality!")
	if owner_kid:
		# Show crafting menu
		show_crafting_menu()
		functionality_cooldown = 60.0  # 1 minute cooldown

func use_garden_functionality():
	print("🌱 Using garden functionality!")
	if owner_kid:
		# Generate food and materials
		owner_kid.add_item("pet_food", 3)
		owner_kid.add_material("wood", 2)
		functionality_cooldown = 180.0  # 3 minutes cooldown

func use_playground_functionality():
	print("🎮 Using playground functionality!")
	if owner_kid:
		# Increase happiness of all companions
		for companion in owner_kid.animal_companions:
			companion.happiness = min(100, companion.happiness + 30)
			companion.happiness_changed.emit(companion.happiness)
		functionality_cooldown = 240.0  # 4 minutes cooldown

# Upgrade system
func can_upgrade() -> bool:
	if level >= max_level:
		return false
	
	if not owner_kid:
		return false
	
	# Check if player has required materials for upgrade
	var upgrade_materials = get_upgrade_materials()
	for material in upgrade_materials:
		if not owner_kid.building_materials.has(material) or owner_kid.building_materials[material] < upgrade_materials[material]:
			return false
	
	return true

func get_upgrade_materials() -> Dictionary:
	var base_materials = required_materials.duplicate()
	var multiplier = level + 1
	
	for material in base_materials:
		base_materials[material] *= multiplier
	
	return base_materials

func upgrade():
	if not can_upgrade():
		print("❌ Cannot upgrade ", building_name, "!")
		return false
	
	# Consume materials
	var upgrade_materials = get_upgrade_materials()
	for material in upgrade_materials:
		owner_kid.building_materials[material] -= upgrade_materials[material]
	
	# Increase level
	level += 1
	max_health += 50
	health = max_health
	
	print("⬆️ ", building_name, " upgraded to level ", level, "!")
	building_upgraded.emit(level)
	return true

# UI Functions (these would be implemented with actual UI)
func show_upgrade_menu():
	print("📋 Upgrade menu opened!")
	# This would open a UI for upgrading the kid and animals

func show_transformation_menu():
	print("🔄 Transformation menu opened!")
	# This would open a UI for transforming animals

func show_storage_interface():
	print("📦 Storage interface opened!")
	# This would open a UI for managing storage

func show_crafting_menu():
	print("🔨 Crafting menu opened!")
	# This would open a UI for crafting items

# Building management
func take_damage(amount: int):
	health = max(0, health - amount)
	
	if health <= 0:
		destroy_building()

func repair(amount: int):
	health = min(max_health, health + amount)
	print("🔧 ", building_name, " repaired!")

func destroy_building():
	print("💥 ", building_name, " has been destroyed!")
	building_destroyed.emit()
	queue_free()

# Utility functions
func get_building_type_name() -> String:
	return BuildingType.keys()[building_type]

func get_construction_progress_percent() -> float:
	return (construction_progress / construction_time) * 100

func is_ready_to_use() -> bool:
	return is_constructed and is_functional and functionality_cooldown <= 0

func get_status_text() -> String:
	if not is_constructed:
		return "Under Construction (" + str(int(get_construction_progress_percent())) + "%)"
	elif functionality_cooldown > 0:
		return "On Cooldown (" + str(int(functionality_cooldown)) + "s)"
	else:
		return "Ready to Use"
