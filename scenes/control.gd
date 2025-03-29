extends Control  # Or use Panel, TextureRect, etc.

func _ready():
	print("Control Node is Ready!")
	mouse_filter = Control.MOUSE_FILTER_STOP  # Ensures it captures clicks

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Clicked on Control Node!")
