extends Control

@export var bok: Control
@export var animation_player: AnimationPlayer
@export var bok_button: Button

var book_content_instance

func _ready():
	# Connect the BoK button to open the book
	bok_button.pressed.connect(_on_bok_pressed)

	# Try to connect the back button signal from inside the book panel
	var panel_node = bok.get_node("TextureRect")
	if panel_node.has_signal("back_pressed"):
		panel_node.back_pressed.connect(_on_back_button_pressed)
	else:
		push_warning("TextureRect node is missing the 'back_pressed' signal.")

func _on_bok_pressed():
	open_book()

func _on_back_button_pressed():
	close_book()

func open_book():
	animation_player.play("show")

func close_book():
	animation_player.play_backwards("show")

	# Access the TextureRect inside the book and reset diagnose mode + update
	var texture_rect = bok.get_node("TextureRect")
	if texture_rect:
		if texture_rect.has_method("update_page"):
			texture_rect.diagnose_mode = false
			texture_rect.update_page()
		else:
			push_warning("TextureRect node is missing 'update_page' method.")
	else:
		push_error("TextureRect not found under bok.")
