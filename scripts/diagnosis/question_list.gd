extends VBoxContainer

# load the dialogue resource
signal question_selected(question_text)

var resource = null

func _ready():
	GameState.action_manager.connect("load_questions", Callable(self, "_on_load_questions"))
	DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_finished"))


func _on_load_questions(question_set_script: String):
	resource = ResourceLoader.load(question_set_script)
	print("Loaded resource lines keys:", resource.lines.keys())
	print("Loaded resource titles:", resource.titles)
	clear_questions()
	_generate_question_buttons();

func clear_questions():
	# Clear existing buttons
	for child in get_children():
		if child is Button:
			child.queue_free()

func _generate_question_buttons():
	var actions = GameState.action_manager.get_available_actions()
	print("Generating question buttons with actions:", actions)
	actions = actions.filter(
		func(action_id: String) -> bool:
			return GameState.action_manager.get_action(action_id).type == "question"
	)
	print("Filtered question actions:", actions)
	for action_id in actions:
		var action_data: ActionData = GameState.action_manager.get_action(action_id)
		var button := Button.new()
		button.text = action_data.button_text
		button.tooltip_text = action_data.button_text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): _on_question_pressed(action_id))
		add_child(button)

func _on_question_pressed(action_id: String):
	GameState.set_diagnosis_state(GameState.DiagnosisState.DIALOGUE)
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, action_id)
	DialogueManager.show_dialogue_balloon(
		resource,
		dialogue_line.next_id,
	)
	# add the string to the action log!
	GameState.action_manager.use_action(action_id)
	question_selected.emit(action_id)  # Emit signal to Diagnosis to hide UI

# This should be called when the dialogue balloon is finished/closed
func _on_dialogue_finished(_resource: DialogueResource):
	GameState.set_diagnosis_state(GameState.DiagnosisState.DEFAULT)
