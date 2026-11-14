extends Node2D


@onready var player=$Player
@onready var clone1=$Clone1
@onready var clone2=$Clone2
@onready var tutorial=$TutorialUI
@onready var plate=$Pressureplate
@onready var door=$Door

var split=false
var active_clone=1
var tutorial_stage=0

@export var unite_distance=200

func _ready():
	player.show()
	player.set_physics_process(true)
	clone1.hide()
	clone2.hide()
	clone1.process_mode=Node.PROCESS_MODE_DISABLED
	clone2.process_mode=Node.PROCESS_MODE_DISABLED
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone1.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", true)
func _process(_delta):
	if Input.is_action_just_pressed("split"):
		if not split:
			split_player()
		else:
			try_unite()
	if Input.is_action_just_pressed("change_character") and split:
		switch_clone()
	check_tutorial()
func split_player():
	split=true
	clone1.global_position = player.global_position + Vector2(-20, 0)
	clone2.global_position = player.global_position + Vector2(20, 0)
	player.hide()
	player.set_physics_process(false)
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone1.show()
	clone2.show()
	clone1.process_mode=Node.PROCESS_MODE_INHERIT
	clone2.process_mode=Node.PROCESS_MODE_INHERIT
	clone1.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", false)
	active_clone=1
	clone1.active=true
	clone2.active=false
func switch_clone():
	if active_clone==1:
		active_clone=2
		clone1.active=false
		clone2.active=true
	else:
		active_clone=1
		clone1.active=true
		clone2.active=false
func try_unite():
	var distance=clone1.global_position.distance_to(clone2.global_position)
	if distance<=unite_distance:
		unite()
func unite():
	split=false
	var middle_position=(clone1.global_position+clone2.global_position)/2
	clone1.active=false
	clone2.active=false
	clone1.hide()
	clone2.hide()
	clone1.process_mode=Node.PROCESS_MODE_DISABLED
	clone2.process_mode=Node.PROCESS_MODE_DISABLED
	clone1.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", true)
	player.global_position=middle_position
	player.show()
	player.set_physics_process(true)
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
func update_tutorial():
	match tutorial_stage:
		0:
			tutorial.show_instructions("Press A and D to move")
		1:
			tutorial.show_instructions("Press SPACE/W to jump")
		2:
			tutorial.show_instructions("Press F to split")
		3:
			tutorial.show_instructions("Press TAB to switch between clones")
		4:
			tutorial.show_instructions("Move one colne to the presure plate")
		5:
			tutorial.show_instructions("Move the other clone through the door")
		6:
			tutorial.show_instructions("Bring your clones close to each other and press F")
		7:
			tutorial.show_instructions("Tutorial complete!")
func next_stage():
	tutorial_stage+=1
	update_tutorial()
func check_tutorial():
	match tutorial_stage:
		0:
			if Input.get_axis("left", "right") != 0:
				next_stage()
		1:
			if player.velocity.y<0 and not split:
				next_stage()
		2:
			if split:
				next_stage()
		3:
			if active_clone==2 and split:
				next_stage()
		4:
			if plate.activated and split:
				next_stage()
		5:
			if split and door.open:
				if clone1.global_position.x>door.global_position.x+30 or clone2.global_position.x>door.global_position.x+30:
					next_stage()
		6:
			if not split:
				next_stage()
