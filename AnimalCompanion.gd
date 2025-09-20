extends CharacterBody3D
class_name AnimalCompanion

# Animal types and their characteristics
enum AnimalType {
	CAT, DOG, BIRD, RABBIT, FOX, WOLF, BEAR, DRAGON, PHOENIX, UNICORN
}

# Animal stats
@export var animal_name: String = "Fluffy"
@export var animal_type: AnimalType = AnimalType.CAT
@export var level: int = 1
@export var experience: int = 0
@export var max_health: int = 50
@export var current_health: int = 50
@export var happiness: int = 100
@export var loyalty: int = 100
@export var special_ability: String = ""

# Movement and behavior
@export var move_speed: float = 4.0
@export var follow_distance: float = 3.0
@export var interaction_range: float = 2.0

# Transformation system
@export var can_transform: bool = false
@export var transformation_level: int = 0
@export var max_transformation_level: int = 3
var transformation_materials: Dictionary = {}

# Owner reference
var owner_kid: KidCharacter = null
var target_position: Vector3 = Vector3.ZERO
var is_following: bool = true
var is_busy: bool = false

# Signals
signal health_changed(new_health: int)
signal happiness_changed(new_happiness: int)
signal loyalty_changed(new_loyalty: int)
signal level_up(new_level: int)
signal transformed(new_type: AnimalType)
signal special_ability_used(ability: String)

func _ready():
	current_health = max_health
	setup_animal_type()
	print("🐾 Animal companion '", animal_name, "' is ready!")

func setup_animal_type():
	match animal_type:
		AnimalType.CAT:
			move_speed = 4.0
			special_ability = "stealth"
			can_transform = false
		AnimalType.DOG:
			move_speed = 5.0
			special_ability = "loyalty_boost"
			can_transform = true
		AnimalType.BIRD:
			move_speed = 6.0
			special_ability = "flight"
			can_transform = true
		AnimalType.RABBIT:
			move_speed = 3.0
			special_ability = "speed_boost"
			can_transform = true
		AnimalType.FOX:
			move_speed = 4.5
			special_ability = "cunning"
			can_transform = true
		AnimalType.WOLF:
			move_speed = 5.5
			special_ability = "pack_hunting"
			can_transform = true
		AnimalType.BEAR:
			move_speed = 2.0
			special_ability = "strength"
			can_transform = true
		AnimalType.DRAGON:
			move_speed = 3.0
			special_ability = "fire_breath"
			can_transform = false
		AnimalType.PHOENIX:
			move_speed = 7.0
			special_ability = "rebirth"
			can_transform = false
		AnimalType.UNICORN:
			move_speed = 4.0
			special_ability = "healing"
			can_transform = false

func _physics_process(delta):
	if owner_kid and is_following:
		follow_owner(delta)
	
	handle_interaction()
	handle_special_ability()

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
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	move_and_slide()

func handle_interaction():
	if Input.is_action_just_pressed("interact") and owner_kid:
		var distance_to_kid = global_position.distance_to(owner_kid.global_position)
		if distance_to_kid <= interaction_range:
			interact_with_kid()

func interact_with_kid():
	print("🐾 ", animal_name, " interacts with ", owner_kid.kid_name)
	
	# Petting increases happiness
	happiness = min(100, happiness + 10)
	happiness_changed.emit(happiness)
	
	# Feeding if kid has food
	if owner_kid.has_item("pet_food"):
		owner_kid.remove_item("pet_food", 1)
		happiness = min(100, happiness + 20)
		loyalty = min(100, loyalty + 5)
		happiness_changed.emit(happiness)
		loyalty_changed.emit(loyalty)
		print("🍽️ ", animal_name, " enjoyed the food!")

func handle_special_ability():
	if Input.is_action_just_pressed("special_ability") and not is_busy:
		use_special_ability()

func use_special_ability():
	if is_busy:
		return
	
	is_busy = true
	print("✨ ", animal_name, " uses ", special_ability, "!")
	
	match special_ability:
		"stealth":
			# Make owner temporarily invisible
			if owner_kid:
				owner_kid.modulate = Color(1, 1, 1, 0.5)
				await get_tree().create_timer(5.0).timeout
				owner_kid.modulate = Color(1, 1, 1, 1)
		
		"loyalty_boost":
			# Increase loyalty of all companions
			if owner_kid:
				for companion in owner_kid.animal_companions:
					companion.loyalty = min(100, companion.loyalty + 10)
					companion.loyalty_changed.emit(companion.loyalty)
		
		"flight":
			# Allow animal to fly temporarily
			velocity.y = 5.0
			await get_tree().create_timer(3.0).timeout
		
		"speed_boost":
			# Increase movement speed temporarily
			var original_speed = move_speed
			move_speed *= 2.0
			await get_tree().create_timer(5.0).timeout
			move_speed = original_speed
		
		"cunning":
			# Find nearby resources
			find_resources()
		
		"pack_hunting":
			# Hunt for food with other wolf companions
			hunt_for_food()
		
		"strength":
			# Help with building
			if owner_kid and owner_kid.current_building:
				help_with_building()
		
		"fire_breath":
			# Attack nearby enemies
			breath_fire()
		
		"rebirth":
			# Heal all companions
			if owner_kid:
				for companion in owner_kid.animal_companions:
					companion.heal(companion.max_health)
		
		"healing":
			# Heal owner
			if owner_kid:
				owner_kid.heal(20)
	
	special_ability_used.emit(special_ability)
	is_busy = false

func find_resources():
	print("🔍 ", animal_name, " found some resources!")
	# Add random materials to owner's inventory
	if owner_kid:
		var materials = ["wood", "stone", "metal", "crystal"]
		var found_material = materials[randi() % materials.size()]
		var amount = randi_range(1, 3)
		owner_kid.add_material(found_material, amount)

func hunt_for_food():
	print("🦌 ", animal_name, " hunted for food!")
	if owner_kid:
		owner_kid.add_item("pet_food", 2)

func help_with_building():
	print("🔨 ", animal_name, " helps with building!")
	if owner_kid and owner_kid.current_building:
		# Reduce building time or cost
		pass

func breath_fire():
	print("🔥 ", animal_name, " breathes fire!")
	# Attack nearby enemies
	# This would be implemented with actual enemy detection

# Experience and leveling
func add_experience(amount: int):
	experience += amount
	print("✨ ", animal_name, " gained ", amount, " experience!")
	
	# Check for level up
	var exp_needed = level * 50
	if experience >= exp_needed:
		perform_level_up()

func perform_level_up():
	level += 1
	experience = 0
	max_health += 10
	current_health = max_health
	
	print("🎉 ", animal_name, " leveled up to level ", level, "!")
	level_up.emit(level)

# Health management
func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		print("💀 ", animal_name, " is defeated!")
		# Handle defeat logic

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health)

# Transformation system
func can_transform_to(target_type: AnimalType) -> bool:
	if not can_transform:
		return false
	
	# Check if transformation level allows this transformation
	var required_level = get_transformation_level_required(target_type)
	return transformation_level >= required_level

func get_transformation_level_required(target_type: AnimalType) -> int:
	match target_type:
		AnimalType.DOG, AnimalType.BIRD, AnimalType.RABBIT:
			return 1
		AnimalType.FOX, AnimalType.WOLF:
			return 2
		AnimalType.BEAR:
			return 3
		_:
			return 999  # Cannot transform to this type

func transform_to(target_type: AnimalType):
	if not can_transform_to(target_type):
		print("❌ Cannot transform to this animal type yet!")
		return false
	
	var old_type = animal_type
	animal_type = target_type
	setup_animal_type()
	
	print("🔄 ", animal_name, " transformed from ", AnimalType.keys()[old_type], " to ", AnimalType.keys()[target_type], "!")
	transformed.emit(target_type)
	return true

func set_owner_kid(kid: KidCharacter):
	owner_kid = kid

# Utility functions
func get_animal_type_name() -> String:
	return AnimalType.keys()[animal_type]

func get_happiness_status() -> String:
	if happiness >= 80:
		return "Very Happy"
	elif happiness >= 60:
		return "Happy"
	elif happiness >= 40:
		return "Neutral"
	elif happiness >= 20:
		return "Sad"
	else:
		return "Very Sad"

func get_loyalty_status() -> String:
	if loyalty >= 80:
		return "Very Loyal"
	elif loyalty >= 60:
		return "Loyal"
	elif loyalty >= 40:
		return "Neutral"
	elif loyalty >= 20:
		return "Disloyal"
	else:
		return "Very Disloyal"
