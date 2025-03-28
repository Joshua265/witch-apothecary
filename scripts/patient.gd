extends TextureRect 

@export var patient_image : TextureRect 
var image_path : String
# A dictionary to map patient names to their images
var patient_images = {
	"helena": "res://sprites/characters/text.png",  
	"john": "res://john_image.png"
}
var current_patient : String = "helena"  # Set default patient as 'helena'

func _ready():
	# Load the default patient's image
	image_path = patient_images.get(current_patient, "res://default_patient_image.png")
	update_patient_image()
	
func update_patient_image():
	# Ensure that the texture is correctly loaded and assigned to the TextureRect
	var loaded_texture = load(image_path)
	if loaded_texture:
		patient_image.texture = loaded_texture  # Set the texture for the TextureRect
		patient_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Ensures the image keeps its aspect ratio
	else:
		print("Failed to load texture: " + image_path)
