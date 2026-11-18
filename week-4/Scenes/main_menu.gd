extends Control


@onready var play_button=$MenuButtons/Play
@onready var tutorial_button=$MenuButtons/Tutuorial
@onready var exit_button=$MenuButtons/Exit
@onready var ascent_button=$MenuButtons/Ascent

func _ready():
	play_button.pressed.connect(start_game)
	tutorial_button.pressed.connect(start_tutorial)
	exit_button.pressed.connect(exit_game)
	ascent_button.pressed.connect(start_ascent)
func start_game():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
func start_tutorial():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
func exit_game():
	get_tree().quit()
func start_ascent():
	get_tree().change_scene_to_file("res://Scenes/ascent1.tscn")
