class_name PatientData

var patient_name: String
var age: int
var occupation: String
var image_path: String
var sitting_sprite: String

func _init(
	_patient_name: String,
	_age: int,
	_occupation: String,
	_image_path: String,
	_sitting_sprite: String,
):
	self.patient_name = _patient_name
	self.age = _age
	self.occupation = _occupation
	self.image_path = _image_path
	self.sitting_sprite = _sitting_sprite


static var patients = [
	PatientData.new(
		"Helena",
		29,
		"Seamstress",
		"res://sprites/characters/seamstress.png",
		"res://sprites/characters/seamstress_sitting.png",
	)
]
