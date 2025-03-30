extends TextureRect

@export var left_button : TextureButton
@export var right_button : TextureButton
@export var left_panel : VBoxContainer
@export var right_panel : VBoxContainer
@export var close_button: TextureButton

signal back_pressed  # Define a signal

var illnesses = [
	{"name": "Simple Cold   Flu", "details": "Symptoms: Congestion, headache, fatigue, mild fever.
 		Diagnosis: Likely a simple cold or flu.
 		Treatment: Herbal remedy like Lavender or Thornroot to reduce fever and clear congestion. A magical sleep potion to speed up recovery."},
	{"name": "Food Poisoning", "details": "Symptoms: Nausea, stomach ache, dizziness, occasional vomiting
 		Diagnosis: Likely food poisoning, possibly due to a toxic ingredient or spoiled food.
 		Treatment: Healing herbs such as Juniper to soothe the stomach, and a detoxifying potion to cleanse the system."},
	{"name": "Overexertion", "details": "Symptoms: Muscle soreness, fatigue, lightheadedness, occasional shortness of breath.
		 Diagnosis: Overexertion from physical labor, possibly compounded by dehydration or fatigue.
		 Treatment: Rest, hydration, and soothing muscle balm (made with herbs like Eucalyptus or Healing Herb). Encourage lighter activity in the future."},
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

		# Create name label
		var name_label = create_label(illness["name"], "res://fonts/Gorck Helozat Trial.ttf", 24, true)
		var details_label = create_label(illness["details"], "res://fonts/Gorck Helozat Trial.ttf", 12)

		# Determine the panel to add elements to
		var target_panel = left_panel if i < 3 else right_panel
		
		# Adding the elements
		target_panel.add_child(name_label)
		var separator = HSeparator.new()
		target_panel.add_child(separator)
		target_panel.add_child(details_label)
		
		illness_index += 1
	
	# Button visibility
	left_button.visible = current_page > 0  
	right_button.visible = (current_page * 6) + 6 < illnesses.size()

# Function to create and style a label
func create_label(text: String, font_path: String, font_size: int, bold: bool = false) -> Label:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.set("theme_override_colors/font_color", Color.BLACK)  

	var font = FontFile.new()
	font.font_data = load(font_path)

	var theme_override = Theme.new()
	theme_override.set_font("font", "Label", font)
	theme_override.set_font_size("font_size", "Label", font_size)

	label.theme = theme_override
	return label
	
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
