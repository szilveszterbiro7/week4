extends StaticBody2D

@onready var collision=$CollisionShape2D
@onready var door=$ColorRect

var open=false
var active_plates=[]

func activate_plate(plate):
	if not active_plates.has(plate):
		active_plates.append(plate)
	update_door()
func deactivate_plate(plate):
	active_plates.erase(plate)
	update_door()
func update_door():
	if active_plates.size()>0:
		open_door()
	else:
		close_door()
func open_door():
	open=true
	collision.set_deferred("disabled", true)
	door.hide()
func close_door():
	open=false
	collision.set_deferred("disabled", false)
	door.show()
