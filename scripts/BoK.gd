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

#todo: Move to own script [Done]
var illnesses = BoKIllnesses.illnesses
const BoKHighlighter = preload("res://scripts/Bok_Highlighter.gd")


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

func reset_pages():
	current_page = 0
	illness_index = 0


# Function to update the current page with illness info
func update_page():	
	# fix for consistancy 
	illness_index = current_page * 2 * ILLNESSES_PER_PAGE
	
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

		# Highlight only the Symptoms section
			var text = illness["info"][section]
			#if section == "Symptoms":
				#var revealed = GameState.current_patient["revealed_info"]
				#print("the infor revealed " + str(revealed))
				#var matched = BoKHighlighter.match_symptoms(illness, revealed)
				#text = BoKHighlighter.highlight_symptoms_text(text, matched)
			var lbl = create_label("[b]" + section + "[/b]: " + text, 14)
			target_panel.add_child(lbl)
		
		illness_index += 1
	
	# Button visibility
	left_button.visible = current_page > 0  
	right_button.visible = (current_page + 1) * 2 * ILLNESSES_PER_PAGE < illnesses.size()

func create_label_button(text: String, font_size: int, bold: bool = false) -> Button:
	var button = Button.new()
	button.text = text
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", Color.BLACK)
	button.add_theme_color_override("font_disabled_color", Color.BLACK)
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

func _on_confirm_diagnosis() -> void:
	diagnose_mode = false
	##move on to post level scene
	##todo: not dynamic yet, this sets level1!
	SceneTransitionManager.change_to_cutscene(
		GameState.current_patient["cutscenescript"],
		GameState.current_patient["postcutsceneKey"],
		"res://scenes/results.tscn"
	)

func _on_no_pressed() -> void:
	popup.hide()
