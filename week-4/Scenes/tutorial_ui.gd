extends CanvasLayer


@onready var instructions=$Instructions

func _ready():
	instructions.text="Welcome to The Ascent! Press F to split."
func show_instructions(message:String):
	instructions.text=message
