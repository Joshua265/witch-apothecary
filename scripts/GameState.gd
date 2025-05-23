extends Node

#Scenes
var diagnosis_scene = null
var cutscene_scene = null
var result_scene = null

#Storage
var current_illness = null
var action_log = []

func add_action_log(action: String):
	if not action_log.has(action):
		action_log.append(action)
