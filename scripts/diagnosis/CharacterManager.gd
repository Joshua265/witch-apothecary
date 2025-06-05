class_name CharacterManager

extends Node

var current_patient: CharacterData = null
var content_loader: ContentLoader = ContentLoader.new()

signal character_loaded(current_patient: CharacterData)

func _ready():
	# Connect to the GameState signal to load character data when requested
	GameState.connect("load_character", Callable(self, "_on_load_character"))

# Loads patient data by index using ContentLoader
func _on_load_character(characterIndex: String) -> void:
	var patient_data = content_loader.load_character_data(characterIndex)
	if patient_data:
		current_patient = patient_data
		print("emit character_loaded")
		emit_signal("character_loaded", current_patient)
	else:
		print("Failed to load character data for index: ", characterIndex)
