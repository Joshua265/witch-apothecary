extends Node

class_name LevelManager

signal level_changed(new_level)
signal level_unlocked(level_index)

class LevelScore:
	var diagnosis: String
	var diagnosis_correct: bool
	var points: int

	func _init(_diagnosis: String, _diagnosis_correct: bool, _points: int) -> void:
		self.diagnosis = _diagnosis
		self.diagnosis_correct = _diagnosis_correct
		self.points = _points

var level_scores: Dictionary[int, LevelScore] = {}
@export var current_level_data: LevelData = null
@export var current_level: int = 0
@export var unlocked_levels: Array = [0]# Start with level 1 unlocked
var content_loader: ContentLoader = ContentLoader.new()
var levels: Array[LevelData]


var result_data: ResultData = null

func _ready() -> void:
	result_data = content_loader.load_result_data(current_level)
	levels = content_loader.load_all_levels()

func calculate_points(current_illness: String) -> int:
	var current_points = 0
	for action_id in GameState.action_manager.get_available_actions():
		if GameState.action_manager.get_available_actions().has(action_id):
			# Sum points from ResultData using new structure
			current_points += result_data.action_points.get(action_id, 0)
	# Add points for remaining actions (assuming 10 points each)
	current_points += GameState.action_manager.get_remaining_actions() * 10
	var correct_diagnosis: bool = current_illness.to_lower() == result_data.correct_diagnosis.to_lower()
	level_scores[current_level] = LevelScore.new(current_illness, correct_diagnosis, current_points)
	return current_points

func change_level(new_level: int) -> void:
	current_level = new_level
	current_level_data = content_loader.load_level_data(new_level)
	emit_signal("level_changed", new_level)
	print("Changing to level %s..." % current_level)
	# TODO: maybe centralise the reseting stuff here 


func unlock_level(level_index: int) -> void:
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		emit_signal("level_unlocked", level_index)
		print("Level %s unlocked!" % level_index)
	else:
		print("Level %s is already unlocked." % level_index)
func check_unlock_next_level() -> void:
	var next_level = current_level + 1
	if next_level == len(levels) - 1:
		print("Do not unlock last level")
		return
	if level_scores.has(current_level) and level_scores[current_level].diagnosis_correct:
		if level_scores.has(current_level) and level_scores[current_level].points >= result_data.star_margins[0]:
			unlock_level(next_level)
			print("Unlocked next level:", next_level)
		else:
			print("Not enough points to unlock next level:", next_level)
	print("Wrong Diagnosis to unlock next level:", next_level)
