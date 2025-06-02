extends VBoxContainer

class_name ClipboardManager

@export var patient_image : TextureRect
@export var name_label : Label
@export var age_label : Label
@export var occupation_label : Label
@export var temperature_label : Label
@export var heartrate_label : Label
@export var bloodPressure_label : Label
@export var breathing_label : Label
@export var history_text : TextEdit

var patient_data: PatientData = null
var character_data: CharacterData = null
var content_loader: ContentLoader = ContentLoader.new()

signal load_clipboard(character_key: String, patient_data_index: int)
signal clipboard_loaded(character_data: CharacterData, patient_data: PatientData)

func _ready():
	connect("load_clipboard",Callable(self, "_on_load_clipboard"))


func _on_load_clipboard(character_key: String, patient_data_index: int):
	patient_data = content_loader.load_patient_data(patient_data_index)
	character_data = content_loader.load_character_data(character_key)
	# The following methods now delegate to the manager
	emit_signal("clipboard_loaded", character_data, patient_data)
