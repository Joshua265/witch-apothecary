extends Node

var level_manager: LevelManager
var character_manager: CharacterManager
var action_counter_manager: ActionCounterManager
# var inspection_manager:
var bok_manager: BoKManager
var clipboard_manager: ClipboardManager
var content_loader: ContentLoader = ContentLoader.new()

var action_log = []
var level_scores = {}


signal load_patient(load_patient_index: int)
signal load_questions(question_set_script: String, question_set_key: String)
signal load_bok(illnesses_indices: Array[int])
signal load_character(character_key: String)
signal load_clipboard(character_key: String, patient_data_index: int)
signal load_action_counter(available_actions: int, remaining_actions: int)

# state
@export var remaining_actions = 0;

func _ready() -> void:
	# Instantiate managers
	level_manager = preload("res://scripts/LevelManager.gd").new()
	action_counter_manager = preload("res://scripts/diagnosis/action_counter_manager.gd").new()
	# inspection_manager = preload("res://scripts/InspectionManager.gd").new()
	bok_manager = preload("res://scripts/diagnosis/book_of_knowledge/BoKManager.gd").new()
	clipboard_manager = preload("res://scripts/diagnosis/clipboard_manager.gd").new()
	character_manager = preload("res://scripts/diagnosis/CharacterManager.gd").new()

	add_child(level_manager)
	add_child(action_counter_manager)
	add_child(bok_manager)
	add_child(clipboard_manager)
	add_child(character_manager)

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
	emit_signal("load_patient", level_manager.current_level_data.get("patient_data_index"))
	emit_signal("load_questions", level_manager.current_level_data.get("questionSetScript"), level_manager.current_level_data.get("questionSetKey"))
	emit_signal("load_bok", level_manager.current_level_data.get("illnessesIndices"))
	emit_signal("load_character", level_manager.current_level_data.get("characterKey"))
	emit_signal("load_clipboard", level_manager.current_level_data.get("characterKey"), level_manager.current_level_data.get("patient_data_index"))
	emit_signal("load_action_counter", level_manager.current_level_data.get("available_actions"), level_manager.current_level_data.get("available_actions"))
	remaining_actions = level_manager.current_level_data.get("available_actions")

func unlock_level(level_index: int) -> void:
	level_manager.unlock_level(level_index)

func use_action(action: String) -> void:
	action_log.append(action)
	remaining_actions -= 1
	action_counter_manager.update(remaining_actions)


func calculate_points(current_illness: String) -> int:
	var current_points = 0
	var current_patient = content_loader.load_patient_data(level_manager.current_level_data.get("patient_data_index"))
	if current_illness != current_patient.get("illness"):
		current_points = 0
	else:
		var current_action_evaluation = level_manager.current_level_data.get("point_eval")
		for action in action_log:
			if current_action_evaluation.has(action):
				current_points += current_action_evaluation[action]
	current_points += remaining_actions * 10
	level_scores[level_manager.current_level_data.name] = current_points
	return current_points


func _on_diagnosis_selected(current_illness: String) -> void:
	var points = calculate_points(current_illness)
	print("Points for diagnosis:", points)

	# Emit signal to update the score manager or any other relevant component
	emit_signal("diagnosis_selected", current_illness, points)
