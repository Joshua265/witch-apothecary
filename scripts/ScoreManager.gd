extends Node

var current_points: int = 0
var level_scores: Dictionary = {}

func calculate_points(current_illness: String, current_patient: Dictionary, action_log: Array, actions_remaining: int) -> int:
	current_points = 0
	if current_illness != current_patient.get("illness", null):
		current_points = 0
	else:
		var current_action_evaluation = current_patient.get("point_eval", {})
		for action in action_log:
			if current_action_evaluation.has(action):
				current_points += current_action_evaluation[action]
	current_points += actions_remaining * 10
	level_scores[current_patient.get("level", "unknown")] = current_points
	return current_points
