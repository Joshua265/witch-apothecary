extends Node

class_name LevelManager

signal level_changed(new_level)
signal level_unlocked(level_index)

class LevelScore:
	var correct_diagnosis: bool
	var points: int

	func _init(_correct_diagnosis: bool, _points: int) -> void:
		self.correct_diagnosis = _correct_diagnosis
		self.points = _points

var level_scores: Dictionary[String, LevelScore] = {}
@export var current_level_data: LevelData = null
@export var current_level: int = 0
@export var unlocked_levels: Array = [1]# Start with level 1 unlocked
var content_loader: ContentLoader = ContentLoader.new()


var result_data: ResultData = null

func _ready() -> void:
	result_data = content_loader.load_result_data(current_level)

func calculate_points(current_illness: String) -> int:
	var current_points = 0
	var current_patient = content_loader.load_patient_data(current_level_data.get("patient_data_index"))
	if current_illness != current_patient.get("illness"):
		current_points = 0
	else:
		for action_id in GameState.action_manager.get_available_actions():
			if GameState.action_manager.get_available_actions().has(action_id):
				# Sum points from ResultData using new structure
				current_points += result_data.action_points.get(action_id, 0)
	# Add points for remaining actions (assuming 10 points each)
	current_points += GameState.action_manager.get_remaining_actions() * 10
	var correct_diagnosis = current_illness == result_data.correct_diagnosis
	level_scores[current_level_data.name] = LevelScore.new(correct_diagnosis, current_points)
	return current_points

func change_level(new_level: int) -> void:
	if current_level != new_level:
		current_level = new_level
		current_level_data = content_loader.load_level_data(new_level)
		emit_signal("level_changed", new_level)
		print("Changing to level %s..." % current_level)
	else:
		print("Already on level %s" % current_level)

func unlock_level(level_index: int) -> void:
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		emit_signal("level_unlocked", level_index)
		print("Level %s unlocked!" % level_index)
	else:
		print("Level %s is already unlocked." % level_index)
func check_unlock_next_level() -> void:
	if current_level_data.get("next_level") != -1:
		var next_level = current_level_data.get("next_level")
		if level_scores.has(current_level_data.name) and level_scores[current_level_data.name].correct_diagnosis:
			if level_scores.has(current_level_data.name) and level_scores[current_level_data.name].points >= result_data.star_margins[0]:
				unlock_level(next_level)
				print("Unlocked next level:", next_level)
			else:
				print("Not enough points to unlock next level:", next_level)
		print("Wrong Diagnosis to unlock next level:", next_level)
