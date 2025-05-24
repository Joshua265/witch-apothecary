extends TextureRect

@export var left_button : TextureButton
@export var right_button : TextureButton
@export var left_panel : VBoxContainer
@export var right_panel : VBoxContainer
@export var close_button: TextureButton
@export var popup : Panel
@export var popup_text : Label
@export var popup_yes_button: Button
@export var popup_no_button: Button

signal back_pressed  # Define a signal

const ILLNESSES_PER_PAGE = 2
var current_page : int = 0
var illness_index  = 0
var diagnose_mode = false
#todo: Move pop up to own script (Reuseable for other stuff too)

#todo: Move to own script
var illnesses = [
  {
	"name": "Simple Cold/Flu",
	"info": {
		"Symptoms": "Congestion, headache, fatigue, and mild fever." , 
		"Diagnosis": "Likely a viral upper respiratory infection (common cold or influenza).",
		"Treatment": "Supportive care with rest, hydration, and herbal supplements such as elderberry extract, echinacea, pelargonium sidoides extract, and warming ginger/garlic teas."
		}
  },
  {
	"name": "Food Poisoning",
	"info": {
		"Symptoms": "Nausea, abdominal pain, dizziness, and occasional vomiting.",
		"Diagnosis": "Likely due to ingestion of contaminated food resulting in foodborne illness.",
		"Treatment": "Supportive care with oral rehydration and electrolyte replacement; complementary options include ginger tea (for nausea), peppermint tea (to ease stomach discomfort), and chamomile tea (to soothe gastrointestinal irritation)."
		}
  },
  {
	"name": "Overexertion",
	"info": {
		"Symptoms": "Muscle soreness, fatigue, lightheadedness, and occasional shortness of breath.",
		"Diagnosis": "Likely related to overexertion compounded by dehydration.",
		"Treatment": "Rest and increased fluid intake; complementary herbal treatments include topical arnica montana cream to reduce pain and inflammation, and ginger (via massage oil or compress) to ease muscle soreness."
	}
  },
  {
	"name": "Dehydration",
	"info": {
		"Symptoms": "Dry mouth, dizziness, episodes of fainting, and fatigue.",
		"Diagnosis": "Likely caused by insufficient fluid intake or excessive fluid loss (e.g., from exertion).",
		"Treatment": "Prompt rehydration with fluids and electrolytes; consider hydrating herbal options like aloe vera juice to provide both water and gentle gastrointestinal soothing."
	}
  },
  {
	"name": "Sprained Ankle",
	"info": {
		"Symptoms": "Swelling, pain, and difficulty in movement of the ankle.",
		"Diagnosis": "Likely an acute sprain involving the ankle ligaments.",
		"Treatment": "Begin with RICE therapy (rest, ice, compression, elevation) and complement with topical arnica montana cream and cooled chamomile tea compresses to reduce inflammation."
	}
  },
  {
	"name": "Sore Throat (Viral or Allergic)",
	"info": {
		"Symptoms": "Sore throat, mild cough, swollen lymph nodes, and slight fever.",
		"Diagnosis": "Likely due to a viral infection or mild allergic reaction.",
		"Treatment": "Support with warm saltwater gargles and fluid intake; herbal options include teas made from sage and thyme (for their antimicrobial and anti-inflammatory properties), marshmallow root or slippery elm (to soothe mucous membranes), licorice root, and chamomile tea."
	}
  },
  {
	"name": "Rash / Skin Irritation",
	"info": {
		"Symptoms": "Redness, itching, and possible bumps or welts on the skin.",
		"Diagnosis": "Likely a localized allergic reaction or contact irritation.",
		"Treatment": "Topical application of herbal preparations such as calendula officinalis ointment, aloe vera gel, or chamomile extract to reduce inflammation and promote healing."
	}
		
  },
  {
	"name": "Constipation",
	"info": {
		"Symptoms": "Abdominal discomfort, bloating, and infrequent or difficult bowel movements.",
		"Diagnosis": "Likely related to low dietary fiber, inadequate fluid intake, or stress-related changes in bowel motility.",
		"Treatment": "Increase dietary fiber and fluids; for short-term relief, use herbal stimulant laxatives such as senna (Senna alexandrina) to promote bowel movements."
	}	
  },
  {
	"name": "Ear Infection",
	"info": {
		"Symptoms": "Ear pain, mild fever, and muffled hearing.",
		"Diagnosis": "Likely acute otitis media or outer ear infection of viral or bacterial origin.",
		"Treatment": "Standard management includes maintaining ear hygiene and pain control; complementary herbal options may include carefully prepared garlic-mullein oil drops to leverage antimicrobial properties, and (if appropriate) diluted tea tree oil preparations. Use these remedies only under professional guidance."
	}
		
  },
  {
	"name": "Anxiety / Stress-Induced Symptoms",
	"info": {
		"Symptoms": "Racing heartbeat, shortness of breath, sweating, and restlessness.",
		"Diagnosis": "Symptoms consistent with anxiety or stress-related conditions.",
		"Treatment": "Along with standard stress management practices (e.g., deep breathing, mindfulness), consider herbal support such as lemon balm tea, chamomile, valerian root, and optionally passionflower or lavender (via teas or aromatherapy) to promote relaxation."
	}
		
  },
  {
	"name": "Sinus Infection",
	"info": {
		"Symptoms": "Nasal congestion, headache, facial pressure, cough, and mild fever.",
		"Diagnosis": "Likely acute sinusitis, commonly of viral origin.",
		"Treatment": "Supportive care with hydration, rest, and steam inhalation; complementary herbal therapies include the use of eucalyptus oil (in steam inhalation), peppermint oil (for its cooling decongestant effects), and thyme tea for its antimicrobial support."
	}
		
  }
];

func _ready():
	#hide popup initially
	popup.hide()
	
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
	var button_texture = preload("res://sprites/ui/arrow.png")
	left_button.texture_normal = button_texture
	right_button.texture_normal = button_texture
	
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
	for i in range(0,ILLNESSES_PER_PAGE * 2):
		if illness_index >= illnesses.size():
			break
		var illness = illnesses[illness_index]


		# Determine the panel to add elements to
		var target_panel = left_panel if i < ILLNESSES_PER_PAGE else right_panel
		
		# Create name label
		#todo: Only name is pickable right now- should we make a button, that just has both as their text?
		#var name_label = create_label(illness["name"],24, true)
		var name_label= create_label_button(illness["name"], 24, true)
		target_panel.add_child(name_label)
		
		var separator = HSeparator.new()
		target_panel.add_child(separator)
		
		# Create and add formatted info sections
		for section in illness["info"]:
			var section_label = create_label("[b]" + section + "[/b]: " + illness["info"][section], 14)
			target_panel.add_child(section_label)
		
		illness_index += 1
	
	# Button visibility
	left_button.visible = current_page > 0  
	right_button.visible = (current_page * 2 * ILLNESSES_PER_PAGE) + (2 * ILLNESSES_PER_PAGE) < illnesses.size()

func create_label_button(text: String, font_size: int, bold: bool = false) -> Button:
	var button = Button.new()
	button.text = text
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", Color.BLACK)
	button.add_theme_color_override("font_disabled_color", Color.DIM_GRAY)
	button.autowrap_mode = true
	if !diagnose_mode:
		button.disabled = true

	# Make it fill horizontally
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Padding to behave like a label
	button.add_theme_constant_override("content_margin_left", 4)
	button.add_theme_constant_override("content_margin_right", 4)
	button.add_theme_constant_override("content_margin_top", 2)
	button.add_theme_constant_override("content_margin_bottom", 2)

	button.pressed.connect(func(): _on_illness_pressed(button.text))
	return button
	
func create_label(text: String, font_size: int) -> RichTextLabel:
	var label = RichTextLabel.new()
	label.text = text
	label.set_use_bbcode(true)
	label.fit_content = true
	label.scroll_active = false
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	# Override only the font size and color using global theme
	label.add_theme_font_size_override("normal_font_size", font_size)
	label.add_theme_color_override("default_color", Color.BLACK)
	
	return label

# Function to go to the previous page
func _on_left_button_pressed():
	current_page -= 1
	#reset index
	illness_index =current_page * 2 * ILLNESSES_PER_PAGE
	update_page()

# Function to go to the next page
func _on_right_button_pressed():
	current_page += 1
	update_page()
	
func _on_close_button_pressed():
	back_pressed.emit()  # Emit the signal when the button is pressed

func _on_illness_pressed(illnessName:String):
	popup.show()
	popup_text.text = "Do you want to confirm?\n" + illnessName
	
	#todo: Find a better place to do this
	GameState.current_illness = illnessName 

# ahh i got it -> maybe add a list of things done wrong or correctly??
func _on_confirm_diagnosis() -> void:
	diagnose_mode = false
	#update_page()
	##move on to post level scene
	##todo: not dynamic yet, this sets level1!
	SceneTransitionManager.change_to_cutscene(
		GameState.current_patient["cutscenescript"],
		GameState.current_patient["postcutsceneKey"],
		"res://scenes/results.tscn"
	)

func _on_no_pressed() -> void:
	popup.hide()
