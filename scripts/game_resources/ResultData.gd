extends Resource
class_name ResultData

var action_points: Dictionary [String, int]= {}
var correct_diagnosis: String = ""
var star_margins: Array[int] = []
var probable_diagnosis: Array[String] = []

func _init(_action_points: Dictionary[String, int], _correct_diagnosis: String, _star_margins: Array[int], _probable_diagnosis: Array[String]) -> void:
	self.action_points = _action_points
	self.correct_diagnosis = _correct_diagnosis
	self.star_margins = _star_margins
	self.probable_diagnosis = _probable_diagnosis

static var results: Dictionary[int, ResultData] = {
	0: ResultData.new(
		{
					"blood_pressure": 15,
					"temperature": 5,
					"breathing": 15,
					"heartrate": 20,
					"ask_fatigue": 20,
					"ask_feverish": 5,
					"ask_sore_throat": 10,
					"ask_eat_today": 20,
					"ask_headaches": 20,
					"ask_dizzy_duration": 20,
					"ask_heartrate": 20,
					"ask_short_breath": 20,
					"ask_sleep": 15,
					"ask_menstrual_cycle": 15,
					"ask_enough_rest": 20
				},
				 "Overexertion",
			[100, 160, 220],
			["Anxiety / Stress-Induced Symptoms", "Dehydration"]
			),
	1: ResultData.new(
			{
				"blood_pressure": 15,
				"temperature": 7,
				"breathing": 12,
				"heartrate": 1,
				"ask_fatigue": 9,
				"ask_feverish": 4,
				"ask_sore_throat": 18,
				"ask_eat_today": 7,
				"ask_headaches": 13,
				"ask_dizzy_duration": 3,
				"ask_heartrate": 10,
				"ask_short_breath": 15,
				"ask_sleep": 6,
				"ask_menstrual_cycle": 19,
				"ask_enough_rest": 8
			}
			, "dehydration",
			[30, 60, 90],
			[]
			),
		}
