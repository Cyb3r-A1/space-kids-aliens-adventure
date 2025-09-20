extends Node3D
class_name Spaceship

# Spaceship types
enum ShipType {
	FIGHTER, CRUISER, DESTROYER, CARRIER, EXPLORER, MINING_SHIP
}

# Ship properties
@export var ship_name: String = "Cosmic Fighter"
@export var ship_type: ShipType = ShipType.FIGHTER
@export var max_speed: float = 8.0
@export var health: int = 100
@export var current_health: int = 100
@export var max_health: int = 100
@export var energy: int = 100
@export var max_energy: int = 100

# Movement
var velocity: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false
var movement_pattern: String = "orbit"

# Visual effects
var engine_trails: Array[CPUParticles3D] = []
var shield_effect: bool = false
var glow_intensity: float = 1.0

# Combat
var weapons: Array[String] = []
var can_attack: bool = false

func _ready():
	setup_ship_type()
	create_visual_effects()
	print("🚀 Spaceship '", ship_name, "' initialized!")

func setup_ship_type():
	match ship_type:
		ShipType.FIGHTER:
			ship_name = "Cosmic Fighter"
			max_speed = 10.0
			health = 80
			weapons = ["laser_cannon", "plasma_missile"]
			can_attack = true
		ShipType.CRUISER:
			ship_name = "Stellar Cruiser"
			max_speed = 6.0
			health = 150
			weapons = ["heavy_laser", "ion_cannon"]
			can_attack = true
		ShipType.DESTROYER:
			ship_name = "Void Destroyer"
			max_speed = 7.0
			health = 200
			weapons = ["plasma_cannon", "quantum_torpedo"]
			can_attack = true
		ShipType.CARRIER:
			ship_name = "Galaxy Carrier"
			max_speed = 4.0
			health = 300
			weapons = ["fighter_bay", "defense_turret"]
			can_attack = false
		ShipType.EXPLORER:
			ship_name = "Nebula Explorer"
			max_speed = 8.0
			health = 120
			weapons = ["scanner", "probe_launcher"]
			can_attack = false
		ShipType.MINING_SHIP:
			ship_name = "Asteroid Miner"
			max_speed = 5.0
			health = 100
			weapons = ["mining_laser", "tractor_beam"]
			can_attack = false
	
	max_health = health
	current_health = health

func create_visual_effects():
	# Create ship mesh
	var ship_mesh = MeshInstance3D.new()
	ship_mesh.name = "ShipMesh"
	
	# Different shapes for different ship types
	match ship_type:
		ShipType.FIGHTER:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(2, 0.5, 4)
		ShipType.CRUISER:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(3, 1, 6)
		ShipType.DESTROYER:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(4, 1.5, 8)
		ShipType.CARRIER:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(6, 2, 12)
		ShipType.EXPLORER:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(2.5, 0.8, 5)
		ShipType.MINING_SHIP:
			ship_mesh.mesh = BoxMesh.new()
			ship_mesh.scale = Vector3(3, 1, 4)
	
	# Set ship color based on type
	var material = StandardMaterial3D.new()
	match ship_type:
		ShipType.FIGHTER:
			material.albedo_color = Color(0.8, 0.2, 0.2)  # Red
		ShipType.CRUISER:
			material.albedo_color = Color(0.2, 0.2, 0.8)  # Blue
		ShipType.DESTROYER:
			material.albedo_color = Color(0.2, 0.8, 0.2)  # Green
		ShipType.CARRIER:
			material.albedo_color = Color(0.8, 0.8, 0.2)  # Yellow
		ShipType.EXPLORER:
			material.albedo_color = Color(0.8, 0.2, 0.8)  # Magenta
		ShipType.MINING_SHIP:
			material.albedo_color = Color(0.2, 0.8, 0.8)  # Cyan
	
	material.emission_enabled = true
	material.emission = material.albedo_color
	material.emission_energy = 0.3
	ship_mesh.material_override = material
	
	add_child(ship_mesh)
	
	# Create engine trails
	create_engine_trails()
	
	# Create shield effect
	create_shield_effect()

func create_engine_trails():
	var trail_count = 2
	if ship_type == ShipType.CARRIER:
		trail_count = 4
	elif ship_type == ShipType.DESTROYER:
		trail_count = 3
	
	for i in range(trail_count):
		var trail = CPUParticles3D.new()
		trail.name = "EngineTrail" + str(i)
		trail.emitting = true
		trail.amount = 50
		trail.lifetime = 2.0
		trail.direction = Vector3(0, 0, -1)
		trail.spread = 15.0
		trail.initial_velocity_min = 2.0
		trail.initial_velocity_max = 4.0
		
		# Position trail behind ship
		var offset = Vector3(0, 0, 2)
		if trail_count > 1:
			offset.x = (i - trail_count/2.0) * 0.5
		trail.position = offset
		
		add_child(trail)
		engine_trails.append(trail)

func create_shield_effect():
	var shield = MeshInstance3D.new()
	shield.name = "Shield"
	shield.mesh = SphereMesh.new()
	shield.scale = Vector3(1.5, 1.5, 1.5)
	
	var shield_material = StandardMaterial3D.new()
	shield_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shield_material.albedo_color = Color(0.2, 0.8, 1.0, 0.3)
	shield_material.emission_enabled = true
	shield_material.emission = Color(0.2, 0.8, 1.0)
	shield_material.emission_energy = 0.5
	shield.material_override = shield_material
	
	shield.visible = false
	add_child(shield)

func update_movement(delta):
	match movement_pattern:
		"orbit":
			orbit_movement(delta)
		"patrol":
			patrol_movement(delta)
		"hover":
			hover_movement(delta)
		"attack":
			attack_movement(delta)
	
	# Update visual effects
	update_visual_effects(delta)

func orbit_movement(delta):
	var center = Vector3.ZERO
	var radius = 60.0
	var speed = 0.5
	
	var angle = Time.get_time_dict_from_system()["unix"] * speed
	var x = cos(angle) * radius
	var z = sin(angle) * radius
	
	target_position = Vector3(x, position.y, z)
	move_towards_target(delta)

func patrol_movement(delta):
	# Simple back and forth patrol
	var patrol_distance = 40.0
	var speed = 0.3
	
	var time = Time.get_time_dict_from_system()["unix"] * speed
	target_position = Vector3(sin(time) * patrol_distance, position.y, position.z)
	move_towards_target(delta)

func hover_movement(delta):
	# Gentle hovering motion
	var hover_speed = 0.2
	var hover_height = 2.0
	
	var time = Time.get_time_dict_from_system()["unix"] * hover_speed
	target_position = Vector3(position.x, 1 + sin(time) * hover_height, position.z)
	move_towards_target(delta)

func attack_movement(delta):
	# Aggressive movement pattern
	var attack_speed = 1.0
	var time = Time.get_time_dict_from_system()["unix"] * attack_speed
	
	target_position = Vector3(
		cos(time) * 30,
		position.y,
		sin(time) * 30
	)
	move_towards_target(delta)

func move_towards_target(delta):
	var direction = (target_position - position).normalized()
	var distance = position.distance_to(target_position)
	
	if distance > 1.0:
		velocity = direction * max_speed
		position += velocity * delta
		
		# Rotate ship to face movement direction
		if velocity.length() > 0.1:
			look_at(position + velocity, Vector3.UP)

func update_visual_effects(delta):
	# Update engine trail intensity based on speed
	var speed_factor = velocity.length() / max_speed
	for trail in engine_trails:
		trail.emitting = speed_factor > 0.1
		trail.amount = int(50 * speed_factor)
	
	# Update glow effect
	var time = Time.get_time_dict_from_system()["unix"]
	glow_intensity = 0.8 + 0.2 * sin(time * 2)
	
	if has_node("ShipMesh"):
		var mesh = get_node("ShipMesh")
		var material = mesh.material_override as StandardMaterial3D
		if material:
			material.emission_energy = 0.3 * glow_intensity

func activate_shield():
	shield_effect = true
	if has_node("Shield"):
		get_node("Shield").visible = true
	print("🛡️ ", ship_name, " shield activated!")

func deactivate_shield():
	shield_effect = false
	if has_node("Shield"):
		get_node("Shield").visible = false
	print("🛡️ ", ship_name, " shield deactivated!")

func take_damage(amount: int):
	if shield_effect:
		print("🛡️ ", ship_name, " shield absorbed damage!")
		return
	
	health = max(0, health - amount)
	print("💥 ", ship_name, " took ", amount, " damage!")
	
	if health <= 0:
		destroy_ship()

func destroy_ship():
	print("💥 ", ship_name, " has been destroyed!")
	queue_free()

func get_ship_type_name() -> String:
	return ShipType.keys()[ship_type]

func get_status() -> String:
	var status = ship_name + " (" + get_ship_type_name() + ")"
	status += "\nHealth: " + str(health) + "/" + str(max_health)
	status += "\nEnergy: " + str(energy) + "/" + str(max_energy)
	if shield_effect:
		status += "\nShield: Active"
	else:
		status += "\nShield: Inactive"
	return status
