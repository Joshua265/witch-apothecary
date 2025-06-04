extends Node

# Extract literal symptom keywords + ignore negations
static func extract_keywords(text: String) -> Array:
	var symptom_keywords = [ "sore throat", "shortness of breath", "fatigue",
		"tired", "dizzy", "dizziness", "headaches", "headache", "congestion",
		"nausea", "rash", "pain", "sore", "cough", "stress", "anxiety", "nausea",
		"abdominal pain", "vomiting", "bloating", "constipation", "ear pain",
		"swelling", "itching", "bumps", "welts", "skin", "irritation",
		"restlessness", "sweating"]
	var found := []
	var lower = text.to_lower()

	for keyword in symptom_keywords:
		# Skip if preceded by “no ” or “not ” - maybe adjust if other inputs added
		var escaped = escape_regex(keyword)
		var pattern = r"(?<!\bno\s)(?<!\bnot\s)\b" + escaped + r"\b"
		var re = RegEx.new()
		if re.compile(pattern) != OK:
			continue
		if re.search(lower):
			found.append(keyword)
			print("[extract_keywords] matched → ", keyword)
	return found

# Extract vitals now only for temp, breathing, pulse, blood pressure
static func extract_vitals(text: String) -> Dictionary:
	var vitals = {}
	var lower = text.to_lower()
	var re = RegEx.new()

	# Temperature 
	re.compile(r"(\d+(?:\.\d+)?)\s*(°c|celsius)")
	var m_temp = re.search(lower)
	if m_temp:
		vitals["temperature"] = float(m_temp.get_string(1))
		print("[extract_vitals] parsed temperature → ", vitals["temperature"])

	# Pulse/ Heart Rate
	re.compile(r"(\d+)\s*(bpm|beats per minute)")
	var m_hr = re.search(lower)
	if m_hr:
		vitals["heartrate"] = int(m_hr.get_string(1))
		print("[extract_vitals] heartrate → ", vitals["heartrate"])

	# Blood Pressure 
	re.compile(r"(\d+)\s*/\s*(\d+)\s*mmhg")
	var m_bp = re.search(lower)
	if m_bp:
		vitals["blood_pressure_systolic"]  = int(m_bp.get_string(1))
		vitals["blood_pressure_diastolic"] = int(m_bp.get_string(2))
		print("[extract_vitals] bp → ", vitals["blood_pressure_systolic"], "/", vitals["blood_pressure_diastolic"])
		
	# Breathing 
	re.compile(r"(\d+)\s*(br/min|breaths per minute)")
	var m_breath = re.search(lower)
	if m_breath:
		vitals["breathing"] = int(m_breath.get_string(1))
		print("[extract_vitals] parsed breathing → ", vitals["breathing"])

	return vitals


# Escaping needed for highlighting the word
static func escape_regex(text: String) -> String:
	var specials := ["\\", ".", "+", "*", "?", "^", "$", "(", ")", "[", "]", "{", "}", "|"]
	for c in specials:
		text = text.replace(c, "\\" + c)
	return text

# fixes the lower case and upper case problems i had
static func match_phrase_from_symptoms(symptoms: String, keyword: String) -> String:
	var lower_symptoms = symptoms.to_lower()
	var lower_keyword = keyword.to_lower()

	var index := lower_symptoms.find(lower_keyword)
	if index != -1:
		return symptoms.substr(index, keyword.length()) # returns original
	return "" # if no found


# mathcing based on the information saved
static func match_symptoms(illness: Dictionary) -> Array:
	var matched := []
	var rules = illness.get("matching_rules", {})

	# fetch from gamestate
	var keywords: Array = []
	if GameState.current_patient.has("revealed_info"):
		keywords = GameState.current_patient["revealed_info"].duplicate()

	var vitals: Dictionary = {}
	if GameState.current_patient.has("revealed_vitals"):
		vitals = GameState.current_patient["revealed_vitals"].duplicate()

# loop through the matching_rules for each illness
	for key in rules.keys():
		var rule = rules[key]

		# highlight based on the history revealed by user
		if typeof(rule) == TYPE_BOOL and rule:
			if key in keywords:
				matched.append(key)
			continue

		#highlighting based on inspections + specific word mapping inplicit
		elif typeof(rule) == TYPE_DICTIONARY:

			if key == "temperature" and rule.has("min"):
				var min_val = float(String(rule["min"]).split(" ")[0])
				if vitals.has("temperature"):
					var tv = vitals["temperature"]
					var sym_text = illness["info"]["Symptoms"].to_lower()
					if tv >= 39.5:
						var match = match_phrase_from_symptoms(sym_text, "high fever")
						matched.append(match)
					elif tv >= 38.5:
						var match = match_phrase_from_symptoms(sym_text, "mild fever")
						matched.append(match)
					elif tv >= 37.5:
						var match = match_phrase_from_symptoms(sym_text, "slight fever")
						matched.append(match)
				continue

			if key == "breathing" and rule.has("min"):
				var min_b = float(String(rule["min"]).split(" ")[0])
				if vitals.has("breathing"):
					var bv = vitals["breathing"]
					var sym_text_b = illness["info"]["Symptoms"]
					var match_b = match_phrase_from_symptoms(sym_text_b, "shortness of breath")
					if bv >= min_b and match_b != "": 
						matched.append(match_b)
				continue

			if key == "heartrate" and rule.has("min"):
				var min_hr = float(String(rule["min"]).split(" ")[0])
				if vitals.has("heartrate"):
					var hv = vitals["heartrate"]
					var sym_text_h = illness["info"]["Symptoms"]
					var match_h = match_phrase_from_symptoms(sym_text_h, "racing heartbeat")
					if hv >= min_hr and match_h != "": 
						matched.append(match_h)
				continue

			# added but not used as of now
			if key == "blood_pressure" and rule.has("min_sys"):
				var min_sys = float(String(rule["min_sys"]).split(" ")[0])
				if vitals.has("blood_pressure_systolic"):
					var sys_val = vitals["blood_pressure_systolic"]
					var sym_text_bp = illness["info"]["Symptoms"]
					var match_bp = match_phrase_from_symptoms(sym_text_bp, "high blood pressure")
					# only match if the book’s symptom text contains “high blood pressure”
					if sys_val >= min_sys and match_bp != "":
						matched.append(match_bp)
				continue

	return matched



# just highlights the words specifically 
static func highlight_symptoms_text(original: String, matched: Array) -> String:
	var out := original

	for sym in matched:
		var variants := [sym]
		# specifically for headaches and headache but works for more word in plural
		if sym.ends_with("s"):
			var singular = sym.substr(0, sym.length() - 1)
			variants.append(singular)

		for term in variants:
			var escaped = escape_regex(term)
			var pattern = "\\b" + escaped + "\\b"
			var regex = RegEx.new()
			if regex.compile(pattern) != OK:
				continue

			var result := ""
			var last_end := 0
			var matches := regex.search_all(out)
			for m in matches:
				result += out.substr(last_end, m.get_start() - last_end)
				# TODO: is just violet - maybe another color better idk
				result += "[color=violet]" + out.substr(m.get_start(), m.get_end() - m.get_start()) + "[/color]"
				last_end = m.get_end()
			result += out.substr(last_end)
			out = result
	return out
