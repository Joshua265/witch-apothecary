extends VBoxContainer

# load the dialogue resource
signal question_selected(question_text)
var resource = ResourceLoader.load(GameState.current_patient["questionSetScript"])


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
	var dialogue_line = await DialogueManager.get_next_dialogue_line(
		resource,
		GameState.current_patient["questionsSetKey"]
		)
	_generate_question_buttons(dialogue_line)

func _generate_question_buttons(dialogue_line) -> void:
	for res in dialogue_line.responses:
		var button := Button.new()
		button.text = res.text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): _on_question_pressed(res.next_id,res.text))
		add_child(button)

func _on_question_pressed(next_id: String, question: String) -> void:
	question_selected.emit(next_id)
	print("id: " + next_id)
	# i kept the original action log line
	get_node("/root/Diagnosis/ActionCounter").add_action_log("You asked " + str(question))

	# i added the following lines so that after the player clicks, we fetch the next
	# dialogue line and regenerate buttons automatically.
	var next_dialogue = await DialogueManager.get_next_dialogue_line(resource, next_id)
	_generate_question_buttons(next_dialogue)
	
	
	

func getcorrectSummary(summary_id: String) -> void:
	if not question_summaries.has(summary_id):
		push_error("getcorrectSummary(): No summary found for key '" + summary_id + "'")
		return

	var summary_text = question_summaries[summary_id]

	# i did that because we still want to store the revealed info in GameState
	GameState.add_revealed_info(summary_text)
	#check maybe this is a problem
	get_node("/root/Diagnosis/Interaction/Clipboard/frame").add_history_text(summary_text)


	print("getcorrectSummary(): saved summary #" + summary_id + " → " + summary_text)
