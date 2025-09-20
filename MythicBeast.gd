extends Node3D

@export var beast_type: String = "dragon"
@export var move_speed: float = 3.5

func _process(delta):
	rotate_y(deg_to_rad(30.0) * delta)  # Rotates the creature slowly
