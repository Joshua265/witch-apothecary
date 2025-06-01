extends VBoxContainer
# todo: fixes + highlight new values
# inlcudes example for action_log
func _ready():
	_generate_inspect_buttons()

func _generate_inspect_buttons():
	# Todo: Make this better
	var button_data = [
		{"text": "Pulse Check", "handler": Callable(self, "_on_pulse_check_pressed")},
		{"text": "Blood Pressure Check", "handler": Callable(self, "_on_bp_check_pressed")},
		{"text": "Temperature Check", "handler": Callable(self, "_on_temperature_check_pressed")},
		{"text": "Breathing Check", "handler": Callable(self, "_on_breathing_check_pressed")}
	]

	for data in button_data:
		var button = Button.new()
		button.text = data["text"]
		add_child(button)
		button.pressed.connect(data["handler"])
		
func _on_pulse_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_heartrate(GameState.current_patient["heartrate"])
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked pulse.")
	#here add revealed action or at the gamestate add idk

func _on_bp_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_bp(GameState.current_patient["blood_pressure"])
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked blood pressure.")
	
func _on_temperature_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_temperature(GameState.current_patient["temperature"])
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked temperature.")

#todo: Add breathing section in clipboard? or just use add info
func _on_breathing_check_pressed():
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").update_breathing(GameState.current_patient["breathing"])
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You checked breathing.")
