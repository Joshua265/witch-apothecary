extends GridContainer

@onready var level_entry_scene = preload("res://scenes/level_entry.tscn")

signal level_selected(level_index: String)

var levels = {}
var unlocked_levels = []
var level_manager = null

func _ready():
	level_manager = get_node("/root/LevelManager")
	if level_manager:
		level_manager.connect("level_changed", Callable(self, "_on_level_changed"))
		level_manager.connect("level_unlocked", Callable(self, "_on_level_unlocked"))

	# Initialize levels from external source (e.g. patient data)
	# This should be set externally or via a signal in a full refactor
	# For now, we simulate by loading from GameState.patient_data_instance.patients
	levels = GameState.patient_data_instance.patients
	unlocked_levels = level_manager.unlocked_levels if level_manager else []

	_update_ui()

func _update_ui():
	for key in levels.keys():
		var level = levels[key]
		var level_entry = level_entry_scene.instantiate()

		var index_label = level_entry.get_node("Index")
		index_label.text = str(key)

		var texture_rect = level_entry.get_node("Image")
		texture_rect.texture = load(level["level_image_path"])

		var title_label = level_entry.get_node("Title")
		title_label.text = level["name"]

		var locked = not unlocked_levels.has(key)
		level_entry.set_meta("locked", locked)

		level_entry.set_meta("index", key)

		if not locked:
			level_entry.pressed.connect(_on_level_entry_pressed.bind(level_entry))

		add_child(level_entry)

func _on_level_entry_pressed(button):
	emit_signal("level_selected", button.get_meta("index"))

func _on_level_changed(new_level):
	# Could update UI or state if needed
	pass

func _on_level_unlocked(level_index):
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		_update_ui()
