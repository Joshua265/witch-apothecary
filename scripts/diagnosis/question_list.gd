extends VBoxContainer

signal question_selected(question_text)
var resource = ResourceLoader.load(GameState.current_patient["questionSetScript"])

func _ready():
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource,GameState.current_patient["questionsSetKey"])
	_generate_question_buttons(dialogue_line);

func _generate_question_buttons(dialogue_line):
	for res in dialogue_line.responses:
		var button := Button.new()
		button.text = res.text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): _on_question_pressed(res.next_id,res.text))
		add_child(button)
# check here maybe it works
func _on_question_pressed(next_id: String, question:String):
	question_selected.emit(next_id)  # Emit signal to DialogueBox
	# add the string to the action log!
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You asked" + str(question))
