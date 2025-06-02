extends Node

class_name ContentLoader

signal content_loaded(content_type: String, data)

func load_level_data(levelIndex: int) -> LevelData:
	# Return static level data example, ignoring index for now
	var level = LevelData.levels[levelIndex - 1]
	emit_signal("content_loaded", "level", level)
	return level

func load_character_data(characterKey: String) -> CharacterData:
	var character = CharacterData.characters[characterKey]
	emit_signal("content_loaded", "character", character)
	return character

func load_patient_data(patientIndex: int) -> PatientData:
	# Return static patient data example, ignoring level for now
	var patient = PatientData.patients[patientIndex]
	emit_signal("content_loaded", "patient", patient)
	return patient

func load_bok_data(illnessIndices: Array[int]) -> Array[IllnessData]:
	# Return static illness data as array of dictionaries
	var illnesses = []
	if illnessIndices.size() > 0:
		illnesses = []
		for index in illnessIndices:
			if index >= 0 and index < IllnessData.illnesses.size():
				illnesses.append(IllnessData.illnesses[index])
			else:
				print("Invalid illness index: ", index)
	else:
		print("No illness indices provided, returning all illnesses.")
		illnesses = IllnessData.illnesses
	emit_signal("content_loaded", "bok", illnesses)
	return illnesses
