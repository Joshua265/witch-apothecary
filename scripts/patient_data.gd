extends Node

var patients = {
	1: {
		"level_image_path": "res://sprites/characters/seamstress.png",
		"precutsceneKey": "precutsceneL1",
		"postcutsceneKey": "postcutsceneL1",
		"questionsSetKey": "questionSetL1",
		"questionSetScript": "res://scripts/dialogue/questionSet1.dialogue",
		"cutscenescript": "res://scripts/dialogue/prologue1.dialogue",
		"name": "Helena",
		"age": 29,
		"occupation": "Seamstress",
		"illness": "Constipation",
		"correctdiagnosistext": "Yaay Helena lived",
		"wrongdiagnosistext": "Helena died oof...",
		"image_path": "res://sprites/characters/seamstress.png",
		"sitting_sprite" : "res://sprites/characters/seamstress_sitting.png",
		"temperature": "36.8",
		"heartrate": "75",
		"breathing": "16",
		"blood_pressure": "120/80",
		"history": "Helena described that she's been having bad headaches." #make this a array?
	},
	2: {
		"level_image_path": "res://sprites/characters/husband.png",
		"precutsceneKey": "precutsceneLevel2",
		"postcutsceneKey": "postcutsceneLevel2",
		"questionsSetKey": "questionSetL1",
		"questionSetScript": "res://scripts/dialogue/questionSet1.dialogue",
		"cutscenescript": "res://sprites/prologue1.dialogue",
		"name": "Jonathan",
		"age": 41,
		"occupation": "Carpenter",
		"illness": "Constipation",
		"correctdiagnosistext": "Yaay Helena lived",
		"wrongdiagnosistext": "Helena died oof...",
		"image_path": "res://sprites/characters/husband.png",
		"sitting_sprite" : "res://sprites/characters/husband.png",
		"temperature": "36.8",
		"heartrate": "75",
		"breathing": "16",
		"history": "Jonathan mentions frequent dizziness after working in the sun."
	},
	"More": {
		"level_image_path": "res://sprites/characters/witch_cool.png",
		"name": "Comming Soon!",
	}
}
