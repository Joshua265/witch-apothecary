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
#todo: maybe we should move popup stuff to its own script
var diagnose_mode = false

var illnesses = [
  {
	"name": "Simple Cold/Flu",
	"details": "[i]Symptoms[/i]: Congestion, headache, fatigue, and mild fever.\n" +
			   "[i]Diagnosis[/i]: Likely a viral upper respiratory infection (common cold or influenza).\n" +
			   "[i]Treatment[/i]: Supportive care with rest, hydration, and herbal supplements such as elderberry extract, echinacea, pelargonium sidoides extract, and warming ginger/garlic teas."
  },
  {
	"name": "Food Poisoning",
	"details": "[i]Symptoms[/i]: Nausea, abdominal pain, dizziness, and occasional vomiting.\n" +
			   "[i]Diagnosis[/i]: Likely due to ingestion of contaminated food resulting in foodborne illness.\n" +
			   "[i]Treatment[/i]: Supportive care with oral rehydration and electrolyte replacement; complementary options include ginger tea (for nausea), peppermint tea (to ease stomach discomfort), and chamomile tea (to soothe gastrointestinal irritation)."
  },
  {
	"name": "Overexertion",
	"details": "[i]Symptoms[/i]: Muscle soreness, fatigue, lightheadedness, and occasional shortness of breath.\n" +
			   "[i]Diagnosis[/i]: Likely related to overexertion compounded by dehydration.\n" +
			   "[i]Treatment[/i]: Rest and increased fluid intake; complementary herbal treatments include topical arnica montana cream to reduce pain and inflammation, and ginger (via massage oil or compress) to ease muscle soreness."
  },
  {
	"name": "Dehydration",
	"details": "[i]Symptoms[/i]: Dry mouth, dizziness, episodes of fainting, and fatigue.\n" +
			   "[i]Diagnosis[/i]: Likely caused by insufficient fluid intake or excessive fluid loss (e.g., from exertion).\n" +
			   "[i]Treatment[/i]: Prompt rehydration with fluids and electrolytes; consider hydrating herbal options like aloe vera juice to provide both water and gentle gastrointestinal soothing."
  },
  {
	"name": "Sprained Ankle",
	"details": "[i]Symptoms[/i]: Swelling, pain, and difficulty in movement of the ankle.\n" +
			   "[i]Diagnosis[/i]: Likely an acute sprain involving the ankle ligaments.\n" +
			   "[i]Treatment[/i]: Begin with RICE therapy (rest, ice, compression, elevation) and complement with topical arnica montana cream and cooled chamomile tea compresses to reduce inflammation."
  },
  {
	"name": "Sore Throat (Viral or Allergic)",
	"details": "[i]Symptoms[/i]: Sore throat, mild cough, swollen lymph nodes, and slight fever.\n" +
			   "[i]Diagnosis[/i]: Likely due to a viral infection or mild allergic reaction.\n" +
			   "[i]Treatment[/i]: Support with warm saltwater gargles and fluid intake; herbal options include teas made from sage and thyme (for their antimicrobial and anti-inflammatory properties), marshmallow root or slippery elm (to soothe mucous membranes), licorice root, and chamomile tea."
  },
  {
	"name": "Rash / Skin Irritation",
	"details": "[i]Symptoms[/i]: Redness, itching, and possible bumps or welts on the skin.\n" +
			   "[i]Diagnosis[/i]: Likely a localized allergic reaction or contact irritation.\n" +
			   "[i]Treatment[/i]: Topical application of herbal preparations such as calendula officinalis ointment, aloe vera gel, or chamomile extract to reduce inflammation and promote healing."
  },
  {
	"name": "Constipation",
	"details": "[i]Symptoms[/i]: Abdominal discomfort, bloating, and infrequent or difficult bowel movements.\n" +
			   "[i]Diagnosis[/i]: Likely related to low dietary fiber, inadequate fluid intake, or stress-related changes in bowel motility.\n" +
			   "[i]Treatment[/i]: Increase dietary fiber and fluids; for short-term relief, use herbal stimulant laxatives such as senna (Senna alexandrina) to promote bowel movements."
  },
  {
	"name": "Ear Infection",
	"details": "[i]Symptoms[/i]: Ear pain, mild fever, and muffled hearing.\n" +
			   "[i]Diagnosis[/i]: Likely acute otitis media or outer ear infection of viral or bacterial origin.\n" +
			   "[i]Treatment[/i]: Standard management includes maintaining ear hygiene and pain control; complementary herbal options may include carefully prepared garlic-mullein oil drops to leverage antimicrobial properties, and (if appropriate) diluted tea tree oil preparations. Use these remedies only under professional guidance."
  },
  {
	"name": "Anxiety / Stress-Induced Symptoms",
	"details": "[i]Symptoms[/i]: Racing heartbeat, shortness of breath, sweating, and restlessness.\n" +
			   "[i]Diagnosis[/i]: Symptoms consistent with anxiety or stress-related conditions.\n" +
			   "[i]Treatment[/i]: Along with standard stress management practices (e.g., deep breathing, mindfulness), consider herbal support such as lemon balm tea, chamomile, valerian root, and optionally passionflower or lavender (via teas or aromatherapy) to promote relaxation."
  },
  {
	"name": "Sinus Infection",
	"details": "[i]Symptoms[/i]: Nasal congestion, headache, facial pressure, cough, and mild fever.\n" +
			   "[i]Diagnosis[/i]: Likely acute sinusitis, commonly of viral origin.\n" +
			   "[i]Treatment[/i]: Supportive care with hydration, rest, and steam inhalation; complementary herbal therapies include the use of eucalyptus oil (in steam inhalation), peppermint oil (for its cooling decongestant effects), and thyme tea for its antimicrobial support."
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

		# Create name label
		#todo: Only name is pickable right now- should we make a button, that just has both as their text?
		#var name_label = create_label(illness["name"],24, true)
		var name_label= create_label_button(illness["name"], 24, true)
		var details_label = create_label(illness["details"], 12)
		#var details_label = create_label_button(illness["details"], 12)


		# Determine the panel to add elements to
		var target_panel = left_panel if i < ILLNESSES_PER_PAGE else right_panel
		
		# Adding the elements
		target_panel.add_child(name_label)
		var separator = HSeparator.new()
		target_panel.add_child(separator)
		target_panel.add_child(details_label)
		
		illness_index += 1
	
	# Button visibility
	left_button.visible = current_page > 0  
	right_button.visible = (current_page * 2 * ILLNESSES_PER_PAGE) + (2 * ILLNESSES_PER_PAGE) < illnesses.size()

func create_label_button(text: String, font_size: int, bold: bool = false) -> Button:
	var button = Button.new()
	button.text = text
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.autowrap_mode = true
	if !diagnose_mode:
		button.disabled = true

	# Make it fill horizontally
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Do we need this?
	button.custom_minimum_size.y = 30

	# Theme override
	var theme_override = Theme.new()
	var font = FontFile.new()
	font.font_data = load("res://fonts/Gorck Helozat Trial.ttf")
	# Set font size override
	button.theme = null
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("color", Color.BLACK)
	theme_override.set_font("font", "Button", font)
	#theme_override.set_color("font","Button",Color.BLACK) 'todo: how to set it to black? maybe make a theme and just set it here instead of all of this!
	
	# Padding to behave like a label
	button.add_theme_constant_override("content_margin_left", 4)
	button.add_theme_constant_override("content_margin_right", 4)
	button.add_theme_constant_override("content_margin_top", 2)
	button.add_theme_constant_override("content_margin_bottom", 2)

	button.pressed.connect(func(): _on_illness_pressed(button.text))
	return button
	
#Function to create and style a label
func create_label(text: String,font_size: int, bold: bool = false) -> Label:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD

	var theme_override = Theme.new()
	theme_override.set_font_size("font_size", "Label", font_size)

	label.theme = theme_override
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
	popup_text.text = "Do you want to confirm?" + illnessName

func _on_confirm_diagnosis() -> void:
	diagnose_mode = false
	update_page()
	# todo: close BoK again or move on to cutscene which would hide whole Diagnosis Node anyways!
	
func _on_no_pressed() -> void:
	popup.hide()
