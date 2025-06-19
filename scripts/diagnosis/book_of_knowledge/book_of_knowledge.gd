class_name BookOfKnowledge

extends TextureRect


var illnesses: Array[IllnessData]

var currentIllness: String

# Book UI and Animation
@export var diagnose_mode: bool

# Signals
signal back_pressed
signal diagnosis_selected(illness_name: String)
signal open_confirmation_dialog(text: String)

# Book logic variables
const ILLNESSES_PER_PAGE = 2
var current_page : int = 0
var illness_index  = 0

var bok_manager = null

func _ready() -> void:
	connect("open_confirmation_dialog", Callable($ConfirmationDialog, "_on_open_dialog"))
	$ConfirmationDialog.connect("yes_confirmation_dialog", Callable(self, "_on_confirmation_diagnosis"))
	GameState.bok_manager.connect("bok_loaded", Callable(self, "_on_bok_loaded"))
	connect("diagnosis_selected", Callable(GameState.bok_manager, "_on_diagnosis_selected"))
	$Left_Flip.pressed.connect(Callable(self, "_on_left_button_pressed"))
	$Right_Flip.pressed.connect(Callable(self, "_on_right_button_pressed"))
	$Close_Button.pressed.connect(Callable(self, "_on_close_button_pressed"))

	var button_texture = preload("res://sprites/ui/arrow.png")
	$Left_Flip.texture_normal = button_texture
	$Right_Flip.texture_normal = button_texture
	$Right_Flip.flip_h = true

func _on_bok_loaded(_illnesses: Array[IllnessData]) -> void:
	illnesses = _illnesses
	illness_index = 0
	current_page = 0
	update_page()

func _on_bok_pressed():
	open_book()

func _on_back_button_pressed():
	close_book()

func open_book():
	$AnimationPlayer.play("show")

func close_book():
	$AnimationPlayer.play_backwards("show")
	# Reset diagnose mode and update page
	update_page()

func _on_illnesses_changed(new_illnesses: Array[IllnessData]):
	illnesses.append(new_illnesses)
	update_page()

func update_page():
	for child in $HBoxContainer/Left_VBox.get_children():
		child.queue_free()
	for child in $HBoxContainer/Right_VBox.get_children():
		child.queue_free()

	illness_index = current_page * 2 * ILLNESSES_PER_PAGE

	for i in range(0, ILLNESSES_PER_PAGE * 2):
		if illness_index >= illnesses.size():
			break
		var illness = illnesses[illness_index]

		var target_panel = $HBoxContainer/Left_VBox if i < ILLNESSES_PER_PAGE else $HBoxContainer/Right_VBox

		var name_label = create_label_button(illness["name"], 24, true)
		target_panel.add_child(name_label)

		var separator = HSeparator.new()
		target_panel.add_child(separator)

		for section in illness["info"]:
			var section_label = create_label("[b]" + section + "[/b]: " + illness["info"][section], 14)
			target_panel.add_child(section_label)

		illness_index += 1

	$Left_Flip.visible = current_page > 0
	$Right_Flip.visible = (current_page * 2 * ILLNESSES_PER_PAGE) + (2 * ILLNESSES_PER_PAGE) < illnesses.size()

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

	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER

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

	label.add_theme_font_size_override("normal_font_size", font_size)
	label.add_theme_color_override("default_color", Color.BLACK)

	return label

func _on_left_button_pressed():
	current_page -= 1
	illness_index = current_page * 2 * ILLNESSES_PER_PAGE
	update_page()

func _on_right_button_pressed():
	current_page += 1
	update_page()

func _on_close_button_pressed():
	close_book()
	back_pressed.emit()

func _on_illness_pressed(illness_name: String):
	emit_signal("open_confirmation_dialog", "Do you want to select " + illness_name + " as the diagnosis?")


func _on_bo_k_button_pressed() -> void:
	open_book()

func _on_confirmation_diagnosis() -> void:
	GameState.select_diagnosis(currentIllness)
