extends Control

@export var action_list_node: VBoxContainer
@export var background_panel: Panel
@export var clipboard_panel: Panel


# Font size constants
const FONT_SIZE_HEADING = 26
const FONT_SIZE_SUBHEADING = 22
const FONT_SIZE_NORMAL = 18
const FONT_SIZE_SMALL = 16

func _ready() -> void:
	GameState.result_scene = self
	set_panel_background(background_panel, "res://background.png")
	set_panel_background(clipboard_panel, "res://sprites/ui/clipboard.png")
	
	for child in action_list_node.get_children():
		child.queue_free()
	
	# Display result data
	add_label("Results of Diagnosis for %s" % GameState.current_patient["name"], FONT_SIZE_HEADING, true)
	add_label("Actions remaining: %d" % GameState.actions_remaining, FONT_SIZE_SMALL)
	update_action_log()
	update_diagnosis_section()
	add_label("Final Points: %d" % calculate_final_points(), FONT_SIZE_NORMAL)

func set_panel_background(panel: Panel, texture_path: String) -> void:
	var texture = load(texture_path)
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = texture
	panel.add_theme_stylebox_override("panel", stylebox)


# Utility to create and add a label
func add_label(text: String, size: int, wrap: bool = false) -> void:
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", size)
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
	action_list_node.add_child(label)

func update_action_log() -> void:

	add_label("Actions Taken", FONT_SIZE_SUBHEADING)

	var action_log = GameState.action_log

	if action_log.is_empty():
		add_label("No actions taken", FONT_SIZE_SMALL)
	else:
		for action in action_log:
			add_label(action, FONT_SIZE_SMALL)

func update_diagnosis_section() -> void:
	add_label("Diagnosis", FONT_SIZE_SUBHEADING)

	add_label(
		"You diagnosed %s with %s" % [GameState.current_patient["name"], GameState.current_illness],
		FONT_SIZE_NORMAL,
		true
	)

	var outcome_text = GameState.current_patient["correctdiagnosistext"] if GameState.current_patient["illness"] == GameState.current_illness else GameState.current_patient["wrongdiagnosistext"]
	add_label(outcome_text, FONT_SIZE_SMALL, true)

func calculate_final_points() -> int:
	# Replace this logic later
	return 100 + 50

func _on_button_pressed() -> void:
	GameState.unlock_level(GameState.current_level + 1)
	var level_select_scene = preload("res://scenes/level_select.tscn")
	SceneTransitionManager.change_scene(level_select_scene)
