extends CanvasLayer


@onready var panel_root=$PanelRoot
@onready var resume_button=$PanelRoot/Buttons/Resume
@onready var restart_button=$PanelRoot/Buttons/Restart
@onready var menu_button=$PanelRoot/Buttons/MainMenu

func _ready():
	panel_root.hide()
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(restart)
	menu_button.pressed.connect(backmenu)
func _input(event):
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		if get_tree().paused:
			resume()
		else:
			pause()
func pause():
	panel_root.show()
	get_tree().paused=true
	resume_button.grab_focus()
func resume():
	get_tree().paused=false
	panel_root.hide()
func restart():
	resume()
	get_tree().reload_current_scene()
func backmenu():
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
