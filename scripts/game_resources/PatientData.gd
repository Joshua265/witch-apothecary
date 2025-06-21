class_name PatientData

var temperature: float
var heartrate: int
var blood_pressure: String
var breathing: int

func _init(
	_temperature: float,
	_heartrate: int,
	_blood_pressure: String ,
	_breathing: int
) -> void:
	temperature = _temperature
	heartrate = _heartrate
	blood_pressure = _blood_pressure
	breathing = _breathing

static var patients = [
	PatientData.new(
		39,
		200,
		"150/100",
		200
	),
	PatientData.new(
		37.5,
		80,
		"130/85",
		25
	),
]
