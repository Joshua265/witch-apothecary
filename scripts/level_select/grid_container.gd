extends GridContainer

@onready var level_entry_scene = preload("res://scenes/level_entry.tscn")

#todo: can we use gamestate for the image paths? scene_path always the same but disable the button for 3?
# if disabled pop up that says "Not available yet?"
func _on_level_entry_pressed(button):
	#var scene_path = button.get_meta("scene_path")
	GameState.change_level(button.get_meta("index")) #setting level
	#if scene_path:
		
		#get_tree().change_scene_to_file(scene_path)

func _ready():
	for key in GameState.patient_data_instance.patients.keys():
		var level = GameState.patient_data_instance.patients[key]
		var level_entry = level_entry_scene.instantiate()

		# Set the level index
		var index_label = level_entry.get_node("Index")
		index_label.text = str(key)

		# Set the level image
		var texture_rect = level_entry.get_node("Image")
		texture_rect.texture = load(level["level_image_path"])

		# Set the level title
		var title_label = level_entry.get_node("Title")
		title_label.text = level["name"]

		var locked = not GameState.unlocked_levels.has(key)
		level_entry.set_meta("locked", locked)

		#level_entry.set_meta("cutscene", level["scene_path"])
		level_entry.set_meta("index", key)

		if not locked:
			level_entry.pressed.connect(_on_level_entry_pressed.bind(level_entry))

		add_child(level_entry)
