class_name PatientData

var check_temperature: float
var check_heartrate: int
var check_blood_pressure: String
var check_breathing: String

func _init(
	_temperature: float = 0.0,
	_heartrate: int = 0,
	_blood_pressure: String = "",
	_breathing: String = ""
) -> void:
	check_temperature = _temperature
	check_heartrate = _heartrate
	check_blood_pressure = _blood_pressure
	check_breathing = _breathing

static var patients = [
	PatientData.new(
		36.8,
		75,
		"120/80",
		"Normal"
	)
]
