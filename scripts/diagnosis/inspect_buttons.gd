extends VBoxContainer

func _ready():
	GameState.action_manager.connect("load_inspections", Callable(self, "_on_load_inspections"))

func _on_load_inspections():
	print("Generating inspection buttons...")
	# Clear existing buttons
	for child in get_children():
		if child is Button:
			child.queue_free()

	# Generate inspection buttons
	_generate_inspect_buttons()


func _generate_inspect_buttons():
	var actions = GameState.action_manager.get_available_actions()
	actions = actions.filter(
		func(action_id: String) -> bool:
			return GameState.action_manager.get_action(action_id).type == "inspection"
	)

	for action in actions:
		var button = Button.new()
		button.text = GameState.action_manager.get_action(action).button_text
		add_child(button)
		button.pressed.connect(
			func() -> void:
				var action_available = GameState.action_manager.use_action(action)
				if not action_available:
					return
				GameState.clipboard_manager.inspect_field(action)
				GameState.set_diagnosis_state(GameState.DiagnosisState.DEFAULT) # Here is prop the place to add any animations
		)
		button.tooltip_text = GameState.action_manager.get_action(action).button_text
