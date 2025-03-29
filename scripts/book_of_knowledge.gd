extends Control

@export var bok : Control
@export var animation_player : AnimationPlayer 
@export var bok_button: TextureButton

var book_content_instance 

func _ready():
	bok_button.pressed.connect(_on_bok_pressed)
	
	 # Load the BookContent scene
	book_content_instance = preload("res://scenes/book_of_knowledge.tscn").instantiate()
	add_child(book_content_instance)  # Add the BookContent instance to the parent scene
	
	# Connect the back_button_pressed signal from BookContent to a function in the parent
	var panel_node = book_content_instance.get_node("Panel(temp)")
	panel_node.back_pressed.connect(_on_back_button_pressed)
	
func _on_bok_pressed():
	#hide everything else
	animation_player.play("show")

func _on_back_button_pressed():
	animation_player.play_backwards("show")
