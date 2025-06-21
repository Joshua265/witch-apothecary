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
	"blood_pressure": ActionData.new("Check Blood Pressure", "inspection", "You checked blood pressure."),
	"temperature": ActionData.new("Check Temperature", "inspection", "You checked temperature."),
	"breathing": ActionData.new("Check Breathing", "inspection", "You checked breathing."),
	"heartrate": ActionData.new("Check Heart Rate", "inspection", "You checked heart rate."),
	"ask_fatigue": ActionData.new("Tell me more about your fatigue.", "question", "Helena reports persistent fatigue over the past few weeks, worsened by long working hours with minimal breaks.", "Tell me more about your fatigue."),
	"ask_feverish": ActionData.new("Have you been feeling feverish?", "question", "Helena reports a slight rise in temperature over the last few days, along with occasional dizziness.", "Have you been feeling feverish?"),
	"ask_sore_throat": ActionData.new("Have you experienced a sore throat or cough?", "question", "Helena has not experienced sore throat or cough, but reports dizziness and headaches.", "Have you experienced a sore throat or cough?"),
	"ask_eat_today": ActionData.new("What did you eat today?", "question", "Helena reports inadequate hydration and limited diet, which could be contributing to her symptoms of fatigue and dizziness.", "What did you eat today?"),
	"ask_headaches": ActionData.new("Tell me more about your headaches.", "question", "Helena reports recurring headaches around her forehead and temples, which worsen with prolonged work without breaks.", "Tell me more about your headaches."),
	"ask_dizzy_duration": ActionData.new("How long have you been feeling dizzy?", "question", "Helena reports dizziness occurring after standing up or long hours of work, possibly linked to dehydration.", "How long have you been feeling dizzy?"),
	"ask_heartrate": ActionData.new("Have you noticed any changes in your heart rate?", "question", "Helena reports an elevated heart rate, especially under stress or prolonged work, which could indicate stress-induced tachycardia.", "Have you noticed any changes in your heart rate?"),
	"ask_short_breath": ActionData.new("Do you feel short of breath?", "question", "Helena denies experiencing shortness of breath, which helps rule out some respiratory conditions.", "Do you feel short of breath?"),
	"ask_sleep": ActionData.new("How much sleep are you getting?", "question", "Helena reports getting only 4-5 hours of sleep each night, which could be contributing to her fatigue and overall condition.", "How much sleep are you getting?"),
	"ask_menstrual_cycle": ActionData.new("Have you noticed any changes in your menstrual cycle?", "question", "Helena reports no changes in her menstrual cycle, ruling out hormonal imbalances as a factor.", "Have you noticed any changes in your menstrual cycle?"),
	"ask_enough_rest": ActionData.new("Do you feel like you’re getting enough rest, even if it's just short breaks?", "question", "Helena admits to not taking regular breaks during work, which could be contributing to her fatigue.", "Do you feel like you’re getting enough rest, even if it's just short breaks?")
}
