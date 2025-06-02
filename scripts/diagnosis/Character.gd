extends TextureRect

class_name Character

var character = null

func _init(
	_character: CharacterData= null,
):
	self.character = character


@export var patient_image : TextureRect

func _ready():
	print(GameState.character_manager.has_signal("character_loaded"))
	GameState.character_manager.connect("character_loaded", Callable(self, "update_patient_image"))


func update_patient_image(character_data: CharacterData):
	print("character_loaded received")
	var image_path = character_data.image_path
	var loaded_texture = load(image_path)
	if loaded_texture:
		self.texture = loaded_texture
		self.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		self.expand = true
		self.custom_minimum_size = Vector2(128, 128)
	else:
		print("Failed to load texture: " + image_path)
