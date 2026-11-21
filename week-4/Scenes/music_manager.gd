extends Node


var music=preload("res://Assets/Sounds/music.mp3")
var music_player:AudioStreamPlayer

func _ready():
	music_player=AudioStreamPlayer.new()
	music_player.stream=music
	music_player.volume_db=-22
	add_child(music_player)
	music_player.play()
