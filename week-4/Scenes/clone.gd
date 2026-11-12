extends CharacterBody2D


@export var speed=200
@export var jump_velocity=-550

var gravity=900
var active=false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y+=gravity*delta
	if active:
		var direction=Input.get_axis("left", "right")
		velocity.x=direction*speed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y=jump_velocity
	else:
		velocity.x=0
	move_and_slide()
