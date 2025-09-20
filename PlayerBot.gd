extends CharacterBody3D

@export var speed = 5.0

func _physics_process(delta):
	var dir = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.z += 1
	if Input.is_action_pressed("ui_up"):
		dir.z -= 1
	velocity = dir.normalized() * speed
	move_and_slide()
