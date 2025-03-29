extends VBoxContainer

signal question_selected(question_text)

#todo: Children stretch to the size of the container properly

var questions = [
	"What is your name?",
	"Where are you from?",
	"What do you do?",
	"Can you tell me a secret?"
]

func _ready():
	create_question_buttons()

func create_question_buttons():
	# Remove any existing buttons
	for child in get_children():
		child.queue_free()

	# Loop through the questions and create buttons
	for question in questions:
		var button = Button.new()
		button.text = question
		button.size_flags_horizontal = SIZE_EXPAND_FILL  # Makes it scale nicely
		button.pressed.connect(_on_question_pressed.bind(question))
		add_child(button)

func _on_question_pressed(question_text):
	question_selected.emit(question_text)  # Emit signal to DialogueBox
