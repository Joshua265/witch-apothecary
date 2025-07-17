extends Node

class_name LevelData

var level_image_path: String
var precutsceneKey: String
var postcutsceneKey: String
var characterKey: String
var patient_data_index: int
var illnessesIndices: Array[int]
var questionSetKey: String
var questionSetScript: String
var cutscenescript: String
var max_actions: int
var available_actions: Array[String] = []
var result_preset_index: int

func _init(
	_level_image_path: String,
	_precutsceneKey: String,
	_postcutsceneKey: String,
	_characterKey: String,
	_patient_data_index: int,
	_illnessesIndices: Array[int],
	_questionSetKey: String,
	_questionSetScript: String,
	_cutscenescript: String,
	_max_actions: int,
	_available_actions: Array[String],
	_result_preset_index: int
	) -> void:
	self.level_image_path = _level_image_path
	self.precutsceneKey = _precutsceneKey
	self.postcutsceneKey = _postcutsceneKey
	self.characterKey = _characterKey
	self.patient_data_index = _patient_data_index
	self.illnessesIndices = _illnessesIndices
	self.questionSetKey = _questionSetKey
	self.questionSetScript = _questionSetScript
	self.cutscenescript = _cutscenescript
	self.max_actions = _max_actions
	self.available_actions = _available_actions
	self.result_preset_index = _result_preset_index

static var levels: Array[LevelData] = [
	LevelData.new(
		"res://sprites/characters/seamstress.png",
		"precutsceneL1",
		"postcutsceneL1",
		"Helena",
		0,  # Patient data index
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],  # Illness indices - HERE FIX NUMBER OF ILLNESSES
		"questionSetL1",
		"res://scripts/dialogue/questionSet1.dialogue",
		"res://scripts/dialogue/prologue1.dialogue",
		9, # Max actions
		[
			"blood_pressure",
			"temperature",
			"breathing",
			"heartrate",
			"ask_fatigue",
			"ask_feverish",
			"ask_sore_throat",
			"ask_eat_today",
			"ask_headaches",
			"ask_dizzy_duration",
			"ask_heartrate",
			"ask_short_breath",
			"ask_sleep",
			"ask_menstrual_cycle",
			"ask_enough_rest",
		],
		0
	),
	LevelData.new(
		"res://sprites/characters/husband.png",
		"precutsceneL2",
		"postcutsceneL2",
		"Husband",
		1,  # Patient data index
		[5, 6, 8, 9, 10, 11],  # Illness indices
		"questionSetL2",
		"res://scripts/dialogue/questionSet2.dialogue",
		"res://scripts/dialogue/prologue2.dialogue",
		10, # Max actions
		[
			"blood_pressure",
			"temperature",
			"breathing",
			"heartrate",
			"ask_fatigue",
			"ask_feverish",
			"ask_sore_throat",
			"ask_eat_today",
			"ask_headaches",
			"ask_dizzy_duration",
			"ask_heartrate",
			"ask_short_breath",
			"ask_sleep",
			"ask_menstrual_cycle",
			"ask_enough_rest"
		],
		1
	),
	LevelData.new(
		"res://sprites/characters/witch_cool.png",
		"precutsceneL3",
		"postcutsceneL3",
		"Coming Soon",
		2,  # Patient data index
		[12, 13, 14, 15, 16, 17],  # Illness indices
		"questionSetL3",
		"res://scripts/dialogue/questionSet3.dialogue",
		"res://scripts/dialogue/prologue3.dialogue",
		11, # Max actions
		[
			"blood_pressure",
			"temperature",
			"breathing",
			"heartrate",
			"ask_fatigue",
			"ask_feverish",
			"ask_sore_throat",
			"ask_eat_today",
			"ask_headaches",
			"ask_dizzy_duration",
			"ask_heartrate",
			"ask_short_breath",
			"ask_sleep",
			"ask_menstrual_cycle",
			"ask_enough_rest"
		],
		2
	)
]

	# PatientData.new(
	# 	0,
	# 	"res://sprites/characters/seamstress.png",
	# 	"precutsceneL1",
	# 	"postcutsceneL1",
	# 	"questionSetL1",
	# 	"res://scripts/dialogue/questionSet1.dialogue",
	# 	"res://scripts/dialogue/prologue1.dialogue",
	# 	"Helena",
	# 	29,
	# 	"Seamstress",
	# 	"Constipation",
	# 	"Yaay Helena lived",
	# 	"Helena died oof...",
	# 	"res://sprites/characters/seamstress.png",
	# 	"res://sprites/characters/seamstress_sitting.png",
	# 	"36.8",
	# 	"75",
	# 	"16",
	# 	"120/80",
	# 	"Helena described that she's been having bad headaches.",
	# 	[30, 90, 150],
	# 	{
	# 		"You checked blood pressure.": 17,
	# 		"You checked temperature.": 6,
	# 		"You checked breathing.": 13,
	# 		"You asked Tell me more about your fatigue.": 10,
	# 		"You asked Have you been feeling feverish?": 3,
	# 		"You asked Have you experienced a sore throat or cough?": 19,
	# 		"You asked What did you eat today?": 8,
	# 		"You asked Tell me more about your headaches.": 14,
	# 		"You asked How long have you been feeling dizzy?": 2,
	# 		"You asked Have you noticed any changes in your heart rate?": 11,
	# 		"You asked Do you feel short of breath?": 16,
	# 		"You asked How much sleep are you getting?": 5,
	# 		"You asked Have you noticed any changes in your menstrual cycle?": 20,
	# 		"You asked Do you feel like you’re getting enough rest, even if it's just short breaks?": 9
	# 	}
