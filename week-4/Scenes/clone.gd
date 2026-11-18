extends CharacterBody2D


@export var speed=300
@export var jump_velocity=-550
@export var climb_speed=180

var gravity=900
var active=false
var climbing=false

@onready var indicator=$Indicator

func _physics_process(delta):
	indicator.visible=active
	var near_surface=can_climb_here()
	if active:
		climbing=near_surface and Input.is_action_pressed("climb")
	elif not near_surface:
		climbing=false
	if climbing:
		velocity=Vector2.ZERO
		if active:
			velocity.y=Input.get_axis("climb_up","climb_down")*climb_speed
			velocity.x=Input.get_axis("left","right")*speed
	else:
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
func can_climb_here()->bool:
	var climb_group=""
	if name=="Clone1":
		climb_group="blue_climb"
	elif name=="Clone2":
		climb_group="orange_climb"
	else:
		return false
	for surface in get_tree().get_nodes_in_group(climb_group):
		if surface is Area2D and surface.overlaps_body(self):
			return true
	return false
