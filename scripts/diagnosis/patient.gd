extends TextureRect 

@export var patient_image : TextureRect 
var image_path : String

func _ready():
	image_path = GameState.current_patient["sitting_sprite"]
	update_patient_image()
	
func update_patient_image():
	var loaded_texture = load(image_path)
	if loaded_texture:
		patient_image.texture = loaded_texture
		patient_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		patient_image.expand = true
		patient_image.custom_minimum_size = Vector2(128, 128)
	else:
		print("Failed to load texture: " + image_path)
