extends Node

func match_symptoms(illness: Dictionary, patient_data: Dictionary) -> Array:
	var matched = []
	var rules = illness.get("matching_rules", {})

	for key in rules.keys():
		var rule = rules[key]
		if typeof(rule) == TYPE_DICTIONARY and rule.has("min"):
			if float(patient_data.get("temperature", 0)) >= rule["min"]:
				matched.append("fever")
		elif patient_data.get(key, false) == rule:
			matched.append(key)

	return matched


func highlight_symptoms_text(original: String, matched: Array) -> String:
	var highlighted = original

	for symptom in matched:
		if symptom == "fever" and original.to_lower().find("high fever") != -1:
			highlighted = highlighted.replace("high fever", "[color=yellow]high fever[/color]")
		else:
			var pattern = "\\b" + symptom + "\\b"
			highlighted = highlighted.replace_regex(pattern, "[color=yellow]" + symptom + "[/color]")

	return highlighted
