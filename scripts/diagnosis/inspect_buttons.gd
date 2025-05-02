extends VBoxContainer

func _ready():
	_generate_inspect_buttons()

func _generate_inspect_buttons():
	print("Generating inspect buttons")
	# Todo: Make this better
	var button_data = [
		{"text": "Pulse Check", "handler": Callable(self, "_on_pulse_check_pressed")},
		{"text": "Temperature Check", "handler": Callable(self, "_on_temperature_check_pressed")},
		{"text": "Breathing Check", "handler": Callable(self, "_on_breathing_check_pressed")}
	]

	for data in button_data:
		var button = Button.new()
		button.text = data["text"]
		add_child(button)
		button.pressed.connect(data["handler"])
		
#todo: Handle for multiple patients
func _on_pulse_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_heartrate("new temp")
	 # remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()

	
func _on_temperature_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_temperature("new temp")
	 # remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()


#todo: Add breathing section in clipboard? or just use add info
func _on_breathing_check_pressed():
	print("Breathing Check: Using magical wind instrument to assess breath and detect irregularities.")
	#get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_breathing("Info")
	 # remove a action
	get_node("/root/Diagnosis/ActionCounter").use_action()
