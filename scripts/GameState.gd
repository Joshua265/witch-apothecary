extends Node

var patient_data_instance: Node

# add class 
const BoKHighlighter = preload("res://scripts/Bok_Highlighter.gd")

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
#added for highlighting
var revealed_info = []
var revealed_vitals = {}

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

	#TODO: check if that is used somewhere else and the information is deleted when not supposed to
	print("check for reseting the revealed info") #works for this - maybe a problem if we add that the user can edit a level
	# Reset per-patient runtime info
	revealed_info.clear()
	revealed_vitals.clear()
	# add the first info from the clipboard
	revealed_info.clear()
	var history = current_patient.get("history", "")
	if history != "":
		add_revealed_info(history)


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


# needed for the highlighting
func add_revealed_info(text: String) -> void:
	# preprocessing done - based on input
	var keywords = BoKHighlighter.extract_keywords(text)
	var vitals   = BoKHighlighter.extract_vitals(text)

	# but saves it as added in the view
	var revealed_info   = GameState.current_patient["revealed_info"]    # should be an Array
	var revealed_vitals = GameState.current_patient["revealed_vitals"]  # should be a Dictionary

	# Add each keyword into the Array if it’s not already there
	for keyword in keywords:
		if not revealed_info.has(keyword):
			revealed_info.append(keyword)
			
	# Add each numeric vital into the Dictionary (overwrites if already exists)
	for vital_key in vitals.keys():
		revealed_vitals[vital_key] = vitals[vital_key]
