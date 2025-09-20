extends Node3D
class_name ResourceSpawner

# Resource spawning system
@export var spawn_radius: float = 20.0
@export var max_resources: int = 15
@export var spawn_interval: float = 10.0

var spawned_resources: Array[Node3D] = []
var spawn_timer: Timer = null

# Resource types and their spawn chances
var resource_types = {
	"wood": {"chance": 0.4, "mesh": "res://wood_mesh.tres"},
	"stone": {"chance": 0.3, "mesh": "res://stone_mesh.tres"},
	"metal": {"chance": 0.15, "mesh": "res://metal_mesh.tres"},
	"crystal": {"chance": 0.1, "mesh": "res://crystal_mesh.tres"},
	"magic_dust": {"chance": 0.05, "mesh": "res://magic_dust_mesh.tres"}
}

func _ready():
	setup_spawn_timer()
	print("🌲 Resource spawner initialized!")

func setup_spawn_timer():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer)
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_timer():
	if spawned_resources.size() < max_resources:
		spawn_resource()

func spawn_resource():
	var resource_type = select_resource_type()
	var position = get_random_spawn_position()
	
	# Create resource node
	var resource_node = create_resource_node(resource_type)
	resource_node.position = position
	resource_node.name = resource_type + "_" + str(spawned_resources.size())
	
	# Add to scene
	get_tree().current_scene.add_child(resource_node)
	spawned_resources.append(resource_node)
	
	print("💎 Spawned ", resource_type, " at ", position)

func select_resource_type() -> String:
	var rand = randf()
	var cumulative_chance = 0.0
	
	for resource in resource_types:
		cumulative_chance += resource_types[resource]["chance"]
		if rand <= cumulative_chance:
			return resource
	
	return "wood"  # Fallback

func get_random_spawn_position() -> Vector3:
	var angle = randf() * 2 * PI
	var distance = randf() * spawn_radius
	
	var x = cos(angle) * distance
	var z = sin(angle) * distance
	
	return Vector3(x, 1, z)

func create_resource_node(resource_type: String) -> Node3D:
	var resource_node = StaticBody3D.new()
	
	# Add mesh
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = BoxMesh.new()
	
	# Set color based on resource type
	var material = StandardMaterial3D.new()
	match resource_type:
		"wood":
			material.albedo_color = Color(0.6, 0.4, 0.2)
		"stone":
			material.albedo_color = Color(0.5, 0.5, 0.5)
		"metal":
			material.albedo_color = Color(0.7, 0.7, 0.8)
		"crystal":
			material.albedo_color = Color(0.8, 0.2, 0.8)
		"magic_dust":
			material.albedo_color = Color(1.0, 1.0, 0.0)
	
	mesh_instance.material_override = material
	resource_node.add_child(mesh_instance)
	
	# Add collision
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	collision.shape = shape
	resource_node.add_child(collision)
	
	# Add interaction area
	var interaction_area = Area3D.new()
	var interaction_collision = CollisionShape3D.new()
	var interaction_shape = BoxShape3D.new()
	interaction_shape.size = Vector3(2, 2, 2)
	interaction_collision.shape = interaction_shape
	interaction_area.add_child(interaction_collision)
	resource_node.add_child(interaction_area)
	
	# Add script for interaction
	var script = GDScript.new()
	script.source_code = """
extends StaticBody3D

var resource_type: String = \"""" + resource_type + """\"
var amount: int = 1

func interact(kid: KidCharacter):
	if kid:
		kid.add_material(resource_type, amount)
		print("📦 Collected ", amount, " ", resource_type, "!")
		queue_free()
"""
	resource_node.set_script(script)
	
	return resource_node

func cleanup_old_resources():
	# Remove resources that are too far from the center
	for i in range(spawned_resources.size() - 1, -1, -1):
		var resource = spawned_resources[i]
		if resource and is_instance_valid(resource):
			var distance = resource.global_position.distance_to(Vector3.ZERO)
			if distance > spawn_radius * 1.5:
				resource.queue_free()
				spawned_resources.remove_at(i)
