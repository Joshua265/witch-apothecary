extends GridContainer

@onready var level_entry_scene = preload("res://scenes/level_entry.tscn")

signal level_selected(level_index: String)

var level_manager = null
var contentLoader: ContentLoader = ContentLoader.new()
var levels: Array[LevelData]

func _ready():
	GameState.level_manager.connect("level_unlocked", Callable(self, "_on_level_unlocked"))

	levels = contentLoader.load_all_levels()

	_update_ui()

func _update_ui():
	for idx in len(levels):
		var level = levels[idx]
		var level_entry = level_entry_scene.instantiate()

		var index_label = level_entry.get_node("Index")
		index_label.text = "Level %d" % [idx]

		var texture_rect = level_entry.get_node("Image")
		texture_rect.texture = load(level.level_image_path)

		var title_label = level_entry.get_node("Title")
		title_label.text = level.characterKey.capitalize()

		var unlocked_levels = GameState.level_manager.unlocked_levels
		var locked = not unlocked_levels.has(idx)
		level_entry.set_meta("locked", locked)

		level_entry.set_meta("index", idx)

		if not locked:
			level_entry.pressed.connect(_on_level_entry_pressed.bind(level_entry))

		add_child(level_entry)

func _on_level_entry_pressed(button):
	GameState.change_level(button.get_meta("index"))

func _on_level_unlocked(level_index):
	var unlocked_levels = GameState.level_manager.unlocked_levels
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		_update_ui()
