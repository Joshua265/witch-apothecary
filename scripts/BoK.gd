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
	{"name": "Dehydration", "details": "Symptoms: Dry mouth, dizziness, fainting spells, fatigue.
 			Tools: Pulse check, skin elasticity test, temperature check.
 			Diagnosis: Likely dehydration, possibly from not drinking enough water or overexertion.
 			Treatment: Rehydration potions or water infused with hydrating herbs like Aloe and Waterleaf. Rest and frequent small sips of water."},
	{"name": "Sprained Ankle", "details": "Symptoms: Swelling, pain, difficulty moving.
		 Tools: Visual inspection, gentle touch to assess pain response, temperature check.
		 Diagnosis: A sprained ankle or minor injury to the joints.
		 Treatment: Cooling herbal poultice made with Arnica and Ice Fern. Rest and elevate the injured limb. If swelling persists, check for broken bones using magical diagnostics (or simple x-ray equivalent)."},
	{"name": "Sore Throat (Viral or Allergic)", "details": "Symptoms: Sore throat, mild cough, swollen lymph nodes, slight fever.
		 Tools: Temperature check, throat inspection.
		 Diagnosis: Viral infection or mild allergic reaction.
		 Treatment: Soothing tea with herbs like Sage and Thyme, or a mild magic potion to relieve throat irritation. Advise rest for the voice."},
	{"name": "Rash / Skin Irritation", "details": "Symptoms: Redness, itching, possibly bumps or welts.
		 Tools: Skin inspection, pulse check, questioning about recent exposure to plants or chemicals.
		 Diagnosis: Likely a mild allergic reaction, or contact with an irritant like poison ivy or a magical herb.
		 Treatment: Herbal salve made with Calendula and Aloe, or a light magical healing touch to ease irritation."},
	{"name": "Constipation", "details": "Symptoms: Abdominal discomfort, bloating, infrequent bowel movements.
		 Tools: Abdominal palpation, questioning about diet.
		 Diagnosis: Likely constipation, possibly due to diet or stress.
		 Treatment: Gentle laxative herbs like Senna or a magical potion to encourage digestion. Suggest dietary changes (more fiber, fluids) for long-term relief."},
	{"name": "Ear Infection", "details": "Symptoms: Ear pain, possibly fever, muffled hearing.
		 Tools: Ear inspection with a magical diagnostic tool.
		 Diagnosis: Likely an ear infection, possibly viral or bacterial.
		 Treatment: Healing herbs like Garlic and Echinacea for antibacterial properties, or a magical spell to clear the infection. Recommend resting and avoiding loud noises."},
	{"name": "Anxiety / Stress-Induced Symptoms", "details": "Symptoms: Racing heartbeat, shortness of breath, sweating, restlessness.
		 Tools: Pulse check, deep breathing assessment.
		 Diagnosis: Anxiety or stress-induced physical symptoms.
		 Treatment: Calming herbs such as Chamomile or Lemon Balm. Use relaxation techniques like deep breathing or a calming magic spell. Suggest taking breaks and managing stress levels."},
	{"name": "Sinus Infection", "details": "Symptoms: Nasal congestion, headache, pressure in the face, cough, mild fever.
		 Tools: Temperature check, inspection of nasal passages.
		 Diagnosis: Likely sinus infection.
		 Treatment: Decongesting herbal remedies like Eucalyptus, and a steam bath infused with these herbs. Encourage the patient to rest and stay hydrated."}
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
