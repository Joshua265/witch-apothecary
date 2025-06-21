extends Resource
class_name ResultData

var action_points: Dictionary [String, int]= {}
var correct_diagnosis: String = ""
var star_margins: Array[int] = []

func _init(_action_points: Dictionary[String, int], _correct_diagnosis: String, _star_margins: Array[int]) -> void:
	self.action_points = _action_points
	self.correct_diagnosis = _correct_diagnosis
	self.star_margins = _star_margins

static var results: Dictionary[int, ResultData] = {
	0: ResultData.new(
		{
					"blood_pressure": 17,
					"temperature": 6,
					"breathing": 13,
					"heartrate": 0,
					"ask_fatigue": 10,
					"ask_feverish": 3,
					"ask_sore_throat": 19,
					"ask_eat_today": 8,
					"ask_headaches": 14,
					"ask_dizzy_duration": 2,
					"ask_heartrate": 11,
					"ask_short_breath": 16,
					"ask_sleep": 5,
					"ask_menstrual_cycle": 20,
					"ask_enough_rest": 9
				},
				 "constipation",
			[20, 40, 60]),
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
			[30, 60, 90]),
		}
