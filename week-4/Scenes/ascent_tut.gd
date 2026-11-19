extends "res://Scenes/base_level.gd"


@onready var tutorial_ui=$TutorialUI
@onready var plate1=$Pressureplate
@onready var plate2=$Pressureplate3

var stage=0
var start_position:Vector2

func _ready():
	super._ready()
	start_position=player.global_position
	tutorial_ui.show_instructions("Welcome to The Ascent! Press F to split.")
func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		super._physics_process(delta)
		return
	super._physics_process(delta)
	match stage:
		0:
			if split:
				next_stage("Move a clone onto the first pressure plate.")
		1:
			if plate1.activated:
				next_stage("Select Blue with TAB. Hold E+W/S on the blue\nsurface to climb.")
		2:
			if split and clone1.climbing and clone1.velocity.y<0:
				next_stage("Climb higher! Hold E and use A/D to move sideways\nonto a ledge")
		3:
			if split and clone1.is_on_floor() and not clone1.can_climb_here():
				next_stage("Select Orange with TAB and help\nwith Blue to get through. Hold E + W on\nthe orange surface.")
		4:
			if split and clone2.climbing and clone2.velocity.y<0:
				next_stage("Help Blue reach the upper blue pressure\nplate to open the next door.")
		5:
			if plate2.activated:
				next_stage("Move Orange through the open\ndoor. Bring the clones close and press F to\nreunite. Reach the exit.")
func next_stage(message:String):
	stage+=1
	tutorial_ui.show_instructions(message)
