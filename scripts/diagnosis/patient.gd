extends TextureRect 

@export var patient_image : TextureRect 
var image_path : String

var patient_images = {
	"helena": "res://sprites/characters/seamstress_sitting.png",  
	"john": "res://john_image.png"
}
var current_patient : String = "helena" 

func _ready():
	image_path = patient_images.get(current_patient, "res://default_patient_image.png")
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
