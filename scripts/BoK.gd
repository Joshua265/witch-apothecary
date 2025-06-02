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
signal illness_selected(illness_name: String)

const ILLNESSES_PER_PAGE = 2
var current_page : int = 0
var illness_index  = 0
var diagnose_mode = false

var illnesses = []
var bok_manager = null

func _ready():
	popup.hide()

	left_button.pressed.connect(Callable(self, "_on_left_button_pressed"))
	right_button.pressed.connect(Callable(self, "_on_right_button_pressed"))
	close_button.pressed.connect(Callable(self, "_on_close_button_pressed"))
	popup_yes_button.pressed.connect(Callable(self, "_on_confirm_diagnosis"))
	popup_no_button.pressed.connect(Callable(self, "_on_no_pressed"))

	var button_texture = preload("res://sprites/ui/arrow.png")
	left_button.texture_normal = button_texture
	right_button.texture_normal = button_texture
	right_button.flip_h = true

	# Get reference to BoKManager node
	bok_manager = get_node("/root/BoKManager")
	if bok_manager:
		bok_manager.connect("illness_changed", self, "_on_illnesses_changed")

func _on_illnesses_changed(new_illnesses):
	illnesses = []
	current_page = 0
	illness_index = 0
	if typeof(new_illnesses) == TYPE_DICTIONARY and "illnesses" in new_illnesses:
		illnesses = new_illnesses["illnesses"]
	elif typeof(new_illnesses) == TYPE_ARRAY:
		illnesses = new_illnesses
	update_page()

func update_page():
	for child in left_panel.get_children():
		child.queue_free()
	for child in right_panel.get_children():
		child.queue_free()

	for i in range(0, ILLNESSES_PER_PAGE * 2):
		if illness_index >= illnesses.size():
			break
		var illness = illnesses[illness_index]

		var target_panel = left_panel if i < ILLNESSES_PER_PAGE else right_panel

		var name_label = create_label_button(illness["name"], 24, true)
		target_panel.add_child(name_label)

		var separator = HSeparator.new()
		target_panel.add_child(separator)

		for section in illness["info"]:
			var section_label = create_label("[b]" + section + "[/b]: " + illness["info"][section], 14)
			target_panel.add_child(section_label)

		illness_index += 1

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
	back_pressed.emit()

func _on_illness_pressed(illness_name: String):
	popup.show()
	popup_text.text = "Do you want to confirm?\n" + illness_name
	emit_signal("illness_selected", illness_name)

func _on_confirm_diagnosis() -> void:
	diagnose_mode = false
	popup.hide()
	# Emit signal or call method to proceed with diagnosis confirmation
	# This can be connected externally to handle scene transition or other logic

func _on_no_pressed() -> void:
	popup.hide()
