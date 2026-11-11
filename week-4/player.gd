extends CharacterBody2D


@export var speed=200.0
@export var jump_velocity=-350.0

var gravity=900

func _physics_process(delta):
	if not is_on_floor():
		velocity.y+=gravity*delta
	var direction=Input.get_axis("left", "right")
	velocity.x=direction*speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y=jump_velocity
	move_and_slide()
	print("On floor: ", is_on_floor(), " | Position: ", global_position)
