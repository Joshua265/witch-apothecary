extends VBoxContainer

@export var patient_image : TextureRect 
@export var name_label : Label  
@export var age_label : Label 
@export var occupation_label : Label 
@export var temperature_label : Label  
@export var heartrate_label : Label  

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
	# add_history_text(patient_data["history"])

func set_patient_info():
	# Load patient image and update the UI
	patient_image.texture = load(patient_data["image_path"]) as Texture
	name_label.text = patient_data["name"]
	age_label.text = "Age: " + str(patient_data["age"])
	occupation_label.text = "Occupation: " + patient_data["occupation"]
	temperature_label.text = "Temperature: " + patient_data["temperature"]
	heartrate_label.text = "Heart Rate: " + patient_data["heartrate"]

	var dynamic_font = FontFile.new()
	#dynamic_font.font_data = load("res://path_to_your_font.ttf")
	var theme_override = Theme.new()
	theme_override.set_font_size("font_size", "Label", 10)

	# Set the font and font color for each label
	name_label.theme= theme_override
	age_label.theme= theme_override
	occupation_label.theme= theme_override
	temperature_label.theme= theme_override
	heartrate_label.theme= theme_override

	# Set font color for all labels
	var font_color = Color.BLACK  # Set the desired font color
	name_label.set("theme_override_colors/font_color", font_color)
	age_label.set("theme_override_colors/font_color", font_color)
	occupation_label.set("theme_override_colors/font_color", font_color)
	temperature_label.set("theme_override_colors/font_color", font_color)
	heartrate_label.set("theme_override_colors/font_color", font_color)


func add_history_text(text: String):
	var history_label = get_node("/root/Diagnosis/Clipboard/TextureRect/frame/History") as RichTextLabel
	history_label.text = history_label.text + "\n" + text
	print(get_node("/root/Diagnosis/Clipboard/TextureRect/frame/History").text)

func update_temperature(new_temp: String):
	patient_data["temperature"] = new_temp
	temperature_label.text = "Temperature: " + new_temp 

func update_heartrate(new_heartrate: String):
	patient_data["heartrate"] = new_heartrate
	heartrate_label.text = "Heart Rate: " + new_heartrate 
