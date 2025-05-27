extends TextureButton

var locked: bool

func _ready() -> void:
	locked = self.get_meta("locked", true)
	if locked:
		var lock_texture = self.get_node("Lock")
		lock_texture.visible = true
		self.modulate = Color(0.5,0.5,0.5,1.0) # Dim the button color
	else:
		self.get_node("HBoxContainer").update_hats(self.get_meta("index"))

func _on_mouse_entered():
	if not locked:
		$AnimationPlayer.play("hover_enter")

func _on_mouse_exited():
	if not locked:
		$AnimationPlayer.play("hover_exit")
