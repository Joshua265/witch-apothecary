class_name ClipboardManager

extends Node

var patient_data: PatientData = null
var character_data: CharacterData = null
var content_loader: ContentLoader = ContentLoader.new()
var level_inspection_fields: Array[String]

signal clipboard_loaded(character_data: CharacterData, patient_data: PatientData)
signal show_inspected_field(field_name: String, field_value: String)
signal history_text_added(text: String)

var history: Array[String] = []

func _ready():
	GameState.connect("load_clipboard",Callable(self, "_on_load_clipboard"))


func _on_load_clipboard(character_key: String, patient_data_index: int):
	print("ClipboardManager: Loading clipboard for character:", character_key, "and patient index:", patient_data_index)
	level_inspection_fields = GameState.level_manager.current_level_data.available_actions.filter(
		func(action_id: String) -> bool:
			return GameState.action_manager.get_action(action_id).type == "inspection"
	)
	patient_data = content_loader.load_patient_data(patient_data_index)
	character_data = content_loader.load_character_data(character_key)
	print("Clipboard available inspection fields:", level_inspection_fields)
	# The following methods now delegate to the manager
	emit_signal("clipboard_loaded", character_data, patient_data)

func inspect_field(field_name: String):
	if ActionData.ACTIONS.has(field_name) and ActionData.ACTIONS[field_name].type == "inspection":
		emit_signal("show_inspected_field", field_name, str(patient_data.get(field_name)))
	else:
		print("inspect_field: Ignored non-inspection or unknown field: ", field_name)

func add_history_text(text: String):
	history.append(text)
	emit_signal("history_text_added", text)
