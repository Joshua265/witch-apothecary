extends Control

@export var bok : Control
@export var animation_player : AnimationPlayer 
@export var bok_button: TextureButton

var book_content_instance 

func _ready():
	bok_button.pressed.connect(_on_bok_pressed)
	
	# Connect the back_button_pressed signal from BookContent to a function in the parent
	var panel_node = bok.get_node("TextureRect")
	panel_node.back_pressed.connect(_on_back_button_pressed)
	
func _on_bok_pressed():
	#hide everything else
	animation_player.play("show")

func _on_back_button_pressed():
	animation_player.play_backwards("show")
