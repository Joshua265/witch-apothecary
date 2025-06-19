extends TextureRect
class_name Clipboard

@export var hover_distance : float = 10
var closed_position : Vector2
var is_open : bool = false
var is_hovered : bool = false

var inspection_fields = {}


func _ready():
	GameState.clipboard_manager.connect("clipboard_loaded", Callable(self, "_on_clipboard_loaded"))
	GameState.clipboard_manager.connect("show_inspected_field", Callable(self, "_on_show_inspected_field"))
	GameState.clipboard_manager.connect("history_text_added", Callable(self, "_on_history_text_added"))

	# Dynamically generate inspection fields as Labels inside Patient_Info VBoxContainer
	var patient_info = $frame/Main/Patient_Info
	# Remove any previously generated inspection labels (keep static fields)
	for child in patient_info.get_children():
		if child is Label and child.name.begins_with("inspection_"):
			patient_info.remove_child(child)
			child.queue_free()

	inspection_fields = {}
	var unit_map = {
		"check_blood_pressure": "mmHg",
		"check_temperature": "°C",
		"check_breathing": "",
		"check_heart_rate": "bpm"
	}
	for action_id in ActionData.ACTIONS.keys(): #TODO: use GameState.action_manager.get_available_actions() instead
		var action = ActionData.ACTIONS[action_id]
		if action.type == "inspection":
			var label_node = Label.new()
			label_node.name = "inspection_" + action_id
			label_node.text = action_id.replace("check_", "").capitalize() + ": Not Inspected"
			label_node.add_theme_font_size_override("font_size", 12)
			patient_info.add_child(label_node)
			inspection_fields[action_id] = {
				"label": action.button_text,
				"component": label_node,
				"unit": unit_map[action_id] if unit_map.has(action_id) else ""
			}


func _process(_delta):
	var mouse_position = get_global_mouse_position()

	if self.get_rect().has_point(mouse_position):
		if !is_hovered:
			animate_hover_in()
			is_hovered = true
	else:
		if is_hovered and !is_open:
			animate_hover_out()
			is_hovered = false

func animate_hover_in():
	$AnimationPlayer.play("hover_in")

func animate_hover_out():
	$AnimationPlayer.play_backwards("hover_in")

func _on_clipboard_pressed():
	print("Clipboard pressed")
	if !is_open:
		$AnimationPlayer.play("open")
		is_open = true
	else:
		$AnimationPlayer.play_backwards("open")
		is_open = false

func _on_clipboard_loaded(character_data: CharacterData, _patient_data: PatientData):
	print("Clipboard loaded with character data:", character_data.name)
	var character_texture = load(character_data.image_path)
	if character_texture:
		$frame/Main/Patient_Picture.texture = character_texture
	else:
		print("Failed to load texture:", character_data.image_path)
	$frame/Main/Patient_Info/Name.text = character_data.name
	$frame/Main/Patient_Info/Age.text = str(character_data.age)
	$frame/Main/Patient_Info/Occupation.text = character_data.occupation
	for field_name in inspection_fields.keys():
		var label = inspection_fields[field_name]["label"]
		var component = inspection_fields[field_name]["component"]
		component.text = label + ": Not Inspected"
	$frame/History.text = ""

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_clipboard_pressed();

func _on_show_inspected_field(field_name: String, field_value: String):
	print("Showing inspected field:", field_name, "with value:", field_value)
	if field_name in inspection_fields:
		var field_info = inspection_fields[field_name]
		field_info["component"].text = field_info["label"] + ": " + field_value + " " + field_info["unit"]
		$frame/History.text += "\n" + field_info["label"] + ": " + field_value + " " + field_info["unit"]
	else:
		print("Field name not recognized:", field_name)

func _on_history_text_added(text: String):
	$frame/History.text += "\n" + text
