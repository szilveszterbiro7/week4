extends Area2D


@onready var visual=$ColorRect

var activated=false
var bodies_on_plate=[]
var press_sound=preload("res://Assets/Sounds/plate.mp3")
var plate_audio:AudioStreamPlayer

@export var door:StaticBody2D

enum PlateType {ANY, BLUE, ORANGE}
@export var plate_type:PlateType=PlateType.ANY
func _ready():
	plate_audio=AudioStreamPlayer.new()
	plate_audio.stream=press_sound
	plate_audio.volume_db=-12
	add_child(plate_audio)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	visual.color=plate_color()
func on_body_entered(body):
	if can_activate(body):
		bodies_on_plate.append(body)
		update_plate()
func on_body_exited(body):
	if body in bodies_on_plate:
		bodies_on_plate.erase(body)
		update_plate()
func update_plate():
	var was_activated=activated
	activated=bodies_on_plate.size()>0
	if activated and not was_activated:
		plate_audio.play()
	if activated:
		visual.color=Color.GREEN
		if door!=null:
			door.activate_plate(self)
	else:
		visual.color=plate_color()
		if door!=null:
			door.deactivate_plate(self)
func can_activate(body):
	if not body is CharacterBody2D:
		return false
	if plate_type==PlateType.ANY:
		return true
	elif plate_type==PlateType.BLUE:
		return body.name=="Clone1"
	elif plate_type==PlateType.ORANGE:
		return body.name=="Clone2"
	return false
func plate_color():
	if plate_type==PlateType.BLUE:
		return Color.DODGER_BLUE
	elif plate_type==PlateType.ORANGE:
		return Color.ORANGE
	return Color.RED
