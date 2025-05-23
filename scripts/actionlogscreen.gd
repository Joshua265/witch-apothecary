extends Control

var action_log: Array = [] 
@export var action_list_node: VBoxContainer

func _ready() -> void:
	GameState.result_scene = self
	update_action_log()

func update_action_log() -> void:
	# Clear existing items from the VBoxContainer
	for child in action_list_node.get_children():
		child.queue_free()
		
	if action_log.is_empty():
		var no_actions_label = Label.new()
		no_actions_label.text = "No actions taken"
		action_list_node.add_child(no_actions_label)
	else:
		for action in action_log:
			var label = Label.new()
			label.text = action
			action_list_node.add_child(label)

func set_action_log(new_log: Array) -> void:
	action_log = new_log
	print("Action log updated.")
