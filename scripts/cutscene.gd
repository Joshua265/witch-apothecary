extends Control

@export var background: TextureRect

signal cutscene_finished()

# Preload default speaker sprite size if we need this
const DEFAULT_SPRITE_SIZE = Vector2(500, 1000)

func _ready():
	connect("cutscene_finished", Callable(GameState, "_on_cutscene_finished"))
	$Button.connect("pressed", Callable(self, "_on_skip_button_pressed"))

func _on_skip_button_pressed():
	emit_signal("cutscene_finished")

func start_cutscene(cutscene_path: String, cutscene_name:String):
	var resource = ResourceLoader.load(cutscene_path)

	# Show the dialogue
	DialogueManager.show_dialogue_balloon(resource, cutscene_name)

	# Wait for the dialogue_ended signal
	await DialogueManager.dialogue_ended

	emit_signal("cutscene_finished")


# Set the background image
func set_background(texture_path: String):
	background.texture = load(texture_path)

# Create and position speaker sprite dynamically
func create_speaker_sprite(sprite_path: String, _position: Vector2):
	var sprite = TextureRect.new()
	sprite.texture = load(sprite_path)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	sprite.custom_minimum_size = DEFAULT_SPRITE_SIZE
	sprite.position = _position
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
