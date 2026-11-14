extends Area2D


@export var next_scene: PackedScene

@onready var label=$Label

var transitioning=false

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
func on_body_entered(body):
	if body is CharacterBody2D and not transitioning:
		label.text="EXIT"
	if transitioning:
		return
	if body.name=="Player":
		if next_scene!=null:
			transitioning=false
			get_tree().call_deferred("change_scene_to_packed", next_scene)
		else:
			label.text="Level\ncomplete!"
	elif body.name=="Clone1" or body.name=="Clone2":
		label.text="Reunite\nfirst!"
func on_body_exited(body):
	if body is CharacterBody2D and not transitioning:
		label.text="EXIT"
