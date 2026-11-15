extends "res://Scenes/base_level.gd"


@onready var tutorial_ui=$TutorialUI
@onready var plate1=$Pressureplate
@onready var plate2=$Pressureplate2
@onready var door=$Door

var stage=0
var start_position:Vector2

func _ready():
	super._ready()
	start_position=player.global_position
	tutorial_ui.show_instructions("Press A and D to move")
func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		super._physics_process(delta)
		return
	super._physics_process(delta)
	match stage:
		0:
			if abs(player.global_position.x-start_position.x)>50:
				next_stage("Press SPACE to jump")
		1:
			if player.velocity.y < 0:
				next_stage("Press F to split yourself")
		2:
			if split:
				next_stage("Press TAB to switch characters")
		3:
			if split and active_clone==2:
				next_stage("Move a clone onto the first pressure plate")
		4:
			if plate1.activated:
				next_stage("Move the other clone through the door")
		5:
			if plate1.activated:
				next_stage("Move the other clone through the door")
		6:
			if split:
				var door_x=door.get_node("CollisionShape2D").global_position.x
				var blue_x=clone1.get_node("CollisionShape2D").global_position.x
				var orange_x=clone2.get_node("CollisionShape2D").global_position.x
				if blue_x>door_x+50 and orange_x>door_x+50:
					next_stage("Bring the clones together and press F")
		7:
			if not split:
				next_stage("Great! Walk to the exit!")
func next_stage(message:String):
	stage+=1
	tutorial_ui.show_instructions(message)
func update_camera():
	player_camera.enabled=false
	clone1_camera.enabled=false
	clone2_camera.enabled=false
