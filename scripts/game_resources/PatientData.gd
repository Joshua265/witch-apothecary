class_name PatientData

var illness: String
var temperature: float
var heartrate: int
var blood_pressure: String
var breathing: String

func _init(
	_initial_illness: String = "",
	_initial_temperature: float = 0.0,
	_initial_heartrate: int = 0,
	_initial_blood_pressure: String = "",
	_initial_breathing: String = ""
) -> void:
	illness = _initial_illness
	temperature = _initial_temperature
	heartrate = _initial_heartrate
	blood_pressure = _initial_blood_pressure
	breathing = _initial_breathing

static var patients = [
	PatientData.new(
		"Constipation",
		36.8,
		75,
		"120/80",
		"Normal"
	)
]
