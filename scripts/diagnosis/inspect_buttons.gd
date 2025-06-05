extends VBoxContainer

func _ready():
	_generate_inspect_buttons()

func _generate_inspect_buttons():
	# Todo: Make this better
	var button_data = [
		{"text": "Heartrate Check", "handler": Callable(self, "_on_pulse_check_pressed")},
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
	GameState.clipboard_manager.inspect_field("heartrate")
	GameState.use_action("You checked pulse.")

func _on_bp_check_pressed():
	GameState.clipboard_manager.inspect_field("blood_pressure")
	GameState.use_action("You checked blood pressure.")
	
func _on_temperature_check_pressed():
	GameState.clipboard_manager.inspect_field("temperature")
	GameState.use_action("You checked temperature.")

#todo: Add breathing section in clipboard? or just use add info
func _on_breathing_check_pressed():
	GameState.clipboard_manager.inspect_field("breathing")
	GameState.use_action("You checked breathing.")
