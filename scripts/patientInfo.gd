extends VBoxContainer

@export var patient_image : TextureRect 
@export var name_label : Label  
@export var age_label : Label 
@export var occupation_label : Label 
@export var temperature_label : Label  
@export var heartrate_label : Label  
@export var history_text : TextEdit 

var patient_data : Dictionary = {
	"name": "Helena",
	"age": 29,
	"occupation": "Seamstress",
	"image_path": "res://sprites/characters/seamstress.png",
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
	# Load patient image and update the UI
	patient_image.texture = load(patient_data["image_path"]) as Texture
	name_label.text = patient_data["name"]
	age_label.text = "Age: " + str(patient_data["age"])
	occupation_label.text = "Occupation: " + patient_data["occupation"]
	temperature_label.text = "Temperature: " + patient_data["temperature"]
	heartrate_label.text = "Heart Rate: " + patient_data["heartrate"]

	#todo: Text size- if you can handle this with global please remove here
	var theme_override = Theme.new()
	theme_override.set_font_size("font_size", "Label", 10)

	# Set the font and font color for each label
	name_label.theme= theme_override
	age_label.theme= theme_override
	occupation_label.theme= theme_override
	temperature_label.theme= theme_override
	heartrate_label.theme= theme_override

#todo: Not sure if best idea to remove action here honestly but oh well at least in one place
func add_history_text(text: String):
	print("Adding history text: ", text)

	var dialogue_scroll = get_node_or_null("/root/Diagnosis/Interaction/ScrollContainer/ActionButtonsContainer/Dialogue_Section/ScrollContainer")
	var back_button = get_node_or_null("/root/Diagnosis/Interaction/ScrollContainer/ActionButtonsContainer/Back_Button")
	var clipboard = get_node_or_null("/root/Diagnosis/Interaction/Clipboard")
	
	if dialogue_scroll and back_button and clipboard:
		dialogue_scroll.show()
		back_button.show()
		clipboard.show()

	if text in history_text.text:
		print("Text already in history, skipping.")
		return

	history_text.text += ("\n" if history_text.text != "" else "") + text
	# remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()

func update_temperature(new_temp: String):
	if  patient_data["temperature"] == new_temp:
		return
		
	patient_data["temperature"] = new_temp
	temperature_label.text = "Temperature: " + new_temp 
	# remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()

func update_heartrate(new_heartrate: String):
	if patient_data["heartrate"] == new_heartrate:
		return 
	patient_data["heartrate"] = new_heartrate
	heartrate_label.text = "Heart Rate: " + new_heartrate 
	# remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()
