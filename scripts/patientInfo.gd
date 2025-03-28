extends VBoxContainer

@export var patient_image : TextureRect  # Reference to the patient's image
@export var name_label : Label  # Reference to the name label
@export var age_label : Label  # Reference to the age label
@export var occupation_label : Label  # Reference to the occupation label
@export var temperature_label : Label  # Reference to the temperature label
@export var heartrate_label : Label  # Reference to the heartrate label
@export var history_text : TextEdit  # Reference to the history text area

var patient_data : Dictionary = {
	"name": "Helena",
	"age": 29,
	"occupation": "Seamstress",
	"image_path": "res://sprites/characters/text.png",
	"temperature": "Not checked yet.", 
	"heartrate": "Not checked yet.",
	"history": "Helena described that she's been having bad headaches."
}

func _ready():
	# Set initial patient info
	set_patient_info()

	# Add some initial history text
	add_history_text(patient_data["history"])

func set_patient_info():
	# Set the patient's image, name, age, occupation, and stats
	patient_image.texture = load(patient_data["image_path"]) as Texture
	name_label.text = patient_data["name"]
	age_label.text = "Age: " + str(patient_data["age"])
	occupation_label.text = "Occupation: " + patient_data["occupation"]
	temperature_label.text = "Temperature: " + patient_data["temperature"] 
	heartrate_label.text = "Heart Rate: " + patient_data["heartrate"] 

func add_history_text(text: String):
	# Add new text to the history box
	history_text.text += "\n" + text

# Example functions to update stats dynamically
func update_temperature(new_temp: String):
	patient_data["temperature"] = new_temp
	temperature_label.text = "Temperature: " + new_temp 

func update_heartrate(new_heartrate: String):
	patient_data["heartrate"] = new_heartrate
	heartrate_label.text = "Heart Rate: " + new_heartrate 
