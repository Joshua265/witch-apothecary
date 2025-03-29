extends Panel
#todo: Rework this into the script for control on top maybe? 

@export var ask_button : Button
@export var examine_button : Button
@export var diagnosis_button : Button
@export var scroll_container : ScrollContainer

@export var edge_buffer : float = 20  # Distance from edge to start scrolling
@export var scroll_speed : float = 10  # Speed of the automatic scroll

"""
func _process(delta):
	var mouse_position = get_local_mouse_position()
	var container_size = scroll_container.rect_min_size

	# Horizontal scrolling
	if mouse_position.x < edge_buffer:
		# Scroll left
		scroll_container.scroll_horizontal -= scroll_speed * delta
	elif mouse_position.x > container_size.x - edge_buffer:
		# Scroll right
		scroll_container.scroll_horizontal += scroll_speed * delta

	# Vertical scrolling
	if mouse_position.y < edge_buffer:
		# Scroll up
		scroll_container.scroll_vertical -= scroll_speed * delta
	elif mouse_position.y > container_size.y - edge_buffer:
		# Scroll down
		scroll_container.scroll_vertical += scroll_speed * delta
"""

func _ready():
	# Connect button signals
	examine_button.pressed.connect(_on_examine_button_pressed)
	diagnosis_button.pressed.connect(_on_diagnosis_button_pressed)
	
	# Add more initialization if needed

func _on_examine_button_pressed():
	# Trigger examination action
	print("Examining patient")

func _on_diagnosis_button_pressed():
	# Trigger diagnosis action
	print("Making diagnosis")
