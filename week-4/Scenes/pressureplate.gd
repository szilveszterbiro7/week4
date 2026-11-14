extends Area2D


@onready var visual=$ColorRect

var activated=false
var bodies_on_plate=[]

@export var door:StaticBody2D

func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
func on_body_entered(body):
	if body is CharacterBody2D:
		bodies_on_plate.append(body)
		update_plate()
func on_body_exited(body):
	if body is CharacterBody2D:
		bodies_on_plate.erase(body)
		update_plate()
func update_plate():
	activated=bodies_on_plate.size()>0
	if activated:
		visual.color=Color.GREEN
		if door!=null:
			door.open_door()
	else:
		visual.color=Color.RED
		if door!=null:
			door.close_door()
