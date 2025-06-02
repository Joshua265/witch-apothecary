class_name PatientData

var illness: String
var correctdiagnosistext: String
var wrongdiagnosistext: String
var temperature: String
var heartrate: String
var breathing: String
var blood_pressure: String
var patient_name: String
var age: int
var occupation: String
var image_path: String
var sitting_sprite: String
var precutsceneKey: String
var postcutsceneKey: String
var questionsSetKey: String
var questionSetScript: String
var cutscenescript: String
var history: String
var point_margins: Array
var point_eval: Dictionary

func _init(
	initial_point_achieved: int,
	initial_image_path: String,
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
	initial_image_path2: String,
	initial_sitting_sprite: String,
	initial_temperature: String,
	initial_heartrate: String,
	initial_breathing: String,
	initial_blood_pressure: String,
	initial_history: String,
	initial_point_margins: Array,
	initial_point_eval: Dictionary
) -> void:
	self.patient_data_index = initial_point_achieved
	self.image_path = initial_image_path
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
	self.image_path = initial_image_path2
	self.sitting_sprite = initial_sitting_sprite
	self.temperature = initial_temperature
	self.heartrate = initial_heartrate
	self.breathing = initial_breathing
	self.blood_pressure = initial_blood_pressure
	self.history = initial_history
	self.point_margins = initial_point_margins
	self.point_eval = initial_point_eval

static var patients = [
	PatientData.new(
		0,
		"res://sprites/characters/seamstress.png",
		"precutsceneL1",
		"postcutsceneL1",
		"questionSetL1",
		"res://scripts/dialogue/questionSet1.dialogue",
		"res://scripts/dialogue/prologue1.dialogue",
		"Helena",
		29,
		"Seamstress",
		"Constipation",
		"Yaay Helena lived",
		"Helena died oof...",
		"res://sprites/characters/seamstress.png",
		"res://sprites/characters/seamstress_sitting.png",
		"36.8",
		"75",
		"16",
		"120/80",
		"Helena described that she's been having bad headaches.",
		[30, 90, 150],
		{
			"You checked blood pressure.": 17,
			"You checked temperature.": 6,
			"You checked breathing.": 13,
			"You asked Tell me more about your fatigue.": 10,
			"You asked Have you been feeling feverish?": 3,
			"You asked Have you experienced a sore throat or cough?": 19,
			"You asked What did you eat today?": 8,
			"You asked Tell me more about your headaches.": 14,
			"You asked How long have you been feeling dizzy?": 2,
			"You asked Have you noticed any changes in your heart rate?": 11,
			"You asked Do you feel short of breath?": 16,
			"You asked How much sleep are you getting?": 5,
			"You asked Have you noticed any changes in your menstrual cycle?": 20,
			"You asked Do you feel like you’re getting enough rest, even if it's just short breaks?": 9
		}
	)
]
