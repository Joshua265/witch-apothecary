extends TextureButton

func _on_mouse_entered():
	$AnimationPlayer.play("hover_enter")

func _on_mouse_exited():
	$AnimationPlayer.play("hover_exit")
