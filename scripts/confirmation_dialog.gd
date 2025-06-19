extends Panel

signal yes_confirmation_dialog()
signal no_confirmation_dialog()

func _ready() -> void:
	self.hide()

func _on_open_dialog(text: String):
	$VBoxContainer/Label.text = text
	self.show()
	self.grab_focus()

func _on_yes_pressed():
	emit_signal("yes_confirmation_dialog")
	self.hide()

func _on_no_pressed():
	emit_signal("no_confirmation_dialog")
	self.hide()
