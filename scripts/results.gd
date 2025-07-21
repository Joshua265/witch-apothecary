extends Control

@export var action_list_node: VBoxContainer
@export var background_panel: Panel
@export var clipboard_panel: Panel
@export var hats : HBoxContainer

# Font size constants
const FONT_SIZE_HEADING = 28
const FONT_SIZE_SUBHEADING = 24
const FONT_SIZE_NORMAL = 20
const FONT_SIZE_SMALL = 18

func _ready() -> void:
	set_panel_background(background_panel, "res://background.png")
	#set_panel_background(clipboard_panel, "res://sprites/ui/clipboard.png")
	
	var symptoms_matched_in_diagnosis = GameState.current_matched_symptoms
	print("Symptoms matched during diagnosis (from GameState):", symptoms_matched_in_diagnosis)

	for child in action_list_node.get_children():
		child.queue_free()

	# Display result data
	add_label("Results of Diagnosis for %s" % GameState.character_manager.current_patient.name, FONT_SIZE_HEADING, true, HORIZONTAL_ALIGNMENT_CENTER)
	add_label("Actions remaining: %d" % GameState.action_manager.remaining_actions, FONT_SIZE_SMALL, true, HORIZONTAL_ALIGNMENT_CENTER)
	update_action_log()
	update_diagnosis_section()
	add_label("Final Points: %d" % GameState.level_manager.level_scores[GameState.level_manager.current_level].points, FONT_SIZE_NORMAL, true, HORIZONTAL_ALIGNMENT_CENTER)
	hats.update_hats(GameState.level_manager.current_level) # update hates visual


func set_panel_background(panel: Panel, texture_path: String) -> void:
	var texture = load(texture_path)
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = texture
	panel.add_theme_stylebox_override("panel", stylebox)


# Utility to create and add a label
func add_label(text: String, _size: int, _wrap: bool = false, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = alignment # Use the provided alignment parameter
	label.add_theme_font_size_override("font_size", _size)
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
	action_list_node.add_child(label)
	
	
func update_action_log() -> void:

	add_label("Actions Taken", FONT_SIZE_SUBHEADING, false, HORIZONTAL_ALIGNMENT_CENTER)

	var action_log = GameState.action_manager.action_log

	if action_log.is_empty():
		add_label("No actions taken", FONT_SIZE_SMALL)
	else:
		for action in action_log:
			add_label(action.text, FONT_SIZE_SMALL)

func update_diagnosis_section() -> void:
	var diagnosis = GameState.level_manager.level_scores[GameState.level_manager.current_level].diagnosis
	add_label("Diagnosis", FONT_SIZE_SUBHEADING, false, HORIZONTAL_ALIGNMENT_CENTER)
	add_label(
		"You diagnosed %s with %s" % [GameState.character_manager.current_patient.name, diagnosis],
		FONT_SIZE_NORMAL,
		true
	)

	var diagnosis_is_correct = GameState.level_manager.level_scores[GameState.level_manager.current_level].diagnosis_correct
	var matching_diagnosis = GameState.level_manager.result_data.probable_diagnosis
	var outcome_status = ""
	var feedback_message = ""
	var matched_symptoms_list_str = ""

	
	if diagnosis_is_correct:
		outcome_status = "correct"
	elif !diagnosis_is_correct:
		var found_partial_match = false
		var lower_player_diagnosis = diagnosis.to_lower()
		
		if GameState.current_matched_symptoms.is_empty():
			matched_symptoms_list_str = "none specific"
		else:
			# Join the symptoms with commas, and "and" for the last one
			if GameState.current_matched_symptoms.size() == 1:
				matched_symptoms_list_str = GameState.current_matched_symptoms[0]
			elif GameState.current_matched_symptoms.size() == 2:
				matched_symptoms_list_str = "%s and %s" % [GameState.current_matched_symptoms[0], GameState.current_matched_symptoms[1]]
			else:
				# For 3 or more, join all but last with comma, then "and" the last
				var temp_symptoms = GameState.current_matched_symptoms.duplicate()
				var last_symptom = temp_symptoms.pop_back() # Remove last item
				matched_symptoms_list_str = "%s and %s" % [", ".join(temp_symptoms), last_symptom]
				
		
		for potential_match_str in matching_diagnosis:
			var lower_potential_match_str = potential_match_str.to_lower()

			if lower_potential_match_str.find(lower_player_diagnosis) != -1:
				found_partial_match = true
				break
				
		if found_partial_match:
			outcome_status = "incorect" # Changed status for clarity
			# Construct the hint for what they should consider
			var hint_diagnosis_str = ""
			if matching_diagnosis.is_empty():
				hint_diagnosis_str = "the primary correct diagnosis." # its okay this is not posible
			elif matching_diagnosis.size() == 1:
				hint_diagnosis_str = matching_diagnosis[0] + "."
			else:
				var temp_probable = matching_diagnosis.duplicate()
				var last_probable = temp_probable.pop_back()
				hint_diagnosis_str = "%s or %s." % [", ".join(temp_probable), last_probable]

			feedback_message = "Yes, your diagnosis '%s' could be considered a good match as the matching symptoms are %s, but you should consider the context of the symptoms." % [
				diagnosis,
				matched_symptoms_list_str
			]
			
		else:
			outcome_status = "incorrect"
			feedback_message = "Unfortunately, your diagnosis was incorrect. As the symptoms are %s, you should review them more carefully." % [
				matched_symptoms_list_str
			]

	var outcome_text = "The diagnosis was %s" % outcome_status
	add_label(outcome_text, FONT_SIZE_SUBHEADING, true, HORIZONTAL_ALIGNMENT_CENTER) 

	# Add the detailed feedback message
	if !feedback_message.is_empty() and matched_symptoms_list_str != "none specific": # Only add if there's a message
		add_label(feedback_message, FONT_SIZE_NORMAL, true) # Display the detailed feedback

func _on_button_pressed() -> void:
	GameState.show_post_cutscene()
	
