extends CanvasLayer


@onready var instructions=$Instructions

func _ready():
	instructions.text="Press A and D to move"
func show_instructions(message:String):
	instructions.text=message
