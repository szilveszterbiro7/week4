extends Area2D


@onready var visual=$ColorRect
@onready var timer=$Timer

@export var door:StaticBody2D
@export var duration:float=5.0

var activated=false
var label:Label

func _ready():
	body_entered.connect(on_body_entered)
	timer.timeout.connect(on_timeout)
	timer.one_shot=true
	visual.color=Color.PURPLE
	if door!=null:
		label=door.get_node("TimerLabel")
		label.text=str(duration)
		label.show()
func on_body_entered(body):
	if body is CharacterBody2D:
		activated=true
		visual.color=Color.GREEN
		timer.start(duration)
		if door!=null:
			door.activate_plate(self)
func on_timeout():
	activated=false
	visual.color=Color.PURPLE
	if label!=null:
		label.text=str(duration)
	if door!=null:
		door.deactivate_plate(self)
func _process(_delta):
	if activated and label!=null:
		label.text="%.1f"%timer.time_left
