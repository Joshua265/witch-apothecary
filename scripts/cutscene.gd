extends Control

@export var background: TextureRect 

# Preload default speaker sprite size if we need this 
const DEFAULT_SPRITE_SIZE = Vector2(300, 400)

func _ready():
	pass
	
func start_cutscene(background_path: String, cutscene_path: String, cutscene_name:String):
	set_background(background_path)
	var resource = ResourceLoader.load(cutscene_path)

	# Show the dialogue
	DialogueManager.show_dialogue_balloon(resource, cutscene_name)

	# Wait for the dialogue_ended signal
	await DialogueManager.dialogue_ended

	# Change scene
	#todo: Dynamic
	var diagnosis_scene = preload("res://scenes/diagnosis.tscn")
	SceneTransitionManager.change_scene(diagnosis_scene)


# Set the background image
func set_background(texture_path: String):
	background.texture = load(texture_path)

# Create and position speaker sprite dynamically
func create_speaker_sprite(sprite_path: String, position: Vector2):
	var sprite = TextureRect.new()
	sprite.texture = load(sprite_path)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	sprite.custom_minimum_size = DEFAULT_SPRITE_SIZE
	sprite.position = position
	self.add_child(sprite)

# Helper for left/right
func get_position_from_keyword(keyword: String) -> Vector2:
	match keyword:
		"left":
			return Vector2(100, 150)
		"center":
			return Vector2(500, 150)
		"right":
			return Vector2(900, 150)
		_:
			return Vector2(0, 0) # fallback/default
