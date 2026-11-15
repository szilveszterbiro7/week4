extends Control


@onready var main_menu_button=$MenuButtons/MainMenu
@onready var exit_button=$MenuButtons/Exit

func _ready():
	main_menu_button.pressed.connect(main_menu)
	exit_button.pressed.connect(exit_game)
func main_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
func exit_game():
	get_tree().quit()
