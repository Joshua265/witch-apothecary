extends Control

@export var background: TextureRect

signal cutscene_finished()

# Preload default speaker sprite size if we need this
const DEFAULT_SPRITE_SIZE = Vector2(500, 1000)
var _active_speaker_sprites: Dictionary = {}


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
"""
func create_speaker_sprite(sprite_path: String, _position: Vector2):
	var sprite = TextureRect.new()
	sprite.texture = load(sprite_path)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	sprite.custom_minimum_size = DEFAULT_SPRITE_SIZE
	sprite.position = _position
	self.add_child(sprite)
"""

# Helper for left/right
func get_position_from_keyword(keyword: String) -> Vector2:
	var viewport_size = get_viewport_rect().size # Get actual viewport size for responsiveness
	
	# Define margins and vertical offset as percentages of viewport size
	# This makes positions responsive to different screen sizes
	var horizontal_margin_ratio = 0.35 # Character will be ~25% from the edge
	var vertical_offset_ratio = 0.75   # Character's center will be ~75% down the screen

	match keyword:
		"left":
			# X: 25% from the left edge
			# Y: 75% down from the top edge
			return Vector2(viewport_size.x * horizontal_margin_ratio, viewport_size.y * vertical_offset_ratio)
		"center":
			# X: Exactly in the middle
			# Y: 75% down from the top edge
			return Vector2(viewport_size.x / 2, viewport_size.y * vertical_offset_ratio)
		"right":
			# X: 25% from the right edge (1.0 - 0.25 = 0.75)
			# Y: 75% down from the top edge
			return Vector2(viewport_size.x * (1.0 - horizontal_margin_ratio), viewport_size.y * vertical_offset_ratio)
		_:
			# Fallback to center, 75% down
			return Vector2(viewport_size.x / 2, viewport_size.y * vertical_offset_ratio)


# Modified create_speaker_sprite to handle removal of previous characters
# You can optionally pass `clear_previous = true` if you want all old characters gone
# when a new one appears, or `clear_previous = false` if you want to allow multiple.
# For simplicity, let's assume `true` for "removing the character."
func create_speaker_sprite(texture_path: String, position: Vector2, scale: Vector2 = Vector2(1, 1), fade_duration: float = 0.5, clear_previous: bool = true) -> Sprite2D:
	# 1. Remove ALL previously active characters if clear_previous is true
	if clear_previous:
		for path in _active_speaker_sprites.keys():
			var existing_sprite = _active_speaker_sprites[path]
			if is_instance_valid(existing_sprite): # Check if the node is still valid
				# Optional: Add a fade-out effect for removal
				var remove_tween = create_tween()
				remove_tween.tween_property(existing_sprite, "modulate", Color(1, 1, 1, 0), fade_duration)
				remove_tween.tween_callback(existing_sprite.queue_free) # Delete after fade
			_active_speaker_sprites.erase(path) # Remove from our tracking dictionary

	# 2. Create and add the new speaker sprite (your existing logic)
	var speaker_sprite = Sprite2D.new()
	speaker_sprite.texture = load(texture_path)
	speaker_sprite.position = position
	speaker_sprite.scale = scale

	# Start fully transparent for fade-in (if you want fade-in)
	speaker_sprite.modulate = Color(1, 1, 1, 0) 

	add_child(speaker_sprite)
	_active_speaker_sprites[texture_path] = speaker_sprite # Store reference to the new sprite

	# 3. Create a tween for the fade-in effect for the NEW sprite
	var tween = create_tween()
	tween.tween_property(speaker_sprite, "modulate", Color(1, 1, 1, 1), fade_duration)

	return speaker_sprite
	
	
func remove_all_speaker_sprites(fade_duration: float = 0.1) -> void:
	for path in _active_speaker_sprites.keys():
		var existing_sprite = _active_speaker_sprites[path]
		if is_instance_valid(existing_sprite):
			var remove_tween = create_tween()
			remove_tween.tween_property(existing_sprite, "modulate", Color(1, 1, 1, 0), fade_duration)
			remove_tween.tween_callback(existing_sprite.queue_free)
		# Always remove from our tracking dictionary, even if instance was invalid
		_active_speaker_sprites.erase(path)
	# Clear the dictionary completely after processing all
	_active_speaker_sprites.clear()
