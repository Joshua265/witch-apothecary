extends VBoxContainer

func _ready():
	_generate_inspect_buttons()

func _generate_inspect_buttons():
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
		
#todo: Handle for multiple patients, idea: We can have a patient info script and just get the temp and info for the character from there!
func _on_pulse_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_heartrate("new temp")
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked pulse.")
	
func _on_temperature_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_temperature("new temp")
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked temperature.")

#todo: Add breathing section in clipboard? or just use add info
func _on_breathing_check_pressed():
	print("Breathing Check: Using magical wind instrument to assess breath and detect irregularities.")
	#get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_breathing("Info")
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked breathing.")
