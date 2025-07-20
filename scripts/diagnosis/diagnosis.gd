extends Control

var ask_button: Button
var inspect_button: Button
var diagnose_button: Button
var back_button: Button
var question_list: ScrollContainer
var inspect_list: ScrollContainer
var main_action_container: HBoxContainer
var background: TextureRect
var clipboard: Clipboard
var action_counter: HBoxContainer

signal ask_pressed
signal inspect_pressed
signal diagnose_pressed
signal back_pressed
signal question_selected(next_id: String)
signal diagnosis_scene_ready

var resource = null

func _ready():
	connect("diagnosis_scene_ready", Callable(GameState, "_on_diagnosis_scene_ready"))
	emit_signal("diagnosis_scene_ready")

	# Listen for diagnosis state changes
	if not GameState.diagnosis_state_changed.is_connected(Callable(self, "_on_diagnosis_state_changed")):
		GameState.diagnosis_state_changed.connect(Callable(self, "_on_diagnosis_state_changed"))

	ask_button = $Interaction/ScrollContainer/ActionButtonsContainer/MainActions/Dialogue_Button
	inspect_button = $Interaction/ScrollContainer/ActionButtonsContainer/MainActions/Inspect_Button
	back_button = $Interaction/ScrollContainer/ActionButtonsContainer/Back_Button
	diagnose_button = $Interaction/ScrollContainer/ActionButtonsContainer/MainActions/Diagnose_Button
	question_list = $Interaction/ScrollContainer/ActionButtonsContainer/Dialogue_Section/ScrollContainer
	inspect_list = $Interaction/ScrollContainer/ActionButtonsContainer/Inspect_Section/ScrollContainer
	main_action_container = $Interaction/ScrollContainer/ActionButtonsContainer/MainActions
	background = $Background
	clipboard = $Interaction/Clipboard
	action_counter = $ActionCounter


	# Connect buttons safely
	if not ask_button.pressed.is_connected(Callable(self, "_on_ask_pressed")):
		ask_button.pressed.connect(Callable(self, "_on_ask_pressed"))

	if not inspect_button.pressed.is_connected(Callable(self, "_on_inspect_pressed")):
		inspect_button.pressed.connect(Callable(self, "_on_inspect_pressed"))

	if not back_button.pressed.is_connected(Callable(self, "_on_back_pressed")):
		back_button.pressed.connect(Callable(self, "_on_back_pressed"))

	if not diagnose_button.pressed.is_connected(Callable(self, "_on_diagnose_pressed")):
		diagnose_button.pressed.connect(Callable(self, "_on_diagnose_pressed"))

	# Connect question buttons
	for question_button in question_list.get_children():
		if question_button is Button:
			if not question_button.pressed.is_connected(_on_question_selected):
				question_button.pressed.connect(_on_question_selected.bind(question_button.text))

	# Initially hide irrelevant UI elements
	question_list.hide()
	inspect_list.hide()
	back_button.hide()

func set_resource(new_resource):
	resource = new_resource

func _on_ask_pressed():
	GameState.set_diagnosis_state(GameState.DiagnosisState.ASKING)
	emit_signal("ask_pressed")

func _on_inspect_pressed():
	GameState.set_diagnosis_state(GameState.DiagnosisState.INSPECTING)
	emit_signal("inspect_pressed")

func _on_back_pressed():
	GameState.set_diagnosis_state(GameState.DiagnosisState.DEFAULT)
	emit_signal("back_pressed")

func _on_question_selected(_next_id:String):
	GameState.set_diagnosis_state(GameState.DiagnosisState.DIALOGUE)
	emit_signal("question_selected", _next_id)

func _on_diagnose_pressed():
	emit_signal("diagnose_pressed")

# Respond to diagnosis state changes
func _on_diagnosis_state_changed(new_state):
	print("Diagnosis state changed to: ", new_state)
	if new_state == GameState.DiagnosisState.ASKING:
		# Hide all main UI elements
		main_action_container.hide()
		question_list.show()
		back_button.show()
	elif new_state == GameState.DiagnosisState.DEFAULT:
		# Restore default UI state
		main_action_container.show()
		question_list.hide()
		inspect_list.hide()
		back_button.hide()
		clipboard.show()
		action_counter.show()
	elif new_state == GameState.DiagnosisState.DIALOGUE:
		# Hide question list and back button
		question_list.hide()
		back_button.hide()
		clipboard.hide()
		action_counter.hide()
	elif new_state == GameState.DiagnosisState.INSPECTING:
		main_action_container.hide()
		inspect_list.show()
		back_button.show()
	elif new_state == GameState.DiagnosisState.NO_ACTIONS:
		ask_button.disabled = true
		inspect_button.disabled = true
		
		# Optional: Also visually grey them out for better feedback
		#ask_button.modulate = Color(0.5, 0.5, 0.5, 1.0)
		#inspect_button.modulate = Color(0.5, 0.5, 0.5, 1.0)
		
