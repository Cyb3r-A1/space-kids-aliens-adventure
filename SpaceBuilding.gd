extends Node3D
class_name SpaceBuilding

# Space building types and their properties
enum BuildingType {
	SPACE_STATION, ALIEN_PEN, UPGRADE_LAB, TRANSFORMATION_CHAMBER, 
	STORAGE_VAULT, WORKSHOP_LAB, ENERGY_GARDEN, COSMIC_PLAYGROUND,
	TELEPORTER_HUB, SHIELD_GENERATOR
}

# Building properties
@export var building_name: String = "Space Station"
@export var building_type: BuildingType = BuildingType.SPACE_STATION
@export var level: int = 1
@export var max_level: int = 4
@export var health: int = 150
@export var max_health: int = 150

# Construction requirements
var required_materials: Dictionary = {}
var construction_time: float = 15.0
var is_constructed: bool = false
var construction_progress: float = 0.0

# Building functionality
var is_functional: bool = false
var functionality_cooldown: float = 0.0
var last_used: float = 0.0

# Owner reference
var owner_kid: SpaceKid = null

# Visual effects
var glow_intensity: float = 1.0
var particle_effects: bool = false

# Signals
signal construction_started()
signal construction_completed()
signal building_upgraded(new_level: int)
signal building_destroyed()
signal functionality_used()

func _ready():
	setup_building_type()
	print("🚀 Space building '", building_name, "' initialized!")

func setup_building_type():
	match building_type:
		BuildingType.SPACE_STATION:
			building_name = "Cosmic Space Station"
			required_materials = {"space_metal": 25, "energy_crystal": 15}
			construction_time = 20.0
			max_level = 4
			particle_effects = true
		BuildingType.ALIEN_PEN:
			building_name = "Alien Containment Pen"
			required_materials = {"space_metal": 20, "alien_tech": 10}
			construction_time = 15.0
			max_level = 3
		BuildingType.UPGRADE_LAB:
			building_name = "Quantum Upgrade Lab"
			required_materials = {"space_metal": 15, "energy_crystal": 20, "quantum_dust": 8}
			construction_time = 25.0
			max_level = 3
			particle_effects = true
		BuildingType.TRANSFORMATION_CHAMBER:
			building_name = "Transformation Chamber"
			required_materials = {"space_metal": 30, "energy_crystal": 25, "dark_matter": 10}
			construction_time = 30.0
			max_level = 2
			particle_effects = true
		BuildingType.STORAGE_VAULT:
			building_name = "Quantum Storage Vault"
			required_materials = {"space_metal": 12, "energy_crystal": 8}
			construction_time = 8.0
			max_level = 4
		BuildingType.WORKSHOP_LAB:
			building_name = "Cosmic Workshop Lab"
			required_materials = {"space_metal": 30, "alien_tech": 15}
			construction_time = 22.0
			max_level = 3
		BuildingType.ENERGY_GARDEN:
			building_name = "Energy Crystal Garden"
			required_materials = {"space_metal": 8, "energy_crystal": 12}
			construction_time = 12.0
			max_level = 3
			particle_effects = true
		BuildingType.COSMIC_PLAYGROUND:
			building_name = "Cosmic Playground"
			required_materials = {"space_metal": 35, "energy_crystal": 10}
			construction_time = 18.0
			max_level = 2
		BuildingType.TELEPORTER_HUB:
			building_name = "Teleporter Hub"
			required_materials = {"space_metal": 40, "quantum_dust": 20, "plasma_core": 5}
			construction_time = 35.0
			max_level = 2
			particle_effects = true
		BuildingType.SHIELD_GENERATOR:
			building_name = "Shield Generator"
			required_materials = {"space_metal": 25, "energy_crystal": 30, "dark_matter": 8}
			construction_time = 28.0
			max_level = 3
			particle_effects = true

func _process(delta):
	if not is_constructed:
		update_construction(delta)
	
	if is_functional:
		update_functionality(delta)
		update_visual_effects(delta)

func update_construction(delta):
	construction_progress += delta
	var progress_percent = (construction_progress / construction_time) * 100
	
	# Visual feedback for construction progress
	if has_node("Mesh"):
		var mesh = get_node("Mesh")
		var alpha = 0.3 + (progress_percent / 100) * 0.7
		mesh.modulate = Color(1, 1, 1, alpha)
	
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

func update_visual_effects(delta):
	if particle_effects and is_constructed:
		# Add pulsing glow effect
		var time = Time.get_time_dict_from_system()["unix"]
		glow_intensity = 0.8 + 0.2 * sin(time * 3)
		if has_node("Mesh"):
			get_node("Mesh").modulate = Color(glow_intensity, glow_intensity, glow_intensity, 1)

func interact(kid: SpaceKid):
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
		BuildingType.SPACE_STATION:
			use_space_station_functionality()
		BuildingType.ALIEN_PEN:
			use_alien_pen_functionality()
		BuildingType.UPGRADE_LAB:
			use_upgrade_lab_functionality()
		BuildingType.TRANSFORMATION_CHAMBER:
			use_transformation_chamber_functionality()
		BuildingType.STORAGE_VAULT:
			use_storage_vault_functionality()
		BuildingType.WORKSHOP_LAB:
			use_workshop_lab_functionality()
		BuildingType.ENERGY_GARDEN:
			use_energy_garden_functionality()
		BuildingType.COSMIC_PLAYGROUND:
			use_cosmic_playground_functionality()
		BuildingType.TELEPORTER_HUB:
			use_teleporter_hub_functionality()
		BuildingType.SHIELD_GENERATOR:
			use_shield_generator_functionality()
	
	functionality_used.emit()
	last_used = Time.get_time_dict_from_system()["unix"]

func use_space_station_functionality():
	print("🚀 Using space station functionality!")
	if owner_kid:
		# Restore health and energy
		owner_kid.heal(40)
		owner_kid.restore_energy(60)
		functionality_cooldown = 45.0  # 45 seconds cooldown

func use_alien_pen_functionality():
	print("👽 Using alien pen functionality!")
	if owner_kid:
		# Heal all alien companions
		for companion in owner_kid.alien_companions:
			companion.heal(companion.max_health)
			companion.happiness = min(100, companion.happiness + 25)
			companion.happiness_changed.emit(companion.happiness)
		functionality_cooldown = 90.0  # 90 seconds cooldown

func use_upgrade_lab_functionality():
	print("⚡ Using upgrade lab functionality!")
	if owner_kid:
		# Show upgrade menu
		show_upgrade_menu()
		functionality_cooldown = 20.0  # 20 seconds cooldown

func use_transformation_chamber_functionality():
	print("🔄 Using transformation chamber functionality!")
	if owner_kid:
		# Show transformation menu
		show_transformation_menu()
		functionality_cooldown = 180.0  # 3 minutes cooldown

func use_storage_vault_functionality():
	print("📦 Using storage vault functionality!")
	if owner_kid:
		# Show storage interface
		show_storage_interface()
		functionality_cooldown = 5.0  # 5 seconds cooldown

func use_workshop_lab_functionality():
	print("🔨 Using workshop lab functionality!")
	if owner_kid:
		# Show crafting menu
		show_crafting_menu()
		functionality_cooldown = 45.0  # 45 seconds cooldown

func use_energy_garden_functionality():
	print("🌱 Using energy garden functionality!")
	if owner_kid:
		# Generate food and materials
		owner_kid.add_item("alien_food", 4)
		owner_kid.add_material("energy_crystal", 3)
		owner_kid.add_material("quantum_dust", 2)
		functionality_cooldown = 120.0  # 2 minutes cooldown

func use_cosmic_playground_functionality():
	print("🎮 Using cosmic playground functionality!")
	if owner_kid:
		# Increase happiness of all companions
		for companion in owner_kid.alien_companions:
			companion.happiness = min(100, companion.happiness + 35)
			companion.happiness_changed.emit(companion.happiness)
		functionality_cooldown = 180.0  # 3 minutes cooldown

func use_teleporter_hub_functionality():
	print("🌀 Using teleporter hub functionality!")
	if owner_kid:
		# Teleport to random location
		var random_pos = Vector3(randf_range(-30, 30), 1, randf_range(-30, 30))
		owner_kid.global_position = random_pos
		print("🌀 Teleported to ", random_pos)
		functionality_cooldown = 60.0  # 1 minute cooldown

func use_shield_generator_functionality():
	print("🛡️ Using shield generator functionality!")
	if owner_kid:
		# Activate temporary shield
		owner_kid.has_force_field = true
		print("🛡️ Force field activated!")
		await get_tree().create_timer(30.0).timeout
		owner_kid.has_force_field = false
		print("🛡️ Force field deactivated")
		functionality_cooldown = 120.0  # 2 minutes cooldown

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
	max_health += 75
	health = max_health
	
	print("⬆️ ", building_name, " upgraded to level ", level, "!")
	building_upgraded.emit(level)
	return true

# UI Functions (these would be implemented with actual UI)
func show_upgrade_menu():
	print("📋 Upgrade menu opened!")
	# This would open a UI for upgrading the kid and aliens

func show_transformation_menu():
	print("🔄 Transformation menu opened!")
	# This would open a UI for transforming aliens

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
