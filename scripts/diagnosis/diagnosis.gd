extends Control

@export var ask_button: Button
@export var inspect_button: Button
@export var diagnose_button: Button
@export var back_button: Button
@export var question_list: ScrollContainer
@export var inspect_list: ScrollContainer
@export var ui_container: Control 
@export var main_action_container: HBoxContainer
@export var character: TextureRect
@export var background: TextureRect
@export var clipboard: Panel

var resource = ResourceLoader.load("res://test_dialogue.dialogue")

func _ready():
	# Connect buttons
	ask_button.pressed.connect(_on_ask_pressed)
	inspect_button.pressed.connect(_on_inspect_pressed)
	back_button.pressed.connect(_on_back_pressed)
	diagnose_button.pressed.connect(_on_diagnose_pressed)

	for question_button in question_list.get_children():
		if question_button is Button:
			question_button.pressed.connect(_on_question_selected.bind(question_button.text))

	# Initially hide irrelevant UI elements
	question_list.hide()
	inspect_list.hide()
	back_button.hide()

func _on_ask_pressed():
	main_action_container.hide()
	question_list.show()
	back_button.show()
	
func _on_inspect_pressed():
	main_action_container.hide()
	inspect_list.show()
	back_button.show()
	
func _on_back_pressed():
	main_action_container.show()
	question_list.hide()
	inspect_list.hide()
	back_button.hide()

func _on_question_selected(next_id:String):
	question_list.hide()
	back_button.hide()
	clipboard.hide()
	var dialogue_line = await DialogueManager.show_dialogue_balloon(resource, next_id)
	
func _on_diagnose_pressed():
	print("Diagnose pressed")

	
