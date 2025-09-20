extends Node3D
class_name PlanetSystem

# Planet system properties
@export var system_name: String = "Solar System"
@export var discovered: bool = false
@export var colonized: bool = false

# Planets in this system
var planets: Array[Planet] = []
var max_planets: int = 5

# System resources
var system_resources: Dictionary = {
	"asteroid_metal": 0,
	"comet_ice": 0,
	"stellar_wind": 0,
	"cosmic_radiation": 0
}

# Visual effects
var star: Node3D = null
var asteroid_belt: Array[Node3D] = []

func _ready():
	setup_planet_system()
	print("⭐ Planet system '", system_name, "' initialized!")

func setup_planet_system():
	# Generate system resources
	system_resources["asteroid_metal"] = randi_range(20, 60)
	system_resources["comet_ice"] = randi_range(15, 45)
	system_resources["stellar_wind"] = randi_range(10, 40)
	system_resources["cosmic_radiation"] = randi_range(5, 25)
	
	# Generate planets
	generate_planets()
	
	# Create visual effects
	create_system_visuals()

func generate_planets():
	for i in range(max_planets):
		var planet = Planet.new()
		
		# Position planets in orbital pattern
		var distance = 8 + (i * 6)  # Increasing distance from star
		var angle = randf() * 2 * PI
		
		planet.position = Vector3(
			cos(angle) * distance,
			0,
			sin(angle) * distance
		)
		
		# Set planet properties based on distance from star
		setup_planet_properties(planet, i, distance)
		
		planets.append(planet)
		add_child(planet)

func setup_planet_properties(planet: Planet, index: int, distance: float):
	planet.planet_name = system_name + " Planet " + str(index + 1)
	
	# Determine planet type based on distance from star
	if distance < 12:
		planet.planet_type = Planet.PlanetType.LAVA_WORLD
		planet.temperature = 800
		planet.atmosphere = "Sulfuric"
	elif distance < 18:
		planet.planet_type = Planet.PlanetType.DESERT_WORLD
		planet.temperature = 400
		planet.atmosphere = "Thin"
	elif distance < 24:
		planet.planet_type = Planet.PlanetType.EARTH_LIKE
		planet.temperature = 20
		planet.atmosphere = "Breathable"
	elif distance < 30:
		planet.planet_type = Planet.PlanetType.ICE_WORLD
		planet.temperature = -100
		planet.atmosphere = "Frozen"
	else:
		planet.planet_type = Planet.PlanetType.GAS_GIANT
		planet.temperature = -200
		planet.atmosphere = "Dense Gas"

func create_system_visuals():
	# Create central star
	create_star()
	
	# Create asteroid belt
	create_asteroid_belt()

func create_star():
	star = MeshInstance3D.new()
	star.name = "Star"
	star.mesh = SphereMesh.new()
	star.scale = Vector3(2, 2, 2)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.9, 0.3)  # Yellow star
	material.emission_enabled = true
	material.emission = Color(1.0, 0.9, 0.3)
	material.emission_energy = 2.0
	star.material_override = material
	
	add_child(star)

func create_asteroid_belt():
	var belt_count = 20
	for i in range(belt_count):
		var asteroid = create_asteroid()
		var angle = (i * 2 * PI) / belt_count
		var distance = 35
		
		asteroid.position = Vector3(
			cos(angle) * distance,
			randf_range(-2, 2),
			sin(angle) * distance
		)
		
		asteroid_belt.append(asteroid)
		add_child(asteroid)

func create_asteroid():
	var asteroid = MeshInstance3D.new()
	asteroid.mesh = BoxMesh.new()
	asteroid.scale = Vector3(0.5, 0.5, 0.5)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.6, 0.4, 0.2)  # Brown asteroid
	asteroid.material_override = material
	
	return asteroid

func explore_system(space_kid: SpaceKid):
	if not discovered:
		discovered = true
		space_kid.add_experience(200)
		print("🔍 Discovered planet system: ", system_name, "!")
		
		# Reveal planets
		for planet in planets:
			planet.discovered = true

func colonize_system(space_kid: SpaceKid):
	if discovered and not colonized:
		colonized = true
		space_kid.add_experience(400)
		print("🏗️ Colonized planet system: ", system_name, "!")
		
		# Unlock system resources
		for resource in system_resources:
			space_kid.add_material(resource, system_resources[resource])

func get_system_status() -> String:
	if colonized:
		return "Colonized"
	elif discovered:
		return "Discovered"
	else:
		return "Unexplored"

func get_planet_count() -> int:
	return planets.size()

func get_habitable_planets() -> Array[Planet]:
	var habitable = []
	for planet in planets:
		if planet.can_support_life():
			habitable.append(planet)
	return habitable
