extends CharacterBody3D
class_name AlienCompanion

# Alien types and their characteristics
enum AlienType {
	ZORGLON, CRYSTAL_BEAST, PLASMA_DRAGON, QUANTUM_FOX, 
	VOID_WOLF, STAR_CAT, GALAXY_BEAR, NEBULA_BIRD,
	COSMIC_UNICORN, DARK_MATTER_PHOENIX
}

# Alien stats
@export var alien_name: String = "Zorg"
@export var alien_type: AlienType = AlienType.ZORGLON
@export var level: int = 1
@export var experience: int = 0
@export var max_health: int = 60
@export var current_health: int = 60
@export var happiness: int = 100
@export var loyalty: int = 100
@export var special_ability: String = ""

# Movement and behavior
@export var move_speed: float = 5.0
@export var follow_distance: float = 4.0
@export var interaction_range: float = 3.0
@export var can_fly: bool = false
@export var can_teleport: bool = false

# Transformation system
@export var can_transform: bool = false
@export var transformation_level: int = 0
@export var max_transformation_level: int = 4
var transformation_materials: Dictionary = {}

# Owner reference
var owner_kid: SpaceKid = null
var target_position: Vector3 = Vector3.ZERO
var is_following: bool = true
var is_busy: bool = false

# Visual effects
var glow_effect: bool = false
var particle_trail: bool = false

# Signals
signal health_changed(new_health: int)
signal happiness_changed(new_happiness: int)
signal loyalty_changed(new_loyalty: int)
signal level_up(new_level: int)
signal transformed(new_type: AlienType)
signal special_ability_used(ability: String)

func _ready():
	current_health = max_health
	setup_alien_type()
	print("👽 Alien companion '", alien_name, "' is ready!")

func setup_alien_type():
	match alien_type:
		AlienType.ZORGLON:
			move_speed = 4.0
			special_ability = "energy_blast"
			can_transform = true
			glow_effect = true
		AlienType.CRYSTAL_BEAST:
			move_speed = 3.0
			special_ability = "crystal_shield"
			can_transform = true
			glow_effect = true
		AlienType.PLASMA_DRAGON:
			move_speed = 6.0
			special_ability = "plasma_breath"
			can_fly = true
			can_transform = true
			particle_trail = true
		AlienType.QUANTUM_FOX:
			move_speed = 7.0
			special_ability = "quantum_tunnel"
			can_teleport = true
			can_transform = true
		AlienType.VOID_WOLF:
			move_speed = 5.5
			special_ability = "void_hunt"
			can_transform = true
		AlienType.STAR_CAT:
			move_speed = 4.5
			special_ability = "stellar_stealth"
			can_transform = true
		AlienType.GALAXY_BEAR:
			move_speed = 2.5
			special_ability = "galactic_strength"
			can_transform = true
		AlienType.NEBULA_BIRD:
			move_speed = 8.0
			special_ability = "nebula_flight"
			can_fly = true
			can_transform = true
			particle_trail = true
		AlienType.COSMIC_UNICORN:
			move_speed = 5.0
			special_ability = "cosmic_healing"
			can_transform = false
			glow_effect = true
		AlienType.DARK_MATTER_PHOENIX:
			move_speed = 7.5
			special_ability = "dark_rebirth"
			can_fly = true
			can_transform = false
			particle_trail = true

func _physics_process(delta):
	if owner_kid and is_following:
		follow_owner(delta)
	
	handle_interaction()
	handle_special_ability()
	update_visual_effects()

func follow_owner(delta):
	if not owner_kid:
		return
	
	var distance_to_owner = global_position.distance_to(owner_kid.global_position)
	
	if distance_to_owner > follow_distance:
		# Move towards owner
		var direction = (owner_kid.global_position - global_position).normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		
		# Look at owner
		look_at(owner_kid.global_position, Vector3.UP)
	else:
		# Stay close to owner
		velocity.x = 0
		velocity.z = 0
	
	# Handle flying aliens
	if can_fly and not is_on_floor():
		velocity.y = 0  # Hover in air
	elif not can_fly:
		# Apply gravity
		if not is_on_floor():
			velocity.y -= 9.8 * delta
	
	move_and_slide()

func update_visual_effects():
	if glow_effect and has_node("Mesh"):
		var mesh = get_node("Mesh")
		var time = Time.get_time_dict_from_system()["unix"]
		var glow_intensity = 0.5 + 0.3 * sin(time * 2)
		mesh.modulate = Color(1, 1, 1, glow_intensity)

func handle_interaction():
	if Input.is_action_just_pressed("interact") and owner_kid:
		var distance_to_kid = global_position.distance_to(owner_kid.global_position)
		if distance_to_kid <= interaction_range:
			interact_with_kid()

func interact_with_kid():
	print("👽 ", alien_name, " interacts with ", owner_kid.kid_name)
	
	# Petting increases happiness
	happiness = min(100, happiness + 15)
	happiness_changed.emit(happiness)
	
	# Feeding if kid has food
	if owner_kid.has_item("alien_food"):
		owner_kid.remove_item("alien_food", 1)
		happiness = min(100, happiness + 25)
		loyalty = min(100, loyalty + 8)
		happiness_changed.emit(happiness)
		loyalty_changed.emit(loyalty)
		print("🍽️ ", alien_name, " enjoyed the cosmic food!")

func handle_special_ability():
	if Input.is_action_just_pressed("special_ability") and not is_busy:
		use_special_ability()

func use_special_ability():
	if is_busy:
		return
	
	is_busy = true
	print("✨ ", alien_name, " uses ", special_ability, "!")
	
	match special_ability:
		"energy_blast":
			# Blast energy at nearby enemies
			blast_energy()
		
		"crystal_shield":
			# Create protective shield
			create_crystal_shield()
		
		"plasma_breath":
			# Breathe plasma fire
			breath_plasma()
		
		"quantum_tunnel":
			# Create teleportation tunnel
			create_quantum_tunnel()
		
		"void_hunt":
			# Hunt for resources in void
			hunt_in_void()
		
		"stellar_stealth":
			# Make owner temporarily invisible
			if owner_kid:
				owner_kid.modulate = Color(1, 1, 1, 0.3)
				await get_tree().create_timer(6.0).timeout
				owner_kid.modulate = Color(1, 1, 1, 1)
		
		"galactic_strength":
			# Help with building
			if owner_kid and owner_kid.current_building:
				help_with_building()
		
		"nebula_flight":
			# Allow temporary flight
			velocity.y = 8.0
			await get_tree().create_timer(4.0).timeout
		
		"cosmic_healing":
			# Heal all companions
			if owner_kid:
				for companion in owner_kid.alien_companions:
					companion.heal(companion.max_health)
		
		"dark_rebirth":
			# Revive defeated companions
			revive_companions()
	
	special_ability_used.emit(special_ability)
	is_busy = false

func blast_energy():
	print("⚡ ", alien_name, " blasts energy!")
	# Create energy blast effect
	# This would be implemented with actual particle effects

func create_crystal_shield():
	print("🛡️ ", alien_name, " creates crystal shield!")
	if owner_kid:
		owner_kid.has_force_field = true
		await get_tree().create_timer(10.0).timeout
		owner_kid.has_force_field = false

func breath_plasma():
	print("🔥 ", alien_name, " breathes plasma!")
	# Create plasma breath effect

func create_quantum_tunnel():
	print("🌀 ", alien_name, " creates quantum tunnel!")
	if owner_kid and owner_kid.has_teleporter:
		# Teleport to random location
		var random_pos = Vector3(randf_range(-20, 20), 1, randf_range(-20, 20))
		owner_kid.global_position = random_pos

func hunt_in_void():
	print("🌌 ", alien_name, " hunts in the void!")
	if owner_kid:
		var materials = ["dark_matter", "quantum_dust", "plasma_core"]
		var found_material = materials[randi() % materials.size()]
		var amount = randi_range(2, 5)
		owner_kid.add_material(found_material, amount)

func help_with_building():
	print("🔨 ", alien_name, " helps with building!")
	if owner_kid and owner_kid.current_building:
		# Reduce building time or cost
		pass

func revive_companions():
	print("🔄 ", alien_name, " revives companions!")
	if owner_kid:
		for companion in owner_kid.alien_companions:
			if companion.current_health <= 0:
				companion.heal(companion.max_health)

# Experience and leveling
func add_experience(amount: int):
	experience += amount
	print("✨ ", alien_name, " gained ", amount, " experience!")
	
	# Check for level up
	var exp_needed = level * 60
	if experience >= exp_needed:
		perform_level_up()

func perform_level_up():
	level += 1
	experience = 0
	max_health += 15
	current_health = max_health
	
	print("🎉 ", alien_name, " leveled up to level ", level, "!")
	level_up.emit(level)

# Health management
func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		print("💀 ", alien_name, " is defeated!")
		# Handle defeat logic

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health)

# Transformation system
func can_transform_to(target_type: AlienType) -> bool:
	if not can_transform:
		return false
	
	# Check if transformation level allows this transformation
	var required_level = get_transformation_level_required(target_type)
	return transformation_level >= required_level

func get_transformation_level_required(target_type: AlienType) -> int:
	match target_type:
		AlienType.ZORGLON, AlienType.CRYSTAL_BEAST, AlienType.STAR_CAT:
			return 1
		AlienType.QUANTUM_FOX, AlienType.VOID_WOLF, AlienType.NEBULA_BIRD:
			return 2
		AlienType.PLASMA_DRAGON, AlienType.GALAXY_BEAR:
			return 3
		_:
			return 999  # Cannot transform to this type

func transform_to(target_type: AlienType):
	if not can_transform_to(target_type):
		print("❌ Cannot transform to this alien type yet!")
		return false
	
	var old_type = alien_type
	alien_type = target_type
	setup_alien_type()
	
	print("🔄 ", alien_name, " transformed from ", AlienType.keys()[old_type], " to ", AlienType.keys()[target_type], "!")
	transformed.emit(target_type)
	return true

func set_owner_kid(kid: SpaceKid):
	owner_kid = kid

# Utility functions
func get_alien_type_name() -> String:
	return AlienType.keys()[alien_type]

func get_happiness_status() -> String:
	if happiness >= 80:
		return "Cosmically Happy"
	elif happiness >= 60:
		return "Stellar Happy"
	elif happiness >= 40:
		return "Neutral"
	elif happiness >= 20:
		return "Void Sad"
	else:
		return "Dark Matter Sad"

func get_loyalty_status() -> String:
	if loyalty >= 80:
		return "Galactically Loyal"
	elif loyalty >= 60:
		return "Stellar Loyal"
	elif loyalty >= 40:
		return "Neutral"
	elif loyalty >= 20:
		return "Void Disloyal"
	else:
		return "Dark Matter Disloyal"
