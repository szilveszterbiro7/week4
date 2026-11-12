extends Node2D


@onready var player=$Player
@onready var clone1=$Clone1
@onready var clone2=$Clone2

var split=false
var active_clone=1

func _ready():
	player.show()
	player.set_physics_process(true)
	clone1.hide()
	clone2.hide()
	clone1.process_mode=Node.PROCESS_MODE_DISABLED
	clone2.process_mode=Node.PROCESS_MODE_DISABLED
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone1.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", true)
func _process(_delta):
	if Input.is_action_just_pressed("split") and not split:
		split_player()
	if Input.is_action_just_pressed("change_character") and split:
		switch_clone()
func split_player():
	split=true
	clone1.global_position = player.global_position + Vector2(-20, 0)
	clone2.global_position = player.global_position + Vector2(20, 0)
	player.hide()
	player.set_physics_process(false)
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone1.show()
	clone2.show()
	clone1.process_mode=Node.PROCESS_MODE_INHERIT
	clone2.process_mode=Node.PROCESS_MODE_INHERIT
	clone1.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", false)
	active_clone=1
	clone1.active=true
	clone2.active=false
func switch_clone():
	if active_clone==1:
		active_clone=2
		clone1.active=false
		clone2.active=true
	else:
		active_clone=1
		clone1.active=true
		clone2.active=false
