extends Node

class_name BoKHighlighter

var revealed_info = []
var revealed_vitals = {}

func _ready() -> void:
	# Connect to signals from GameState to reset revealed info
	GameState.action_manager.connect("action_used", Callable(self, "_on_action_used"))

# Extract literal symptom keywords + ignore negations
func extract_keywords(text: String) -> Array:
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
func extract_vitals(text: String) -> Dictionary:
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
func escape_regex(text: String) -> String:
	var specials := ["\\", ".", "+", "*", "?", "^", "$", "(", ")", "[", "]", "{", "}", "|"]
	for c in specials:
		text = text.replace(c, "\\" + c)
	return text

# fixes the lower case and upper case problems i had
func match_phrase_from_symptoms(symptoms: String, keyword: String) -> String:
	var lower_symptoms = symptoms.to_lower()
	var lower_keyword = keyword.to_lower()

	var index := lower_symptoms.find(lower_keyword)
	if index != -1:
		return symptoms.substr(index, keyword.length()) # returns original
	return "" # if no found


# mathcing based on the information saved
func match_symptoms(illness: IllnessData) -> Array:
	var matched := []
	var rules = illness.matching_rules


# loop through the matching_rules for each illness
	for key in rules.keys():
		var rule = rules[key]

		# highlight based on the history revealed by user
		if typeof(rule) == TYPE_BOOL and rule:
			if key in revealed_info:
				matched.append(key)
			continue

		#highlighting based on inspections + specific word mapping inplicit
		elif typeof(rule) == TYPE_DICTIONARY:

			# Use patient data and check if inspection was performed
			var patient_data = GameState.clipboard_manager.patient_data

			if key == "temperature" and rule.has("min"):
				if GameState.action_manager.was_inspected("temperature"):
					var tv = patient_data.temperature
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
				if GameState.action_manager.was_inspected("breathing"):
					var bv = float(patient_data.breathing)
					var min_b = float(String(rule["min"]).split(" ")[0])
					var sym_text_b = illness["info"]["Symptoms"]
					var match_b = match_phrase_from_symptoms(sym_text_b, "shortness of breath")
					if bv >= min_b and match_b != "":
						matched.append(match_b)
				continue

			if key == "heartrate" and rule.has("min"):
				if GameState.action_manager.was_inspected("heartrate"):
					var hv = patient_data.heartrate
					var min_hr = float(String(rule["min"]).split(" ")[0])
					var sym_text_h = illness["info"]["Symptoms"]
					var match_h = match_phrase_from_symptoms(sym_text_h, "racing heartbeat")
					if hv >= min_hr and match_h != "":
						matched.append(match_h)
				continue

			# added but not used as of now
			if key == "blood_pressure" and rule.has("min_sys"):
				if GameState.action_manager.was_inspected("blood_pressure"):
					# PatientData stores blood pressure as "sys/dia"
					var sys_val = 0.0
					if patient_data.blood_pressure.find("/") != -1:
						sys_val = float(patient_data.blood_pressure.split("/")[0])
					var min_sys = float(String(rule["min_sys"]).split(" ")[0])
					var sym_text_bp = illness["info"]["Symptoms"]
					var match_bp = match_phrase_from_symptoms(sym_text_bp, "high blood pressure")
					# only match if the book’s symptom text contains “high blood pressure”
					if sys_val >= min_sys and match_bp != "":
						matched.append(match_bp)
				continue

	return matched



# just highlights the words specifically
func highlight_symptoms_text(original: String, matched: Array) -> String:
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

func _on_action_used(action_id: String) -> void:
	var action_log_idx = GameState.action_manager.action_log.find(
		func(item): return item.action_id == action_id
	)
	var action_log_item = GameState.action_manager.action_log[action_log_idx]
	add_revealed_info(action_log_item.text)

# neededdd for the highlighting
func add_revealed_info(text: String) -> void:
	# preprocessing done - based on input
	var keywords = extract_keywords(text)
	var vitals   = extract_vitals(text)

	# Add each keyword into the Array if it’s not already there
	for keyword in keywords:
		if not revealed_info.has(keyword):
			revealed_info.append(keyword)

	# Add each numeric vital into the Dictionary (overwrites if already exists)
	for vital_key in vitals.keys():
		revealed_vitals[vital_key] = vitals[vital_key]

func reset() -> void:
	# Reset the revealed info and vitals
	revealed_info.clear()
	revealed_vitals.clear()
