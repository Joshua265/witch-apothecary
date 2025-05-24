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

var resource = ResourceLoader.load(GameState.current_patient["questionSetScript"])

func _ready():
	#register to gamestate
	GameState.diagnosis_scene=self
	
	# Connect buttons safely
	if not ask_button.pressed.is_connected(_on_ask_pressed):
		ask_button.pressed.connect(_on_ask_pressed)

	if not inspect_button.pressed.is_connected(_on_inspect_pressed):
		inspect_button.pressed.connect(_on_inspect_pressed)

	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)

	if not diagnose_button.pressed.is_connected(_on_diagnose_pressed):
		diagnose_button.pressed.connect(_on_diagnose_pressed)

	# Connect question buttons
	for question_button in question_list.get_children():
		if question_button is Button:
			if not question_button.pressed.is_connected(_on_question_selected):
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
	#todo: Prolly better way to do this but I'm tired oof
	get_node("/root/Diagnosis/Book_of_Knowledge/TextureRect").diagnose_mode = true
	#todo: acting weird, not sure if we should call ready instead or make sep function?
	get_node("/root/Diagnosis/Book_of_Knowledge/TextureRect").update_page()
	get_node("/root/Diagnosis/Book_of_Knowledge")._on_bok_pressed()
	
