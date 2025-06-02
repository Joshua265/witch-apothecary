extends Node

class_name LevelData

var level_image_path: String
var precutsceneKey: String
var postcutsceneKey: String
var questionsSetKey: String
var characterKey: String
var patient_data_index: int
var questionSetScript: String
var cutscenescript: String
var point_margins: Array
var point_eval: Dictionary

func _init(
	initial_point_achieved: int,
	initial_level_image_path: String,
	initial_precutsceneKey: String,
	initial_postcutsceneKey: String,
	initial_questionsSetKey: String,
	initial_questionSetScript: String,
	initial_cutscenescript: String,
	initial_patient_name: String,
	initial_age: int,
	initial_occupation: String,
	initial_illness: String,
	initial_correctdiagnosistext: String,
	initial_wrongdiagnosistext: String,
	initial_image_path: String,
	initial_sitting_sprite: String,
	initial_temperature: String,
	initial_heartrate: String,
	initial_breathing: String,
	initial_blood_pressure: String,
	initial_history: String,
	initial_point_margins: Array,
	initial_point_eval: Dictionary
) -> void:
	self.point_achieved = initial_point_achieved
	self.level_image_path = initial_level_image_path
	self.precutsceneKey = initial_precutsceneKey
	self.postcutsceneKey = initial_postcutsceneKey
	self.questionsSetKey = initial_questionsSetKey
	self.questionSetScript = initial_questionSetScript
	self.cutscenescript = initial_cutscenescript
	self.patient_name = initial_patient_name
	self.age = initial_age
	self.occupation = initial_occupation
	self.illness = initial_illness
	self.correctdiagnosistext = initial_correctdiagnosistext
	self.wrongdiagnosistext = initial_wrongdiagnosistext
	self.image_path = initial_image_path
	self.sitting_sprite = initial_sitting_sprite
	self.temperature = initial_temperature
	self.heartrate = initial_heartrate
	self.breathing = initial_breathing
	self.blood_pressure = initial_blood_pressure
	self.history = initial_history
	self.point_margins = initial_point_margins
	self.point_eval = initial_point_eval
