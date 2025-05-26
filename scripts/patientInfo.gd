extends VBoxContainer

@export var patient_image : TextureRect 
@export var name_label : Label  
@export var age_label : Label 
@export var occupation_label : Label 
@export var temperature_label : Label  
@export var heartrate_label : Label  
@export var bloodPressure_label : Label  
@export var breathing_label : Label  
@export var history_text : TextEdit 


func _ready():
	# Set initial patient info
	set_patient_info()

	# Add some initial history text
	add_history_text(GameState.current_patient["history"])

func set_patient_info():
	# Load patient image and update the UI
	patient_image.texture = load(GameState.current_patient["image_path"]) as Texture
	name_label.text = GameState.current_patient["name"]
	age_label.text = "Age: " + str(GameState.current_patient["age"])
	occupation_label.text = "Occupation: " + GameState.current_patient["occupation"]
	temperature_label.text = "Temperature: Not checked yet" #GameState.current_patient["temperature"]
	heartrate_label.text = "Heart Rate: Not checked yet" #GameState.current_patient["heartrate"]
	bloodPressure_label.text = "Blood Pressure: Not checked yet" #GameState.current_patient["heartrate"]
	breathing_label.text = "Breathing: Not checked yet" #GameState.current_patient["heartrate"]

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
	var dialogue_scroll = get_node_or_null("/root/Diagnosis/Interaction/ScrollContainer/ActionButtonsContainer/Dialogue_Section/ScrollContainer")
	var back_button = get_node_or_null("/root/Diagnosis/Interaction/ScrollContainer/ActionButtonsContainer/Back_Button")
	var clipboard = get_node_or_null("/root/Diagnosis/Interaction/Clipboard")
	
	if dialogue_scroll and back_button and clipboard:
		dialogue_scroll.show()
		back_button.show()
		clipboard.show()

	if text in history_text.text:
		return

	history_text.text += ("\n" if history_text.text != "" else "") + text
	# remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()

func update_temperature(new_temp: String):
	if temperature_label.text != "Temperature: Not checked yet":
		return	
	GameState.current_patient["temperature"] = new_temp
	temperature_label.text = "Temperature: " + new_temp + " °C"
	# remove an action
	get_node("/root/Diagnosis/ActionCounter").use_action()


func update_heartrate(new_heartrate: String):
	if heartrate_label.text != "Heart Rate: Not checked yet":
		return 
	GameState.current_patient["heartrate"] = new_heartrate
	heartrate_label.text = "Heart Rate: " + new_heartrate + " bpm"
	# remove an action
	get_node("/root/Diagnosis/ActionCounter").use_action()

func update_bp(new_bp: String):
	if bloodPressure_label.text != "Blood Pressure: Not checked yet":
		return 
	GameState.current_patient["blood_pressure"] = new_bp
	bloodPressure_label.text = "Blood Pressure: " + new_bp + " mmHg"
	# remove an action
	get_node("/root/Diagnosis/ActionCounter").use_action()

func update_breathing(new_breathing: String):
	if breathing_label.text != "Breathing: Not checked yet":
		return
	GameState.current_patient["breathing"] = new_breathing
	breathing_label.text = "Breathing: " + new_breathing + " br/min"
	# remove an action
	get_node("/root/Diagnosis/ActionCounter").use_action()
