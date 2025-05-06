extends Node

@export var action_container : HBoxContainer
@export var action_icon_texture : Texture2D
signal action_used

var actions_remaining: int = 10

#todo: Do it with gridlayout or something instead so it doesnt try to match the size of the container when removing
func _ready():
	if action_container:
		for i in range(actions_remaining):
			var icon = TextureRect.new()
			icon.texture = action_icon_texture
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			action_container.add_child(icon)

func use_action():
	if actions_remaining > 0:
		actions_remaining -= 1
		print("Actions remaining: ", actions_remaining)

		# Remove the last icon
		var icon_count = action_container.get_child_count()
		if icon_count > 0:
			action_container.get_child(icon_count - 1).queue_free()
			print("Removing icon")

		if actions_remaining == 0:
			print("No more actions left — no more points can be earned.")
	else:
		print("You're out of actions — no more points available.")
