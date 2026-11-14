extends StaticBody2D

@onready var collision=$CollisionShape2D
@onready var door=$ColorRect

var open=false

func open_door():
	open=true
	collision.set_deferred("disabled", true)
	door.hide()
func close_door():
	open=false
	collision.set_deferred("disabled", false)
	door.show()
