extends Node

var level_manager: Node
var patient_manager: Node
var score_manager: Node
var inspection_manager: Node
var bok_manager: Node

# Scenes
var diagnosis_scene = null
var cutscene_scene = null
var result_scene = null

func _ready() -> void:
	# Instantiate managers
	level_manager = preload("res://scripts/LevelManager.gd").new()
	patient_manager = preload("res://scripts/PatientManager.gd").new()
	score_manager = preload("res://scripts/ScoreManager.gd").new()
	inspection_manager = preload("res://scripts/InspectionManager.gd").new()
	bok_manager = preload("res://scripts/BoKManager.gd").new()

	# Add managers as children for lifecycle management
	add_child(level_manager)
	add_child(patient_manager)
	add_child(score_manager)
	add_child(inspection_manager)
	add_child(bok_manager)

	# Connect signals
	level_manager.connect("level_changed", Callable(self, "_on_level_changed"))
	patient_manager.connect("patient_changed", Callable(self, "_on_patient_changed"))
	inspection_manager.connect("action_log_updated", Callable(self, "_on_action_log_updated"))
	inspection_manager.connect("actions_remaining_changed", Callable(self, "_on_actions_remaining_changed"))
	bok_manager.connect("illness_changed", Callable(self, "_on_illness_changed"))

	# Initialize patient data for current level
	patient_manager.load_patient_data(level_manager.current_level)

func _on_level_changed(new_level: String) -> void:
	patient_manager.load_patient_data(new_level)
	# Change scene to cutscene and diagnosis as before
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	SceneTransitionManager.change_to_cutscene(
		patient_manager.current_patient.get("cutscenescript"),
		patient_manager.current_patient.get("precutsceneKey"),
		"res://scenes/diagnosis.tscn"
	)

func _on_patient_changed(current_patient: Dictionary) -> void:
	# Reset or update state as needed when patient changes
	pass

func _on_action_log_updated(action_log: Array) -> void:
	# Handle action log updates if needed
	pass

func _on_actions_remaining_changed(actions_remaining: int) -> void:
	# Handle actions remaining updates if needed
	pass

func _on_illness_changed(new_illness: String) -> void:
	# Handle illness changes if needed
	pass

# Facade methods to delegate to managers

func change_level(new_level: String) -> void:
	level_manager.change_level(new_level)

func unlock_level(level_index: String) -> void:
	level_manager.unlock_level(level_index)

func add_action_log(action: String) -> void:
	inspection_manager.add_action_log(action)

func use_action() -> void:
	inspection_manager.use_action()

func calculate_points() -> int:
	return score_manager.calculate_points(
		bok_manager.current_illness,
		patient_manager.current_patient,
		inspection_manager.action_log,
		inspection_manager.actions_remaining
	)

func set_illness(new_illness: String) -> void:
	bok_manager.set_illness(new_illness)
