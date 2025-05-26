extends Node

var patient_data_instance: Node

#Scenes
var diagnosis_scene = null
var cutscene_scene = null
var result_scene = null

# Patient Control
var current_level = 1
var current_patient = {}
#TODO: Add these to patient data?
var current_points = 0
var current_level_point_margin = []
var current_action_evaluation = {}

#Storage
var current_illness = null
var action_log = []
var actions_remaining = 11 #todo: Make dependant on Level

# Game State
var unlocked_levels = [1]  # Start with level 1 unlocked

func _ready():
	load_patient_data()

func load_patient_data():
	var patient_data_script = load("res://scripts/patient_data.gd")
	patient_data_instance = patient_data_script.new()
	current_patient = patient_data_instance.patients[current_level]
	current_action_evaluation = current_patient["point_eval"]
	current_level_point_margin = current_patient["point_margins"]

func unlock_level(level_index: int):
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		print("Level %d unlocked!" % level_index)
	else:
		print("Level %d is already unlocked." % level_index)

func change_level(new_level):
	current_level = new_level
	print("Changing to level %d..." % current_level)
	load_patient_data()
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	SceneTransitionManager.change_to_cutscene(
		current_patient["cutscenescript"],
		current_patient["precutsceneKey"],
		"res://scenes/diagnosis.tscn"
	)

func add_action_log(action: String):
	if not action_log.has(action):
		action_log.append(action)

# TODO: Doesn't consider if Diagnosis is right yet		
func calculate_points() -> int:
	for action in action_log:
		if current_action_evaluation.has(action):
			current_points += current_action_evaluation[action]
	
	current_points += actions_remaining * 10
	return current_points
