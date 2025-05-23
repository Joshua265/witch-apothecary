extends Control

@export var action_list_node: VBoxContainer

func _ready() -> void:
	GameState.result_scene = self
	update_action_log()

func update_action_log() -> void:
	# Clear existing items from the VBoxContainer
	for child in action_list_node.get_children():
		child.queue_free()
	
	var action_log = GameState.action_log	
	if action_log.is_empty():
		var no_actions_label = Label.new()
		no_actions_label.text = "No actions taken"
		action_list_node.add_child(no_actions_label)
	else:
		for action in action_log:
			var label = Label.new()
			label.text = action
			action_list_node.add_child(label)

#todo: Use this to navigate to Level overview
func _on_button_pressed() -> void:
	var main_menu_scene : PackedScene = load("res://scenes/samples/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu_scene)
