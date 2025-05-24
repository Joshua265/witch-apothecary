extends Node

var patient_data_instance: Node

#Scenes
var diagnosis_scene = null
var cutscene_scene = null
var result_scene = null

# Patient Control
var current_level = 1
var current_patient = {}

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
