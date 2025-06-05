class_name ClipboardManager

extends Node

var patient_data: PatientData = null
var character_data: CharacterData = null
var content_loader: ContentLoader = ContentLoader.new()

signal clipboard_loaded(character_data: CharacterData, patient_data: PatientData)
signal show_inspected_field(field_name: String, field_value: String)

func _ready():
	GameState.connect("load_clipboard",Callable(self, "_on_load_clipboard"))


func _on_load_clipboard(character_key: String, patient_data_index: int):
	print("ClipboardManager: Loading clipboard for character:", character_key, "and patient index:", patient_data_index)
	patient_data = content_loader.load_patient_data(patient_data_index)
	character_data = content_loader.load_character_data(character_key)
	# The following methods now delegate to the manager
	emit_signal("clipboard_loaded", character_data, patient_data)

func inspect_field(field_name: String):
	emit_signal("show_inspected_field", field_name, str(patient_data.get(field_name)))
