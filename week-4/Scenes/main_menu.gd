extends Control


@onready var play_button=$MenuButtons/Play
@onready var tutorial_button=$MenuButtons/Tutuorial
@onready var exit_button=$MenuButtons/Exit
@onready var ascent_button=$MenuButtons/Ascent
@onready var settings_button=$MenuButtons/Settings
@onready var settings_panel=$SettingsPanel
@onready var brightness_slider=$SettingsPanel/Options/BrightnessSlider
@onready var music_slider=$SettingsPanel/Options/MusicSlider
@onready var close_settings_button=$SettingsPanel/Close
@onready var controls_button=$SettingsPanel/Options/Controls
@onready var controls_panel=$SettingsPanel/ControlsPanel
@onready var controls_back_button=$SettingsPanel/ControlsPanel/Back

func _ready():
	controls_panel.hide()
	controls_button.pressed.connect(open_controls)
	controls_back_button.pressed.connect(close_controls)
	play_button.pressed.connect(start_game)
	tutorial_button.pressed.connect(start_tutorial)
	exit_button.pressed.connect(exit_game)
	ascent_button.pressed.connect(start_ascent)
	settings_panel.hide()
	brightness_slider.value=MusicManager.brightness
	music_slider.value=MusicManager.music_volume
	settings_button.pressed.connect(open_settings)
	close_settings_button.pressed.connect(close_settings)
	brightness_slider.value_changed.connect(MusicManager.set_brightness)
	music_slider.value_changed.connect(MusicManager.set_music_volume)
func start_game():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
func start_tutorial():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
func exit_game():
	get_tree().quit()
func start_ascent():
	get_tree().change_scene_to_file("res://Scenes/ascent1.tscn")
func open_settings():
	$MenuButtons.hide()
	settings_panel.show()
func close_settings():
	settings_panel.hide()
	$MenuButtons.show()
func open_controls():
	$SettingsPanel/Options.hide()
	close_settings_button.hide()
	controls_panel.show()
func close_controls():
	controls_panel.hide()
	close_settings_button.show()
	$SettingsPanel/Options.show()
