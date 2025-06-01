extends VBoxContainer

signal question_selected(question_text)

# load the dialogue resource
var resource = ResourceLoader.load(GameState.current_patient["questionSetScript"])
var current_question_id: String  # tracks where we are in the dialogue


# TODO: needs to change for the second level- maybe also another file - add to the patient.. file
var question_summaries := {
	"1": "Helena reports persistent fatigue over the past few weeks, worsened by long working hours with minimal breaks.",
	"2": "Helena reports a slight rise in temperature over the last few days, along with occasional dizziness.",
	"3": "Helena has not experienced sore throat or cough, but reports dizziness and headaches.",
	"4": "Helena reports inadequate hydration and limited diet, which could be contributing to her symptoms of fatigue and dizziness.",
	"5": "Helena reports recurring headaches around her forehead and temples, which worsen with prolonged work without breaks.",
	"6": "Helena reports dizziness occurring after standing up or long hours of work, possibly linked to dehydration.",
	"7": "Helena reports an elevated heart rate, especially under stress or prolonged work, which could indicate stress-induced tachycardia.",
	"8": "Helena denies experiencing shortness of breath, which helps rule out some respiratory conditions.",
	"9": "Helena reports getting only 4-5 hours of sleep each night, which could be contributing to her fatigue and overall condition.",
	"10": "Helena reports no changes in her menstrual cycle, ruling out hormonal imbalances as a factor.",
	"11": "Helena admits to not taking regular breaks during work, which could be contributing to her fatigue."
}

func _ready():
	current_question_id = GameState.current_patient["questionsSetKey"]
	var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, current_question_id)
	_generate_question_buttons(dialogue_line);	#_generate_question_buttons(dialogue_line)

func _generate_question_buttons(dialogue_line) -> void:
	#for child in get_children():
	#	child.queue_free()

	for res in dialogue_line.responses:
		var button := Button.new()
		button.text = res.text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		button.pressed.connect(func(): _on_question_pressed(res.next_id,res.text))
		add_child(button)

		
func _on_question_pressed(next_id: String, question: String) -> void:
	#print("id: " + next_id)
	#if question_summaries.has(next_id):
	#	var summary: String = question_summaries[next_id]
	#	GameState.add_revealed_info(summary)
	#	print("-------------saves for highlighting")
	#	get_node("/root/Diagnosis/Interaction/Clipboard/frame").add_history_text(summary)

	# 4) update our tracker, then fetch & display the next questions
	#current_question_id = next_id
	#var next_dialogue = await DialogueManager.get_next_dialogue_line(resource, current_question_id)
	print("check here ....")
	#_generate_question_buttons(next_dialogue)
	
	question_selected.emit(next_id)
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You asked: " + question)
