extends Control

@export var background: TextureRect

# Preload default speaker sprite size if we need this
const DEFAULT_SPRITE_SIZE = Vector2(500, 1000)

func _ready():
	GameState.cutscene_scene= self
	pass

func start_cutscene(cutscene_path: String, cutscene_name:String,next_scene_path: String):
	var resource = ResourceLoader.load(cutscene_path)

	# Show the dialogue
	DialogueManager.show_dialogue_balloon(resource, cutscene_name)

	# Wait for the dialogue_ended signal
	await DialogueManager.dialogue_ended

	# Dynamically load the next scene
	var next_scene = ResourceLoader.load(next_scene_path)
	if next_scene:
		SceneTransitionManager.change_scene(next_scene)
	else:
		push_error("Next scene not found: " + next_scene_path)

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
			return Vector2(100, 50)
		"center":
			return Vector2(500, 50)
		"right":
			return Vector2(700, 50)
		_:
			return Vector2(0, 0) # fallback/default
