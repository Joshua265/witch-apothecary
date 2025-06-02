extends Panel

signal open_confirmation_dialog(text: String)
signal yes_confirmation_dialog()
signal no_confirmation_dialog()

func _ready() -> void:
	connect("open_confirmation_dialog", _on_open_dialog)
	self.hide()
	
func _on_open_dialog(text: String):
	$Label.text = text
	$yes.pressed.connect(_on_yes_pressed)
	$no.pressed.connect(_on_no_pressed)
	self.show()

func _on_yes_pressed():
	emit_signal("yes_confirmation_dialog")
	self.hide()

func _on_no_pressed():
	emit_signal("no_confirmation_dialog")
	self.hide()
