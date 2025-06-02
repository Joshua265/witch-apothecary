extends Panel
class_name Clipboard

signal clipboard_loaded(character_data: CharacterData, patient_data: PatientData)

@export var clipboard : Panel
@export var animation_player : AnimationPlayer
@export var hover_distance : float = 10
var closed_position : Vector2
var is_open : bool = false
var is_hovered : bool = false

func _ready():
	connect("clipboard_loaded", Callable(self, "_on_clipboard_loaded"))

func _process(_delta):
	var mouse_position = get_global_mouse_position()

	if clipboard.get_rect().has_point(mouse_position):
		if !is_hovered:
			animate_hover_in()
			is_hovered = true
	else:
		if is_hovered and !is_open:
			animate_hover_out()
			is_hovered = false

func animate_hover_in():
	animation_player.play("hover_in")

func animate_hover_out():
	animation_player.play_backwards("hover_in")

func _on_clipboard_pressed():
	if !is_open:
		animation_player.play("open")
		is_open = true
	else:
		animation_player.play_backwards("open")
		is_open = false

func _on_clipboard_loaded(character_data: CharacterData, patient_data: PatientData):
	clipboard.visible = true
	clipboard.get_node("PatientImage").texture = character_data.patient_image
	clipboard.get_node("NameLabel").text = character_data.name
	clipboard.get_node("AgeLabel").text = str(character_data.age)
	clipboard.get_node("OccupationLabel").text = character_data.occupation
	clipboard.get_node("TemperatureLabel").text = "Not Checked yet"
	clipboard.get_node("HeartRateLabel").text = "Not Checked yet"
	clipboard.get_node("BloodPressureLabel").text = "Not Checked yet"
	clipboard.get_node("BreathingLabel").text = "Not Checked yet"
	clipboard.get_node("HistoryText").text = ""
	closed_position = clipboard.rect_position
	clipboard.rect_position = closed_position
	clipboard.visible = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_clipboard_pressed();
