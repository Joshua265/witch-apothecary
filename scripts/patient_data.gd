extends Node

# todo: Image_path should be a folder to the images?
# More dynamic for different emotions bla bla but its okay like this for now
var patients = {
	1: {
		"precutsceneKey": "precutsceneL1",
		"postcutsceneKey": "postcutsceneL1",
		"questionsSetKey": "questionSetL1",
		"questionSetScript": "res://scripts/dialogue/questionSet1.dialogue",
		"cutscenescript": "res://scripts/dialogue/prologue1.dialogue",
		"name": "Helena",
		"age": 29,
		"occupation": "Seamstress",
		"image_path": "res://sprites/characters/seamstress.png",
		"sitting_sprite" : "res://sprites/characters/seamstress_sitting.png",
		"temperature": "Not checked yet.",
		"heartrate": "Not checked yet.",
		"history": "Helena described that she's been having bad headaches." #make this a array?
	},
	2: {
		"precutsceneKey": "precutsceneLevel2",
		"postcutsceneKey": "postcutsceneLevel2",
		"questionsSetKey": "questionSetL1",
		"questionSetScript": "res://scripts/dialogue/questionSet1.dialogue",
		"cutscenescript": "res://sprites/prologue1.dialogue",
		"name": "Jonathan",
		"age": 41,
		"occupation": "Carpenter",
		"image_path": "res://sprites/characters/husband.png",
		"sitting_sprite" : "res://sprites/characters/husband.png",
		"temperature": "Not checked yet.",
		"heartrate": "Not checked yet.",
		"history": "Jonathan mentions frequent dizziness after working in the sun."
	}
}
