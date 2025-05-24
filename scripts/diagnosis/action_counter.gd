extends Node

@export var action_container : HBoxContainer
@export var action_icon_texture : Texture2D
signal action_used

func _ready():
	if action_container:
		for i in range(GameState.actions_remaining):
			var icon = TextureRect.new()
			icon.texture = action_icon_texture
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			action_container.add_child(icon)

func use_action():
	if GameState.actions_remaining > 0:
		GameState.actions_remaining -= 1

		# Remove the last icon
		var icon_count = action_container.get_child_count()
		if icon_count > 0:
			action_container.get_child(icon_count - 1).queue_free()
			print("Removing icon")
		#todo: Info for user!
		if GameState.actions_remaining == 0:
			print("No more actions left — no more points can be earned.")
				
func add_action_log(action: String):
	GameState.add_action_log(action)
	
