extends Node
class_name ActionManager

signal load_questions(question_set_script: String)
signal load_inspections
signal load_action_counter(max_actions: int, remaining_actions: int)
signal action_used(action_id: String)

var content_loader: ContentLoader = preload("res://scripts/ContentLoader.gd").new()
var actions: Dictionary[String, ActionData] = {}
var available_actions: Array[String] = [] # List of available action IDs for the current level
var remaining_actions: int = 0

class ActionLogItem:
	var action_id: String
	var text: String

	func _init(_action_id: String, _text: String) -> void:
		self.action_id = _action_id
		self.text = _text

var action_log: Array[ActionLogItem] = []

func _ready():
	actions = content_loader.load_action_data()
	GameState.connect("load_available_actions", Callable(self, "_on_load_available_actions"))
	GameState.connect("load_max_actions", Callable(self, "_on_load_max_actions"))

func _on_load_max_actions(max_actions: int) -> void:
	print("[ActionManager] _on_load_max_actions called with: ", max_actions)
	# Initialize remaining actions
	remaining_actions = max_actions
	update_available_actions()

func was_inspected(action_id: String) -> bool:
	# Check if the action was already used
	for log_item in action_log:
		if log_item.action_id == action_id:
			return true
	return false

func _on_load_available_actions(_available_actions: Array[String]) -> void:
	print("[ActionManager] _on_load_available_actions called with: ", _available_actions)
	# Load actions for the current level
	available_actions = _available_actions.duplicate()
	update_available_actions()

func update_available_actions() -> void:
	emit_signal("load_questions", GameState.level_manager.current_level_data.questionSetScript)
	emit_signal("load_inspections")
	emit_signal("load_action_counter", GameState.level_manager.current_level_data.max_actions, remaining_actions)
	check_no_more_actions()

# Check if an action is available
func is_action_available(action_id: String) -> bool:
	return available_actions.has(action_id)

# Use an action (decrement remaining actions, return success)
func use_action(action_id: String) -> bool:
	if is_action_available(action_id) and remaining_actions > 0:
		remaining_actions -= 1
		GameState.action_counter_manager.update(remaining_actions)
		available_actions.erase(action_id)  # Remove the action from available actions
		action_log.append(ActionLogItem.new(action_id, actions.get(action_id).log_text))
		update_available_actions()
		emit_signal("action_used", action_id)  # Notify that an action was used
		return true
	return false

# Get action info by ID
func get_action(action_id: String) -> ActionData:
	return actions.get(action_id)

# Get action ID by dialogue question (for dialogue integration)
func get_action_id_by_dialogue(dialogue_id: String) -> String:
	return actions.find_key(
		func(action: ActionData) -> bool:
			return action.dialogue_id == dialogue_id
	)

# Get all available actions (for UI, etc.)
func get_available_actions() -> Array:
	return available_actions.duplicate()

# Get remaining actions
func get_remaining_actions() -> int:
	return remaining_actions

func check_no_more_actions():
	if get_remaining_actions() == 0:
		GameState.set_diagnosis_state(GameState.DiagnosisState.NO_ACTIONS)
