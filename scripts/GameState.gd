extends Node

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

func _ready():
	load_patient_data()
	
func load_patient_data():
	var patient_data_script = load("res://scripts/patient_data.gd")
	var patient_data_instance = patient_data_script.new()
	current_patient = patient_data_instance.patients[current_level]

func change_level(new_level):
	current_level = new_level
	print("Changing to level %d..." % current_level)
	load_patient_data()
	
func add_action_log(action: String):
	if not action_log.has(action):
		action_log.append(action)
