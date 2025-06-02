extends Control

@export var ask_button: Button
@export var inspect_button: Button
@export var diagnose_button: Button
@export var back_button: Button
@export var question_list: ScrollContainer
@export var inspect_list: ScrollContainer
@export var ui_container: Control
@export var main_action_container: HBoxContainer
@export var character: TextureRect
@export var background: TextureRect
@export var clipboard: Panel

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

	# --- Patient spawn logic ---
	# Get current level index from LevelManager
	var level_index = GameState.level_manager.current_level
	# Connect to patient_loaded signal if not already
	if not GameState.patient_manager.patient_loaded.is_connected(Callable(self, "_on_patient_loaded")):
		GameState.patient_manager.patient_loaded.connect(Callable(self, "_on_patient_loaded"))
	# Request patient load for this level
	GameState.patient_manager.load_patient(level_index)

func _on_patient_loaded(patient_data):
	# Set patient data on the character node and update image
	character.patient = patient_data
	character.update_patient_image()

func _on_ask_pressed():
	main_action_container.hide()
	question_list.show()
	back_button.show()
	emit_signal("ask_pressed")

func _on_inspect_pressed():
	main_action_container.hide()
	inspect_list.show()
	back_button.show()
	emit_signal("inspect_pressed")

func _on_back_pressed():
	main_action_container.show()
	question_list.hide()
	inspect_list.hide()
	back_button.hide()
	emit_signal("back_pressed")

func _on_question_selected(next_id:String):
	question_list.hide()
	back_button.hide()
	clipboard.hide()
	emit_signal("question_selected", next_id)

func _on_diagnose_pressed():
	emit_signal("diagnose_pressed")
