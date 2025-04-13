extends VBoxContainer

signal question_selected(question_text)
#not ideal since we double load? eventually make it a autoload? 
var resource = ResourceLoader.load("res://test_dialogue.dialogue")

func _ready():
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
	_generate_question_buttons(dialogue_line);


func _generate_question_buttons(dialogue_line):
	for res in dialogue_line.responses:
		var button := Button.new()
		button.text = res.text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): _on_question_pressed(res.next_id))
		add_child(button)

func _on_question_pressed(next_id: String):
	question_selected.emit(next_id)  # Emit signal to DialogueBox
