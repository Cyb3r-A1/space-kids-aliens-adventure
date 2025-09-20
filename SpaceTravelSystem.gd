extends Node3D
class_name SpaceTravelSystem

# Space travel properties
@export var travel_speed: float = 10.0
@export var fuel_capacity: int = 100
@export var current_fuel: int = 100
@export var warp_drive_unlocked: bool = false
@export var hyperdrive_unlocked: bool = false

# Travel destinations
var current_galaxy: Galaxy = null
var current_planet_system: PlanetSystem = null
var current_planet: Planet = null
var available_galaxies: Array[Galaxy] = []
var available_systems: Array[PlanetSystem] = []
var available_planets: Array[Planet] = []

# Travel requirements
var travel_requirements: Dictionary = {
	"galaxy_travel": {"fuel": 20, "time": 30.0},
	"system_travel": {"fuel": 10, "time": 15.0},
	"planet_travel": {"fuel": 5, "time": 10.0},
	"warp_travel": {"fuel": 15, "time": 5.0},
	"hyperdrive_travel": {"fuel": 25, "time": 2.0}
}

# Visual effects
var travel_trail: CPUParticles3D = null
var warp_effect: MeshInstance3D = null
var hyperdrive_effect: MeshInstance3D = null

# Owner reference
var space_kid: SpaceKid = null

# Signals
signal travel_started(destination: String)
signal travel_completed(destination: String)
signal fuel_changed(new_fuel: int)
signal new_galaxy_discovered(galaxy: Galaxy)
signal new_system_discovered(system: PlanetSystem)
signal new_planet_discovered(planet: Planet)

func _ready():
	setup_travel_system()
	print("🚀 Space Travel System initialized!")

func setup_travel_system():
	# Create visual effects
	create_travel_effects()
	
	# Initialize fuel
	current_fuel = fuel_capacity

func create_travel_effects():
	# Create travel trail
	travel_trail = CPUParticles3D.new()
	travel_trail.name = "TravelTrail"
	travel_trail.emitting = false
	travel_trail.amount = 200
	travel_trail.lifetime = 2.0
	travel_trail.direction = Vector3(0, 0, -1)
	travel_trail.spread = 10.0
	travel_trail.initial_velocity_min = 5.0
	travel_trail.initial_velocity_max = 10.0
	add_child(travel_trail)
	
	# Create warp effect
	warp_effect = MeshInstance3D.new()
	warp_effect.name = "WarpEffect"
	warp_effect.mesh = SphereMesh.new()
	warp_effect.scale = Vector3(3, 3, 3)
	warp_effect.visible = false
	
	var warp_material = StandardMaterial3D.new()
	warp_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	warp_material.albedo_color = Color(0.2, 0.8, 1.0, 0.5)
	warp_material.emission_enabled = true
	warp_material.emission = Color(0.2, 0.8, 1.0)
	warp_material.emission_energy = 1.0
	warp_effect.material_override = warp_material
	
	add_child(warp_effect)
	
	# Create hyperdrive effect
	hyperdrive_effect = MeshInstance3D.new()
	hyperdrive_effect.name = "HyperdriveEffect"
	hyperdrive_effect.mesh = BoxMesh.new()
	hyperdrive_effect.scale = Vector3(5, 0.1, 5)
	hyperdrive_effect.visible = false
	
	var hyperdrive_material = StandardMaterial3D.new()
	hyperdrive_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hyperdrive_material.albedo_color = Color(1.0, 0.2, 0.8, 0.7)
	hyperdrive_material.emission_enabled = true
	hyperdrive_material.emission = Color(1.0, 0.2, 0.8)
	hyperdrive_material.emission_energy = 2.0
	hyperdrive_effect.material_override = hyperdrive_material
	
	add_child(hyperdrive_effect)

func set_space_kid(kid: SpaceKid):
	space_kid = kid

func travel_to_galaxy(galaxy: Galaxy):
	if not can_travel_to_galaxy(galaxy):
		print("❌ Cannot travel to galaxy: ", galaxy.galaxy_name)
		return false
	
	var requirements = travel_requirements["galaxy_travel"]
	if warp_drive_unlocked:
		requirements = travel_requirements["warp_travel"]
	elif hyperdrive_unlocked:
		requirements = travel_requirements["hyperdrive_travel"]
	
	# Consume fuel
	current_fuel -= requirements["fuel"]
	fuel_changed.emit(current_fuel)
	
	# Start travel
	travel_started.emit(galaxy.galaxy_name)
	await perform_travel(requirements["time"], galaxy.position)
	
	# Complete travel
	current_galaxy = galaxy
	galaxy.explore_galaxy(space_kid)
	travel_completed.emit(galaxy.galaxy_name)
	new_galaxy_discovered.emit(galaxy)
	
	# Update available systems
	update_available_systems()
	
	return true

func travel_to_planet_system(system: PlanetSystem):
	if not can_travel_to_system(system):
		print("❌ Cannot travel to system: ", system.system_name)
		return false
	
	var requirements = travel_requirements["system_travel"]
	
	# Consume fuel
	current_fuel -= requirements["fuel"]
	fuel_changed.emit(current_fuel)
	
	# Start travel
	travel_started.emit(system.system_name)
	await perform_travel(requirements["time"], system.position)
	
	# Complete travel
	current_planet_system = system
	system.explore_system(space_kid)
	travel_completed.emit(system.system_name)
	new_system_discovered.emit(system)
	
	# Update available planets
	update_available_planets()
	
	return true

func travel_to_planet(planet: Planet):
	if not can_travel_to_planet(planet):
		print("❌ Cannot travel to planet: ", planet.planet_name)
		return false
	
	var requirements = travel_requirements["planet_travel"]
	
	# Consume fuel
	current_fuel -= requirements["fuel"]
	fuel_changed.emit(current_fuel)
	
	# Start travel
	travel_started.emit(planet.planet_name)
	await perform_travel(requirements["time"], planet.position)
	
	# Complete travel
	current_planet = planet
	planet.discover_planet(space_kid)
	travel_completed.emit(planet.planet_name)
	new_planet_discovered.emit(planet)
	
	return true

func can_travel_to_galaxy(galaxy: Galaxy) -> bool:
	var requirements = travel_requirements["galaxy_travel"]
	if warp_drive_unlocked:
		requirements = travel_requirements["warp_travel"]
	elif hyperdrive_unlocked:
		requirements = travel_requirements["hyperdrive_travel"]
	
	return current_fuel >= requirements["fuel"]

func can_travel_to_system(system: PlanetSystem) -> bool:
	var requirements = travel_requirements["system_travel"]
	return current_fuel >= requirements["fuel"]

func can_travel_to_planet(planet: Planet) -> bool:
	var requirements = travel_requirements["planet_travel"]
	return current_fuel >= requirements["fuel"]

func perform_travel(travel_time: float, destination: Vector3):
	# Start visual effects
	travel_trail.emitting = true
	
	if warp_drive_unlocked:
		warp_effect.visible = true
	elif hyperdrive_unlocked:
		hyperdrive_effect.visible = true
	
	# Move towards destination
	var start_position = global_position
	var travel_distance = start_position.distance_to(destination)
	var travel_speed_per_frame = travel_distance / (travel_time * 60)  # Assuming 60 FPS
	
	var elapsed_time = 0.0
	while elapsed_time < travel_time:
		var progress = elapsed_time / travel_time
		global_position = start_position.lerp(destination, progress)
		
		# Update visual effects
		update_travel_effects(progress)
		
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
	
	# Complete travel
	global_position = destination
	travel_trail.emitting = false
	warp_effect.visible = false
	hyperdrive_effect.visible = false

func update_travel_effects(progress: float):
	if warp_drive_unlocked:
		warp_effect.scale = Vector3(3 + progress * 2, 3 + progress * 2, 3 + progress * 2)
	elif hyperdrive_effect:
		hyperdrive_effect.scale = Vector3(5 + progress * 3, 0.1, 5 + progress * 3)

func refuel(amount: int):
	current_fuel = min(fuel_capacity, current_fuel + amount)
	fuel_changed.emit(current_fuel)
	print("⛽ Refueled! Current fuel: ", current_fuel, "/", fuel_capacity)

func unlock_warp_drive():
	if not warp_drive_unlocked:
		warp_drive_unlocked = true
		print("🌀 Warp drive unlocked! Faster galaxy travel available!")

func unlock_hyperdrive():
	if not hyperdrive_unlocked:
		hyperdrive_unlocked = true
		print("⚡ Hyperdrive unlocked! Instant galaxy travel available!")

func update_available_systems():
	if current_galaxy:
		available_systems = current_galaxy.planet_systems.duplicate()

func update_available_planets():
	if current_planet_system:
		available_planets = current_planet_system.planets.duplicate()

func get_travel_status() -> String:
	var status = "Space Travel Status:\n"
	status += "Current Galaxy: " + (current_galaxy.galaxy_name if current_galaxy else "None") + "\n"
	status += "Current System: " + (current_planet_system.system_name if current_planet_system else "None") + "\n"
	status += "Current Planet: " + (current_planet.planet_name if current_planet else "None") + "\n"
	status += "Fuel: " + str(current_fuel) + "/" + str(fuel_capacity) + "\n"
	status += "Warp Drive: " + ("Unlocked" if warp_drive_unlocked else "Locked") + "\n"
	status += "Hyperdrive: " + ("Unlocked" if hyperdrive_unlocked else "Locked") + "\n"
	return status

func get_available_destinations() -> Dictionary:
	var destinations = {
		"galaxies": [],
		"systems": [],
		"planets": []
	}
	
	for galaxy in available_galaxies:
		destinations["galaxies"].append({
			"name": galaxy.galaxy_name,
			"type": galaxy.get_galaxy_type_name(),
			"status": galaxy.get_discovery_status()
		})
	
	for system in available_systems:
		destinations["systems"].append({
			"name": system.system_name,
			"planet_count": system.get_planet_count(),
			"status": system.get_system_status()
		})
	
	for planet in available_planets:
		destinations["planets"].append({
			"name": planet.planet_name,
			"type": planet.get_planet_type_name(),
			"status": planet.get_planet_status()
		})
	
	return destinations
