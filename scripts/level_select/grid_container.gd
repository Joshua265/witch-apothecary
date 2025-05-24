extends GridContainer

@onready var level_entry_scene = preload("res://scenes/level_entry.tscn")

#todo: can we use gamestate for the image paths? scene_path always the same but disable the button for 3?
# if disabled pop up that says "Not available yet?"
var levels = [
	{
		"index": 1,
		"title": "Helena",
		"image_path": "res://sprites/characters/seamstress.png",
		"scene_path": "res://scenes/diagnosis.tscn"
	},
	{
		"index": 2,
		"title": "Someone else",
		"image_path": "res://sprites/shapes/circle.png",
		"scene_path": "res://scenes/diagnosis.tscn"
	},
	{
		"index": 3,
		"title": "Comming Soon!",
		"image_path": "res://sprites/shapes/circle.png",
		"scene_path": "res://scenes/level_select.tscn"
	},
	# Add more levels as needed
]

func _on_level_entry_pressed(button):
	var scene_path = button.get_meta("scene_path")
	GameState.current_level = button.get_meta("index") #setting level
	if scene_path:
		get_tree().change_scene_to_file(scene_path)

func _ready():
	for level in levels:
		var level_entry = level_entry_scene.instantiate()
		
		# Set the level index
		var index_label = level_entry.get_node("Index")
		index_label.text = "00" + str(level["index"])
		
		# Set the level image
		var texture_rect = level_entry.get_node("Image")
		texture_rect.texture = load(level["image_path"])
		
		# Set the level title
		var title_label = level_entry.get_node("Title")
		title_label.text = level["title"]
		
		level_entry.set_meta("scene_path", level["scene_path"])
		level_entry.set_meta("index", level["index"])
		level_entry.pressed.connect(_on_level_entry_pressed.bind(level_entry))
		
		add_child(level_entry)
