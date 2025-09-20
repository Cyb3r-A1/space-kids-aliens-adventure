extends Node3D
class_name Planet

# Planet types and their characteristics
enum PlanetType {
	LAVA_WORLD, DESERT_WORLD, EARTH_LIKE, ICE_WORLD, GAS_GIANT,
	TOXIC_WORLD, CRYSTAL_WORLD, VOLCANIC_WORLD, OCEAN_WORLD, DEAD_WORLD
}

# Planet properties
@export var planet_name: String = "Unknown Planet"
@export var planet_type: PlanetType = PlanetType.EARTH_LIKE
@export var size: float = 1.0
@export var temperature: float = 20.0
@export var atmosphere: String = "Breathable"
@export var gravity: float = 1.0
@export var discovered: bool = false
@export var colonized: bool = false
@export var terraformed: bool = false
@export var destroyed: bool = false

# Planet resources
var planet_resources: Dictionary = {}
var max_resources: Dictionary = {}

# Terraforming system
var terraforming_progress: float = 0.0
var terraforming_requirements: Dictionary = {}
var terraforming_time: float = 60.0  # 1 minute to terraform

# Rebuilding system
var rebuilding_progress: float = 0.0
var rebuilding_requirements: Dictionary = {}
var rebuilding_time: float = 120.0  # 2 minutes to rebuild

# Colonization
var population: int = 0
var max_population: int = 1000
var colony_buildings: Array[SpaceBuilding] = []

# Visual effects
var planet_mesh: MeshInstance3D = null
var atmosphere_effect: MeshInstance3D = null
var terraforming_particles: CPUParticles3D = null

# Signals
signal planet_discovered(planet: Planet)
signal planet_colonized(planet: Planet)
signal planet_terraformed(planet: Planet)
signal planet_rebuilt(planet: Planet)
signal planet_destroyed(planet: Planet)

func _ready():
	setup_planet()
	print("🪐 Planet '", planet_name, "' initialized!")

func setup_planet():
	# Generate planet-specific resources
	generate_planet_resources()
	
	# Setup terraforming requirements
	setup_terraforming_requirements()
	
	# Setup rebuilding requirements
	setup_rebuilding_requirements()
	
	# Create visual effects
	create_planet_visuals()

func generate_planet_resources():
	match planet_type:
		PlanetType.LAVA_WORLD:
			planet_resources = {
				"lava_metal": randi_range(50, 100),
				"volcanic_crystal": randi_range(20, 50),
				"heat_energy": randi_range(30, 70)
			}
			max_resources = {"lava_metal": 200, "volcanic_crystal": 100, "heat_energy": 150}
		PlanetType.DESERT_WORLD:
			planet_resources = {
				"sand_crystal": randi_range(40, 80),
				"desert_metal": randi_range(30, 60),
				"solar_energy": randi_range(50, 100)
			}
			max_resources = {"sand_crystal": 150, "desert_metal": 120, "solar_energy": 200}
		PlanetType.EARTH_LIKE:
			planet_resources = {
				"organic_matter": randi_range(60, 120),
				"water": randi_range(80, 150),
				"minerals": randi_range(40, 80)
			}
			max_resources = {"organic_matter": 250, "water": 300, "minerals": 160}
		PlanetType.ICE_WORLD:
			planet_resources = {
				"ice_crystal": randi_range(70, 140),
				"frozen_gas": randi_range(30, 70),
				"cold_energy": randi_range(20, 50)
			}
			max_resources = {"ice_crystal": 280, "frozen_gas": 140, "cold_energy": 100}
		PlanetType.GAS_GIANT:
			planet_resources = {
				"gas_cloud": randi_range(100, 200),
				"storm_energy": randi_range(40, 90),
				"atmospheric_gas": randi_range(60, 120)
			}
			max_resources = {"gas_cloud": 400, "storm_energy": 180, "atmospheric_gas": 240}
		PlanetType.TOXIC_WORLD:
			planet_resources = {
				"toxic_gas": randi_range(50, 100),
				"poison_crystal": randi_range(25, 60),
				"corrosive_acid": randi_range(30, 70)
			}
			max_resources = {"toxic_gas": 200, "poison_crystal": 120, "corrosive_acid": 140}
		PlanetType.CRYSTAL_WORLD:
			planet_resources = {
				"crystal_formation": randi_range(80, 160),
				"prismatic_energy": randi_range(40, 90),
				"gem_deposits": randi_range(20, 50)
			}
			max_resources = {"crystal_formation": 320, "prismatic_energy": 180, "gem_deposits": 100}
		PlanetType.VOLCANIC_WORLD:
			planet_resources = {
				"volcanic_rock": randi_range(60, 120),
				"magma_core": randi_range(30, 70),
				"eruption_energy": randi_range(40, 90)
			}
			max_resources = {"volcanic_rock": 240, "magma_core": 140, "eruption_energy": 180}
		PlanetType.OCEAN_WORLD:
			planet_resources = {
				"liquid_water": randi_range(100, 200),
				"marine_life": randi_range(50, 120),
				"ocean_minerals": randi_range(40, 90)
			}
			max_resources = {"liquid_water": 400, "marine_life": 240, "ocean_minerals": 180}
		PlanetType.DEAD_WORLD:
			planet_resources = {
				"ancient_ruins": randi_range(20, 50),
				"dead_matter": randi_range(30, 70),
				"void_energy": randi_range(10, 30)
			}
			max_resources = {"ancient_ruins": 100, "dead_matter": 140, "void_energy": 60}

func setup_terraforming_requirements():
	match planet_type:
		PlanetType.LAVA_WORLD:
			terraforming_requirements = {
				"water": 100,
				"cooling_systems": 50,
				"atmosphere_generators": 30
			}
		PlanetType.DESERT_WORLD:
			terraforming_requirements = {
				"water": 150,
				"soil_enrichers": 80,
				"atmosphere_generators": 40
			}
		PlanetType.ICE_WORLD:
			terraforming_requirements = {
				"heat_generators": 100,
				"atmosphere_generators": 60,
				"soil_enrichers": 50
			}
		PlanetType.TOXIC_WORLD:
			terraforming_requirements = {
				"toxin_cleaners": 120,
				"atmosphere_purifiers": 80,
				"soil_enrichers": 60
			}
		PlanetType.DEAD_WORLD:
			terraforming_requirements = {
				"life_seeds": 200,
				"atmosphere_generators": 100,
				"soil_enrichers": 100
			}
		_:
			terraforming_requirements = {
				"atmosphere_generators": 50,
				"soil_enrichers": 30
			}

func setup_rebuilding_requirements():
	rebuilding_requirements = {
		"space_metal": 200,
		"energy_crystal": 150,
		"terraforming_tech": 100,
		"life_support_systems": 80
	}

func create_planet_visuals():
	# Create planet mesh
	planet_mesh = MeshInstance3D.new()
	planet_mesh.name = "PlanetMesh"
	planet_mesh.mesh = SphereMesh.new()
	planet_mesh.scale = Vector3(size, size, size)
	
	# Set planet color based on type
	var material = StandardMaterial3D.new()
	match planet_type:
		PlanetType.LAVA_WORLD:
			material.albedo_color = Color(0.8, 0.2, 0.1)  # Red
			material.emission_enabled = true
			material.emission = Color(0.8, 0.2, 0.1)
			material.emission_energy = 0.5
		PlanetType.DESERT_WORLD:
			material.albedo_color = Color(0.8, 0.6, 0.2)  # Yellow
		PlanetType.EARTH_LIKE:
			material.albedo_color = Color(0.2, 0.6, 0.8)  # Blue
		PlanetType.ICE_WORLD:
			material.albedo_color = Color(0.8, 0.9, 1.0)  # Light blue
		PlanetType.GAS_GIANT:
			material.albedo_color = Color(0.6, 0.3, 0.8)  # Purple
		PlanetType.TOXIC_WORLD:
			material.albedo_color = Color(0.6, 0.8, 0.2)  # Green
		PlanetType.CRYSTAL_WORLD:
			material.albedo_color = Color(0.8, 0.8, 1.0)  # Light purple
			material.emission_enabled = true
			material.emission = Color(0.8, 0.8, 1.0)
			material.emission_energy = 0.3
		PlanetType.VOLCANIC_WORLD:
			material.albedo_color = Color(0.6, 0.2, 0.1)  # Dark red
		PlanetType.OCEAN_WORLD:
			material.albedo_color = Color(0.1, 0.3, 0.8)  # Deep blue
		PlanetType.DEAD_WORLD:
			material.albedo_color = Color(0.3, 0.3, 0.3)  # Gray
	
	planet_mesh.material_override = material
	add_child(planet_mesh)
	
	# Create atmosphere effect
	create_atmosphere_effect()
	
	# Create terraforming particles
	create_terraforming_particles()

func create_atmosphere_effect():
	atmosphere_effect = MeshInstance3D.new()
	atmosphere_effect.name = "Atmosphere"
	atmosphere_effect.mesh = SphereMesh.new()
	atmosphere_effect.scale = Vector3(size * 1.2, size * 1.2, size * 1.2)
	
	var atmosphere_material = StandardMaterial3D.new()
	atmosphere_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	atmosphere_material.albedo_color = Color(0.5, 0.8, 1.0, 0.3)
	atmosphere_material.emission_enabled = true
	atmosphere_material.emission = Color(0.5, 0.8, 1.0)
	atmosphere_material.emission_energy = 0.2
	atmosphere_effect.material_override = atmosphere_material
	
	add_child(atmosphere_effect)

func create_terraforming_particles():
	terraforming_particles = CPUParticles3D.new()
	terraforming_particles.name = "TerraformingParticles"
	terraforming_particles.emitting = false
	terraforming_particles.amount = 100
	terraforming_particles.lifetime = 3.0
	terraforming_particles.direction = Vector3(0, 1, 0)
	terraforming_particles.spread = 45.0
	terraforming_particles.initial_velocity_min = 1.0
	terraforming_particles.initial_velocity_max = 3.0
	
	add_child(terraforming_particles)

func discover_planet(space_kid: SpaceKid):
	if not discovered:
		discovered = true
		space_kid.add_experience(100)
		print("🔍 Discovered planet: ", planet_name, "!")
		planet_discovered.emit(self)

func colonize_planet(space_kid: SpaceKid):
	if discovered and not colonized and not destroyed:
		colonized = true
		population = 100
		space_kid.add_experience(300)
		print("🏗️ Colonized planet: ", planet_name, "!")
		planet_colonized.emit(self)

func start_terraforming(space_kid: SpaceKid):
	if colonized and not terraformed and not destroyed:
		if can_afford_terraforming(space_kid):
			consume_terraforming_materials(space_kid)
			terraforming_particles.emitting = true
			print("🌱 Started terraforming ", planet_name, "!")
			# Start terraforming process
			await terraform_planet()

func can_afford_terraforming(space_kid: SpaceKid) -> bool:
	for material in terraforming_requirements:
		if not space_kid.has_item(material, terraforming_requirements[material]):
			return false
	return true

func consume_terraforming_materials(space_kid: SpaceKid):
	for material in terraforming_requirements:
		space_kid.remove_item(material, terraforming_requirements[material])

func terraform_planet():
	# Terraforming process
	var terraforming_timer = Timer.new()
	terraforming_timer.wait_time = terraforming_time
	terraforming_timer.timeout.connect(_on_terraforming_complete)
	add_child(terraforming_timer)
	terraforming_timer.start()
	
	# Update progress
	while terraforming_timer.time_left > 0:
		terraforming_progress = (terraforming_time - terraforming_timer.time_left) / terraforming_time
		await get_tree().process_frame

func _on_terraforming_complete():
	terraformed = true
	terraforming_particles.emitting = false
	max_population *= 2
	population = max_population
	print("🌍 Successfully terraformed ", planet_name, "!")
	planet_terraformed.emit(self)

func start_rebuilding(space_kid: SpaceKid):
	if destroyed:
		if can_afford_rebuilding(space_kid):
			consume_rebuilding_materials(space_kid)
			terraforming_particles.emitting = true
			print("🔨 Started rebuilding ", planet_name, "!")
			# Start rebuilding process
			await rebuild_planet()

func can_afford_rebuilding(space_kid: SpaceKid) -> bool:
	for material in rebuilding_requirements:
		if not space_kid.building_materials.has(material) or space_kid.building_materials[material] < rebuilding_requirements[material]:
			return false
	return true

func consume_rebuilding_materials(space_kid: SpaceKid):
	for material in rebuilding_requirements:
		space_kid.building_materials[material] -= rebuilding_requirements[material]

func rebuild_planet():
	# Rebuilding process
	var rebuilding_timer = Timer.new()
	rebuilding_timer.wait_time = rebuilding_time
	rebuilding_timer.timeout.connect(_on_rebuilding_complete)
	add_child(rebuilding_timer)
	rebuilding_timer.start()
	
	# Update progress
	while rebuilding_timer.time_left > 0:
		rebuilding_progress = (rebuilding_time - rebuilding_timer.time_left) / rebuilding_time
		await get_tree().process_frame

func _on_rebuilding_complete():
	destroyed = false
	terraformed = true
	population = 500
	max_population = 2000
	terraforming_particles.emitting = false
	print("🏗️ Successfully rebuilt ", planet_name, "!")
	planet_rebuilt.emit(self)

func destroy_planet():
	if not destroyed:
		destroyed = true
		colonized = false
		terraformed = false
		population = 0
		print("💥 Planet ", planet_name, " has been destroyed!")
		planet_destroyed.emit(self)

func can_support_life() -> bool:
	return planet_type == PlanetType.EARTH_LIKE or terraformed

func get_planet_type_name() -> String:
	return PlanetType.keys()[planet_type]

func get_planet_status() -> String:
	if destroyed:
		return "Destroyed"
	elif terraformed:
		return "Terraformed"
	elif colonized:
		return "Colonized"
	elif discovered:
		return "Discovered"
	else:
		return "Unexplored"

func get_resource_summary() -> String:
	var summary = "Planet Resources:\n"
	for resource in planet_resources:
		summary += "- " + resource.replace("_", " ").capitalize() + ": " + str(planet_resources[resource]) + "/" + str(max_resources[resource]) + "\n"
	return summary

func extract_resources(resource_type: String, amount: int) -> int:
	if planet_resources.has(resource_type):
		var extracted = min(amount, planet_resources[resource_type])
		planet_resources[resource_type] -= extracted
		return extracted
	return 0
