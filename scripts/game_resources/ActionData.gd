extends Resource
class_name ActionData

var button_text: String
var type: String  # e.g. "inspection", "question"
var log_text: String
var dialogue_id: String = ""  # Optional, used for questions

func _init(_button_text: String, _type: String, _log_text: String = "", _dialogue_id: String = "") -> void:
	self.button_text = _button_text
	self.type = _type
	self.log_text = _log_text
	self.dialogue_id = _dialogue_id

static var ACTIONS: Dictionary[String, ActionData] = {
	"check_blood_pressure": ActionData.new("Check Blood Pressure", "inspection", "You checked blood pressure."),
	"check_temperature": ActionData.new("Check Temperature", "inspection", "You checked temperature."),
	"check_breathing": ActionData.new("Check Breathing", "inspection", "You checked breathing."),
	"check_heart_rate": ActionData.new("Check Heart Rate", "inspection", "You checked heart rate."),
	"ask_fatigue": ActionData.new("Tell me more about your fatigue.", "question", "Tell me more about your fatigue.", "Tell me more about your fatigue."),
	"ask_feverish": ActionData.new("Have you been feeling feverish?", "question", "Have you been feeling feverish?", "Have you been feeling feverish?"),
	"ask_sore_throat": ActionData.new("Have you experienced a sore throat or cough?", "question", "Have you experienced a sore throat or cough?", "Have you experienced a sore throat or cough?"),
	"ask_eat_today": ActionData.new("What did you eat today?", "question", "What did you eat today?", "What did you eat today?"),
	"ask_headaches": ActionData.new("Tell me more about your headaches.", "question", "Tell me more about your headaches.", "Tell me more about your headaches."),
	"ask_dizzy_duration": ActionData.new("How long have you been feeling dizzy?", "question", "How long have you been feeling dizzy?", "How long have you been feeling dizzy?"),
	"ask_heart_rate": ActionData.new("Have you noticed any changes in your heart rate?", "question", "Have you noticed any changes in your heart rate?", "Have you noticed any changes in your heart rate?"),
	"ask_short_breath": ActionData.new("Do you feel short of breath?", "question", "Do you feel short of breath?", "Do you feel short of breath?"),
	"ask_sleep": ActionData.new("How much sleep are you getting?", "question", "How much sleep are you getting?", "How much sleep are you getting?"),
	"ask_menstrual_cycle": ActionData.new("Have you noticed any changes in your menstrual cycle?", "question", "Have you noticed any changes in your menstrual cycle?", "Have you noticed any changes in your menstrual cycle?"),
	"ask_enough_rest": ActionData.new("Do you feel like you’re getting enough rest, even if it's just short breaks?", "question", "Do you feel like you’re getting enough rest, even if it's just short breaks?", "Do you feel like you’re getting enough rest, even if it's just short breaks?")
}
