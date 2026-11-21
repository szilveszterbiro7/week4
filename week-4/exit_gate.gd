extends Area2D


@export var next_scene: PackedScene

@onready var label=$Label

var transitioning=false
var complete_sound=preload("res://Assets/Sounds/complete.mp3")
var complete_audio:AudioStreamPlayer

func _ready():
	complete_audio=AudioStreamPlayer.new()
	complete_audio.stream=complete_sound
	complete_audio.volume_db=-12
	add_child(complete_audio)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
func on_body_entered(body):
	if body is CharacterBody2D and not transitioning:
		label.text="EXIT"
	if transitioning:
		return
	if body.name=="Player":
		transitioning=true
		label.text="Level\ncomplete!"
		body.set_physics_process(false)
		complete_audio.play()
		await complete_audio.finished
		if next_scene!=null:
			get_tree().call_deferred("change_scene_to_packed", next_scene)
		else:
			body.set_physics_process(true)
			transitioning=false
	elif body.name=="Clone1" or body.name=="Clone2":
		label.text="Reunite\nfirst!"
func on_body_exited(body):
	if body is CharacterBody2D and not transitioning:
		label.text="EXIT"
