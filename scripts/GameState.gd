extends Node

var level_manager: Node
var character_manager: Node
var score_manager: Node
var inspection_manager: Node
var bok_manager: Node
var clipboard_manager: Node

# Scenes
var diagnosis_scene = null
var cutscene_scene = null
var result_scene = null

signal load_patient(load_patient_index: int)
signal load_questions(question_set_script: String, question_set_key: String)
signal load_bok(illnesses_indices: Array[int], diagnose_mode: bool)
signal load_character(character_key: String)
signal load_clipboard(character_data: CharacterData, patient_data: PatientData)

# state
@export var actions_remaining = 0;

func _ready() -> void:
	# Instantiate managers
	level_manager = preload("res://scripts/LevelManager.gd").new()
	score_manager = preload("res://scripts/ScoreManager.gd").new()
	inspection_manager = preload("res://scripts/InspectionManager.gd").new()
	bok_manager = preload("res://scripts/diagnosis/book_of_knowledge/BoKManager.gd").new()
	clipboard_manager = preload("res://scripts/diagnosis/clipboard_manager.gd").new()
	character_manager = preload("res://scripts/diagnosis/CharacterManager.gd").new()

	# Add managers as children for lifecycle management
	add_child(level_manager)
	# add_child(patient_manager)
	add_child(character_manager)
	add_child(score_manager)
	add_child(inspection_manager)
	add_child(bok_manager)
	add_child(clipboard_manager)

	# Connect signals
	connect("load_character", Callable(character_manager, "load_character"))


# Facade methods to delegate to managers

func change_level(new_level: int) -> void:
	print("GameState CHANGE LEVEL")
	level_manager.change_level(new_level)
	print(level_manager.current_level_data)

	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	SceneTransitionManager.change_to_cutscene(
		level_manager.current_level_data.get("cutscenescript"),
		level_manager.current_level_data.get("precutsceneKey"),
	)

func _on_cutscene_finished() -> void:
	print("GameState CUTSCENE FINISHED")
	get_tree().change_scene_to_file("res://scenes/diagnosis.tscn")

func _on_diagnosis_scene_ready() -> void:
	emit_signal("load_patient", level_manager.current_level_data.get("patientIndex"))
	emit_signal("load_questions", level_manager.current_level_data.get("questionSetScript"), level_manager.current_level_data.get("questionSetKey"))
	emit_signal("load_bok", level_manager.current_level_data.get("illnessesIndices"), false)
	emit_signal("load_bok", level_manager.current_level_data.get("illnessesIndices"), true)
	emit_signal("load_character", level_manager.current_level_data.get("characterKey"))
	emit_signal("load_clipboard", level_manager.current_level_data.get("characterKey"), level_manager.current_level_data.get("patientIndex"))

func unlock_level(level_index: int) -> void:
	level_manager.unlock_level(level_index)

func add_action_log(action: String) -> void:
	inspection_manager.add_action_log(action)

func use_action() -> void:
	inspection_manager.use_action()

func calculate_points() -> int:
	return score_manager.calculate_points(
		bok_manager.current_illness,
		level_manager.current_illness,
		inspection_manager.action_log,
		inspection_manager.actions_remaining
	)

func set_illness(new_illness: String) -> void:
	bok_manager.set_illness(new_illness)
