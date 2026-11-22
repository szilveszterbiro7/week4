extends Node


var music=preload("res://Assets/Sounds/music.mp3")
var music_player:AudioStreamPlayer
var music_volume=0.5
var brightness=1
var brightness_overlay:ColorRect

func _ready():
	music_player=AudioStreamPlayer.new()
	music_player.stream=music
	music_player.volume_db=-22
	add_child(music_player)
	set_music_volume(music_volume)
	music_player.play()
	var overlay_layer=CanvasLayer.new()
	overlay_layer.layer=100
	add_child(overlay_layer)
	brightness_overlay=ColorRect.new()
	brightness_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	brightness_overlay.mouse_filter=Control.MOUSE_FILTER_IGNORE
	overlay_layer.add_child(brightness_overlay)
	set_brightness(brightness)
func set_music_volume(value: float):
	music_volume=clampf(value,0,1)
	if music_player!=null:
		music_player.volume_linear=music_volume*0.2
func set_brightness(value:float):
	brightness=clampf(value,0.5,1.5)
	if brightness_overlay==null:
		return
	if brightness<=1:
		brightness_overlay.color=Color(0,0,0,1-brightness)
	else:
		brightness_overlay.color=Color(1, 1, 1, (brightness - 1)*0.5)
