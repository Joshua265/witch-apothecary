extends Control

@export var ask_button: Button
@export var inspect_button: Button
@export var diagnose_button: Button
@export var back_button: Button
@export var question_list: ScrollContainer
@export var ui_container: Control 
@export var character: TextureRect
@export var background: TextureRect

var resource = ResourceLoader.load("res://dialogue_test.dialogue")

func _ready():
	# Connect buttons
	ask_button.pressed.connect(_on_ask_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	for question_button in question_list.get_children():
		if question_button is Button:
			question_button.pressed.connect(_on_question_selected.bind(question_button.text))

	# Initially hide irrelevant UI elements
	question_list.hide()
	back_button.hide()

func _on_ask_pressed():
	question_list.show()
	back_button.show()
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
	#todo: Not optional, just for now : D how can we handle the key better?
	var dialogue_key = "default_key"  

	# Match the selected question to the correct dialogue key
	if question_text == "What is your name?":
		dialogue_key = "ask_name"
	elif question_text == "Where are you from?":
		dialogue_key = "ask_origin"
	elif question_text == "What do you do?":
		dialogue_key = "ask_job"
	elif question_text == "Can you tell me a secret?":
		dialogue_key = "ask_secret"

	var dialogue_line = await DialogueManager.show_dialogue_balloon(resource, dialogue_key)
