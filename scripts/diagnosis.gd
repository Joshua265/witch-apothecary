extends Control

@export var ask_button: Button
@export var inspect_button: Button
@export var diagnose_button: Button
@export var back_button: Button
@export var question_list : ScrollContainer
@export var dialogue_box: Control
@export var dialogue_label: RichTextLabel
@export var ui_container: Control 
@export var character: TextureRect
@export var background: TextureRect

var dialogue_queue = []
var is_dialogue_active = false

func _ready():
	# Connect signals
	ask_button.pressed.connect(_on_ask_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	for question_button in question_list.get_children():
		if question_button is Button:
			question_button.pressed.connect(_on_question_selected.bind(question_button.text))
	
	# Initially hide irrelevant stuff
	question_list.hide()
	dialogue_box.hide()
	back_button.hide()

func _on_ask_pressed():
	# Show the question list and back button
	question_list.show()
	back_button.show()

	# Hide other UI elements
	ask_button.hide()
	diagnose_button.hide()
	inspect_button.hide()
	
func _on_back_pressed():
	question_list.hide()
	back_button.hide()
	
	ask_button.show()
	diagnose_button.show()
	inspect_button.show()
	
func _on_question_selected(question_text):
	# Hide UI and show only the background and character
	ui_container.hide() #todo: ui_container.hide doesnt work, so I added the two beneath. fix that
	question_list.hide()
	back_button.hide()
	
	# Fetch the dialogue for the selected question
	dialogue_queue = get_dialogue_for_question(question_text)
	is_dialogue_active = true
	
	# Show the dialogue box and start the dialogue
	dialogue_box.show()
	display_next_dialogue()

func display_next_dialogue():
	if dialogue_queue.size() > 0:
		dialogue_label.text = dialogue_queue.pop_front()
	else:
		end_dialogue()

func _input(event):
	# Advance dialogue on mouse click or spacebar
	if is_dialogue_active and event is InputEventMouseButton and event.pressed:
		display_next_dialogue()

func end_dialogue():
	# Hide the dialogue box and show UI again
	dialogue_box.hide()
	
	#Placeholder for ui_container not working :(
	ui_container.show()
	question_list.show()
	back_button.show()
	
	is_dialogue_active = false

func get_dialogue_for_question(question_text):
	var dialogues = {
		"What is your name?": ["My name is Lilia.", "Nice to meet you."],
		"Where are you from?": ["I come from the capital city.", "It's a beautiful place."],
		"What do you do?": ["I work as a historian.", "I study ancient texts."]
	}
	return dialogues.get(question_text, ["I don't know how to answer that."])
