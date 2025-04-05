extends VBoxContainer

signal question_selected(question_text)

@export var questions: Array[String] = [
	"What is your name?",
	"Where are you from?",
	"What do you do?",
	"Can you tell me a secret?"
]

func _ready():
	_generate_question_buttons()

func _generate_question_buttons():
	# Remove existing buttons before generating new ones
	for child in get_children():
		child.queue_free()

	# Create buttons dynamically for each question
	for question in questions:
		var button := Button.new()
		button.text = question
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): _on_question_pressed(question))
		add_child(button)

func _on_question_pressed(question_text: String):
	question_selected.emit(question_text)  # Emit signal to DialogueBox
