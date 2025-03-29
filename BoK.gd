extends Panel

@export var left_button : TextureButton
@export var right_button : TextureButton
@export var left_panel : VBoxContainer
@export var right_panel : VBoxContainer
@export var close_button: TextureButton

signal back_pressed  # Define a signal

var illnesses = [
	{"name": "Illness 1", "details": "Details of Illness 1."},
	{"name": "Illness 2", "details": "Details of Illness 2."},
	{"name": "Illness 3", "details": "Details of Illness 3."},
	{"name": "Illness 4", "details": "Details of Illness 4."},
	{"name": "Illness 5", "details": "Details of Illness 5."},
	{"name": "Illness 6", "details": "Details of Illness 6."},
	{"name": "Illness 7", "details": "Details of Illness 7."},
	{"name": "Illness 8", "details": "Details of Illness 8."},
	{"name": "Illness 9", "details": "Details of Illness 9."}
]

var current_page : int = 0
var illness_index  = 0

func _ready():
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
	var texture = preload("res://sprites/ui/arrow.png")
	left_button.texture_normal = texture
	right_button.texture_normal = texture
	
	right_button.flip_h = true

	# Update the display
	update_page()

# Function to update the current page with illness info
func update_page():
	# Remove all previous items from both panels
	for child in left_panel.get_children():
		child.queue_free()
	for child in right_panel.get_children():
		child.queue_free()

	# Add illnesses to left and right panels
	for i in range(0,6):
		if illness_index >= illnesses.size():
			break
			
		var illness = illnesses[illness_index]

		# Create Labels for Illness Name and Details
		var name_label = Label.new()
		name_label.text = illness["name"]
		#name_label.add_stylebox_override("normal", preload("res://path_to_your_style.tres"))  # Optional larger text style
		if i < 3:
			left_panel.add_child(name_label)
		else:
			right_panel.add_child(name_label)

		var details_label = Label.new()
		details_label.text = illness["details"]
		#details_label.add_stylebox_override("normal", preload("res://path_to_your_style.tres"))  # Optional smaller text style
		if i < 3:
			left_panel.add_child(details_label)
		else:
			right_panel.add_child(details_label)

		# Update the panel index
		illness_index += 1
		if i  == 6:
			break  # Stop after adding 6 illnesses (3 for each panel)

	# Update button visibility based on the current page
	left_button.visible = current_page > 0  
	right_button.visible = (current_page * 6) + 6 < illnesses.size()


# Function to go to the previous page
func _on_left_button_pressed():
	current_page -= 1
	#reset index
	illness_index =current_page * 6
	update_page()

# Function to go to the next page
func _on_right_button_pressed():
	current_page += 1
	update_page()
	
func _on_close_button_pressed():
	back_pressed.emit()  # Emit the signal when the button is pressed
