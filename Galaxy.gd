extends Node3D
class_name Galaxy

# Galaxy types and properties
enum GalaxyType {
	SPIRAL, ELLIPTICAL, IRREGULAR, RING, BARRED_SPIRAL
}

# Galaxy properties
@export var galaxy_name: String = "Andromeda"
@export var galaxy_type: GalaxyType = GalaxyType.SPIRAL
@export var size: float = 100.0
@export var discovered: bool = false
@export var colonized: bool = false

# Planet systems
var planet_systems: Array[PlanetSystem] = []
var max_planet_systems: int = 8

# Galaxy resources
var galaxy_resources: Dictionary = {
	"dark_matter": 0,
	"cosmic_dust": 0,
	"stellar_energy": 0,
	"quantum_crystals": 0
}

# Visual effects
var galaxy_center: Vector3 = Vector3.ZERO
var spiral_arms: Array[Node3D] = []
var nebula_clouds: Array[Node3D] = []

func _ready():
	setup_galaxy()
	print("🌌 Galaxy '", galaxy_name, "' initialized!")

func setup_galaxy():
	# Generate galaxy-specific resources
	match galaxy_type:
		GalaxyType.SPIRAL:
			galaxy_resources["cosmic_dust"] = randi_range(50, 100)
			galaxy_resources["stellar_energy"] = randi_range(30, 80)
		GalaxyType.ELLIPTICAL:
			galaxy_resources["dark_matter"] = randi_range(40, 90)
			galaxy_resources["quantum_crystals"] = randi_range(20, 60)
		GalaxyType.IRREGULAR:
			galaxy_resources["cosmic_dust"] = randi_range(60, 120)
			galaxy_resources["stellar_energy"] = randi_range(40, 100)
		GalaxyType.RING:
			galaxy_resources["quantum_crystals"] = randi_range(80, 150)
			galaxy_resources["cosmic_dust"] = randi_range(30, 70)
		GalaxyType.BARRED_SPIRAL:
			galaxy_resources["stellar_energy"] = randi_range(70, 130)
			galaxy_resources["dark_matter"] = randi_range(30, 80)
	
	# Generate planet systems
	generate_planet_systems()
	
	# Create visual effects
	create_galaxy_visuals()

func generate_planet_systems():
	for i in range(max_planet_systems):
		var planet_system = PlanetSystem.new()
		planet_system.system_name = galaxy_name + " System " + str(i + 1)
		
		# Position planets in spiral pattern
		var angle = (i * 2 * PI) / max_planet_systems
		var distance = randf_range(20, size - 10)
		planet_system.position = Vector3(
			cos(angle) * distance,
			randf_range(-5, 5),
			sin(angle) * distance
		)
		
		planet_systems.append(planet_system)
		add_child(planet_system)

func create_galaxy_visuals():
	# Create galaxy center
	create_galaxy_center()
	
	# Create spiral arms
	create_spiral_arms()
	
	# Create nebula clouds
	create_nebula_clouds()

func create_galaxy_center():
	var center = MeshInstance3D.new()
	center.name = "GalaxyCenter"
	center.mesh = SphereMesh.new()
	center.scale = Vector3(3, 3, 3)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.8, 0.2)  # Golden center
	material.emission_enabled = true
	material.emission = Color(1.0, 0.8, 0.2)
	material.emission_energy = 1.0
	center.material_override = material
	
	add_child(center)
	galaxy_center = center

func create_spiral_arms():
	var arm_count = 2
	if galaxy_type == GalaxyType.BARRED_SPIRAL:
		arm_count = 4
	
	for i in range(arm_count):
		var arm = create_spiral_arm(i, arm_count)
		spiral_arms.append(arm)
		add_child(arm)

func create_spiral_arm(arm_index: int, total_arms: int):
	var arm = Node3D.new()
	arm.name = "SpiralArm" + str(arm_index)
	
	# Create stars along the arm
	var star_count = 20
	for i in range(star_count):
		var star = create_star()
		var angle = (arm_index * 2 * PI / total_arms) + (i * 0.1)
		var distance = i * 2.0
		
		star.position = Vector3(
			cos(angle) * distance,
			randf_range(-1, 1),
			sin(angle) * distance
		)
		arm.add_child(star)
	
	return arm

func create_star():
	var star = MeshInstance3D.new()
	star.mesh = SphereMesh.new()
	star.scale = Vector3(0.2, 0.2, 0.2)
	
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy = randf_range(0.5, 1.5)
	star.material_override = material
	
	return star

func create_nebula_clouds():
	var cloud_count = 3
	for i in range(cloud_count):
		var nebula = create_nebula()
		var angle = randf() * 2 * PI
		var distance = randf_range(30, size - 10)
		
		nebula.position = Vector3(
			cos(angle) * distance,
			randf_range(-10, 10),
			sin(angle) * distance
		)
		
		nebula_clouds.append(nebula)
		add_child(nebula)

func create_nebula():
	var nebula = MeshInstance3D.new()
	nebula.mesh = BoxMesh.new()
	nebula.scale = Vector3(15, 10, 15)
	
	var colors = [Color(1.0, 0.3, 0.8), Color(0.3, 0.8, 1.0), Color(0.8, 1.0, 0.3)]
	var color = colors[randi() % colors.size()]
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.4
	material.emission_enabled = true
	material.emission = color
	material.emission_energy = 0.6
	nebula.material_override = material
	
	return nebula

func explore_galaxy(space_kid: SpaceKid):
	if not discovered:
		discovered = true
		space_kid.add_experience(500)
		print("🌟 Discovered galaxy: ", galaxy_name, "!")
		
		# Reveal planet systems
		for system in planet_systems:
			system.discovered = true

func colonize_galaxy(space_kid: SpaceKid):
	if discovered and not colonized:
		colonized = true
		space_kid.add_experience(1000)
		print("🏗️ Colonized galaxy: ", galaxy_name, "!")
		
		# Unlock galaxy resources
		for resource in galaxy_resources:
			space_kid.add_material(resource, galaxy_resources[resource])

func get_galaxy_type_name() -> String:
	return GalaxyType.keys()[galaxy_type]

func get_discovery_status() -> String:
	if colonized:
		return "Colonized"
	elif discovered:
		return "Discovered"
	else:
		return "Unexplored"

func get_resource_summary() -> String:
	var summary = "Galaxy Resources:\n"
	for resource in galaxy_resources:
		summary += "- " + resource.replace("_", " ").capitalize() + ": " + str(galaxy_resources[resource]) + "\n"
	return summary
