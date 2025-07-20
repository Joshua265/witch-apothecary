extends HBoxContainer
class_name AcionCounter

var action_icon_texture = preload("res://sprites/ui/action.png")

func _ready():
	GameState.action_counter_manager.connect("action_counter_updated", Callable(self, "_on_action_counter_updated"))

func _on_action_counter_updated(_available: int, remaining: int):
	print("ActionCounter: Available actions:", _available, "Remaining actions:", remaining)
	for child in get_children():
		if child is TextureRect:
			child.queue_free()  # Remove existing iconsw

	for i in range(remaining):
		var icon = TextureRect.new()
		icon.texture = action_icon_texture
		icon.expand_mode = TextureRect.ExpandMode.EXPAND_FIT_WIDTH
		icon.stretch_mode = TextureRect.StretchMode.STRETCH_SCALE
		self.add_child(icon)
