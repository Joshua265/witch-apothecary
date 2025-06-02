extends Node

signal action_log_updated(action_log)
signal actions_remaining_changed(actions_remaining)

var action_log: Array = []
var actions_remaining: int = 11  # TODO: Make dependent on level

func add_action_log(action: String) -> void:
	if not action_log.has(action):
		action_log.append(action)
		emit_signal("action_log_updated", action_log)

func use_action() -> void:
	if actions_remaining > 0:
		actions_remaining -= 1
		emit_signal("actions_remaining_changed", actions_remaining)
	else:
		print("No more actions left — no more points can be earned.")
