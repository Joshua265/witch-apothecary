extends Node

var level_manager: LevelManager
var character_manager: CharacterManager
var action_counter_manager: ActionCounterManager
var bok_manager: BoKManager
var clipboard_manager: ClipboardManager
var content_loader: ContentLoader = ContentLoader.new()
var action_manager: ActionManager = ActionManager.new()
var bok_highlighter: BoKHighlighter = BoKHighlighter.new()

var action_log = []

enum DiagnosisState {
	DEFAULT,
	ASKING,
	DIALOGUE,
	INSPECTING,
	DIAGNOSING,
}

var current_diagnosis_state: DiagnosisState = DiagnosisState.DEFAULT

enum CurrentScene {
	PRECUTSCENE,
	DIAGNOSIS,
	POSTCUTSCENE,
	RESULTS,
	LEVEL_SELECT
}

var current_scene: CurrentScene

signal diagnosis_state_changed(new_state)

func set_diagnosis_state(new_state: DiagnosisState) -> void:
	if current_diagnosis_state != new_state:
		current_diagnosis_state = new_state
		emit_signal("diagnosis_state_changed", new_state)


signal load_patient(load_patient_index: int)
signal load_bok(illnesses_indices: Array[int])
signal load_character(character_key: String)
signal load_clipboard(character_key: String, patient_data_index: int)
signal load_available_actions(available_actions: Array[String])
signal load_max_actions(max_actions: int)

# state
@export var remaining_actions = 0;

func _ready() -> void:
	# Instantiate managers
	level_manager = preload("res://scripts/LevelManager.gd").new()
	action_counter_manager = preload("res://scripts/diagnosis/action_counter_manager.gd").new()
	bok_manager = preload("res://scripts/diagnosis/book_of_knowledge/BoKManager.gd").new()
	clipboard_manager = preload("res://scripts/diagnosis/clipboard_manager.gd").new()
	character_manager = preload("res://scripts/diagnosis/CharacterManager.gd").new()
	action_manager = preload("res://scripts/diagnosis/ActionManager.gd").new()

	add_child(level_manager)
	add_child(action_counter_manager)
	add_child(bok_manager)
	add_child(clipboard_manager)
	add_child(character_manager)
	add_child(action_manager)
	add_child(bok_highlighter)

func change_level(new_level: int) -> void:
	print("GameState CHANGE LEVEL")
	level_manager.change_level(new_level)
	print(level_manager.current_level_data)

	current_scene = CurrentScene.PRECUTSCENE
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	SceneTransitionManager.change_to_cutscene(
		level_manager.current_level_data.get("cutscenescript"),
		level_manager.current_level_data.get("precutsceneKey"),
	)

func _on_cutscene_finished() -> void:
	print("GameState CUTSCENE FINISHED")
	if current_scene == CurrentScene.PRECUTSCENE:
		current_scene = CurrentScene.DIAGNOSIS
		get_tree().change_scene_to_file("res://scenes/diagnosis.tscn")
	elif current_scene == CurrentScene.POSTCUTSCENE:
		current_scene = CurrentScene.LEVEL_SELECT
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func show_post_cutscene() -> void:
	print("GameState SHOW POST CUTSCENE")
	current_scene = CurrentScene.POSTCUTSCENE
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	SceneTransitionManager.change_to_cutscene(
		level_manager.current_level_data.cutscenescript,
		level_manager.current_level_data.postcutsceneKey,
	)

func _on_diagnosis_scene_ready() -> void:
	emit_signal("load_patient", level_manager.current_level_data.get("patient_data_index"))
	emit_signal("load_bok", level_manager.current_level_data.get("illnessesIndices"))
	emit_signal("load_character", level_manager.current_level_data.get("characterKey"))
	emit_signal("load_clipboard", level_manager.current_level_data.get("characterKey"), level_manager.current_level_data.get("patient_data_index"))
	emit_signal("load_available_actions", level_manager.current_level_data.available_actions)
	emit_signal("load_max_actions", level_manager.current_level_data.max_actions)
	bok_highlighter.reset()

func unlock_level(level_index: int) -> void:
	level_manager.unlock_level(level_index)

func select_diagnosis(current_illness: String) -> void:
	var points = level_manager.calculate_points(current_illness)
	print("Points for diagnosis:", points)
	level_manager.check_unlock_next_level()

	get_tree().change_scene_to_file("res://scenes/results.tscn")
