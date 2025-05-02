extends Node

@export var action_text : Label 
signal action_used

var actions_remaining: int = 10

func _ready():
	update_actions_label()

func use_action():
	if actions_remaining > 0:
		actions_remaining -= 1
		print("Actions remaining: ", actions_remaining)
		update_actions_label()

		if actions_remaining == 0:
			print("No more actions left — no more points can be earned.")
	else:
		print("You're out of actions — no more points available.")

func update_actions_label():
	if action_text:
		action_text.text = "Actions remaining: %d" % actions_remaining
