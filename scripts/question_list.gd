extends VBoxContainer

var resource = load("res://dialogue_test.dialogue")

func _ready():
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
	_generate_question_buttons(dialogue_line);

func _generate_question_buttons(dialog_line):
	# Remove existing buttons before generating new ones
	for child in get_children():
		child.queue_free()
		
	if not dialog_line:
		return;
	
	# Create Dialog Text Panel
	var dialogue_label = Label.new();
	dialogue_label.text = dialog_line.text;
	dialogue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	add_child(dialogue_label);
	if dialog_line.responses.size() == 0:
		var next_button = Button.new();
		next_button.text = "Next";
		next_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		next_button.pressed.connect(func(): _on_question_pressed(
			dialog_line.next_id
		))
		add_child(next_button)
	else:
		# Create buttons dynamically for each question
		for res in dialog_line.responses:
			var button := Button.new()
			button.text = res.text
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.pressed.connect(func(): _on_question_pressed(res.next_id))
			add_child(button)

func _on_question_pressed(next_id: String):
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, next_id)
	_generate_question_buttons(dialogue_line);
