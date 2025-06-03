extends Node

# ──────────────────────────────────────────────────────────────────────────────
# 1) Extract literal symptom keywords, skipping any “no X” or “not X” mentions.
static func extract_keywords(text: String) -> Array:
	var symptom_keywords = [
		"sore throat",
		"shortness of breath",
		"fatigue",
		"tired",
		"dizzy",
		"dizziness",
		"headaches",
		"headache",
		"congestion",
		"nausea",
		"rash",
		"pain",
		"sore",
		"cough",
		"stress",
		"anxiety"
	]
	var found := []
	var lower = text.to_lower()
	
	for keyword in symptom_keywords:
		# Skip “not X” or “no X” by negative‐lookbehind:
		var escaped = escape_regex(keyword)
		var pattern = r"(?<!\bno\s)(?<!\bnot\s)\b" + escaped + r"\b"
		
		var re = RegEx.new()
		if re.compile(pattern) != OK:
			continue
		if re.search(lower):
			found.append(keyword)
			print("extract_keywords: matched literal → ", keyword)
	
	return found


# ──────────────────────────────────────────────────────────────────────────────
# 2) Extract numeric vitals (temperature, pulse, breathing) from the text only.
static func extract_vitals(text: String) -> Dictionary:
	var vitals = {}
	var lower = text.to_lower()
	var re = RegEx.new()

	# (A) Look for “(\d+(\.\d+)?) °C” or “celsius”
	re.compile(r"(\d+(?:\.\d+)?)\s*(°c|celsius)")
	var m_temp = re.search(lower)
	if m_temp:
		vitals["temperature"] = float(m_temp.get_string(1))
		print("extract_vitals: parsed temperature → ", vitals["temperature"])

	# (B) Look for “(\d+) bpm” or “beats per minute”
	re.compile(r"(\d+)\s*(bpm|beats per minute)")
	var m_pulse = re.search(lower)
	if m_pulse:
		vitals["pulse"] = int(m_pulse.get_string(1))
		print("extract_vitals: parsed pulse → ", vitals["pulse"])

	# (C) Look for “(\d+) br/min” or “breaths per minute”
	re.compile(r"(\d+)\s*(br/min|breaths per minute)")
	var m_breath = re.search(lower)
	if m_breath:
		vitals["breathing"] = int(m_breath.get_string(1))
		print("extract_vitals: parsed breathing → ", vitals["breathing"])

	return vitals


# ──────────────────────────────────────────────────────────────────────────────
# 3) Build a combined “revealed_info” struct:
#    - keywords[] from extract_keywords
#    - vitals{} from extract_vitals
static func gather_revealed_info(text: String) -> Dictionary:
	var info := {}
	info.keywords = extract_keywords(text)
	info.vitals   = extract_vitals(text)
	return info
	# At this point, info.keywords might be ["dizziness","headaches"]
	# and info.vitals might be { "temperature": 38.7, "pulse": 110 }


# ──────────────────────────────────────────────────────────────────────────────
# 4) Match each illness’s rules, including “mild fever” vs “fever” vs “high fever,” etc.
static func match_symptoms(illness: Dictionary, revealed_info) -> Array:
	# Determine if revealed_info is the old Array‐only form, or the new Dictionary form
	var keywords: Array = []
	var vitals: Dictionary = {}
	
	if typeof(revealed_info) == TYPE_ARRAY:
		# Legacy call: revealed_info is just an Array of keyword strings
		keywords = revealed_info.duplicate()
		# No numeric vitals are available in this case
		#vitals = {}
		#print("here in vitals maybe empty " + str(vitals))
		
	
	elif typeof(revealed_info) == TYPE_DICTIONARY:
		# New style: revealed_info has both .keywords (Array) and .vitals (Dictionary)
		keywords = revealed_info.get("keywords", [])
		vitals = revealed_info.get("vitals", {})
		print("here in vitals here added: " + str(vitals))
	
	else:
		# Unexpected type: bail out with nothing matched
		push_error("match_symptoms(): revealed_info must be Array or Dictionary, got " + str(typeof(revealed_info)))
		return []
	

	var matched := []
	var rules = illness.get("matching_rules", {})

	for key in rules.keys():
		var rule = rules[key]

		# —————————————————————————————————————————————
		# 1) Boolean‐true rules (e.g. "fatigue": true, "cough": true, ...)
		if typeof(rule) == TYPE_BOOL and rule:
			if key in keywords:
				matched.append(key)
				print("match_symptoms: boolean match → ", key)
				continue

		# —————————————————————————————————————————————
		# 2) Numeric rules (e.g. "temperature": { "min":"38.5 °C" })
		elif typeof(rule) == TYPE_DICTIONARY and rule.has("min"):
			var min_val = float(String(rule["min"]).split(" ")[0])

			# 2A) Temperature logic → map numeric °C to "mild fever"/"fever"/"high fever"
			print("wtf has the vitals?? " + str(vitals))
			if key == "temperature" and vitals.has("temperature"):
				var temp_val = vitals["temperature"]
				if temp_val >= 39.5:
					matched.append("high fever")
					print("match_symptoms: numeric match → high fever (", temp_val, "°C )")
				elif temp_val >= min_val:
					matched.append("fever")
					print("match_symptoms: numeric match → fever (", temp_val, "°C )")
				elif temp_val >= 37.5:
					matched.append("mild fever")
					print("match_symptoms: numeric match → mild fever (", temp_val, "°C )")
				continue

			# 2B) Pulse logic → match "heart_rate" if bpm ≥ min
			if key == "pulse" and vitals.has("pulse"):
				var pulse_val = vitals["pulse"]
				if pulse_val >= min_val:
					matched.append("heart_rate")
					print("match_symptoms: numeric match → heart_rate (", pulse_val, " bpm )")
				continue

			# 2C) Breathing logic → match "breathing" if br/min ≥ min
			if key == "breathing" and vitals.has("breathing"):
				var breath_val = vitals["breathing"]
				if breath_val >= min_val:
					matched.append("breathing")
					print("match_symptoms: numeric match → breathing (", breath_val, " br/min )")
				continue

	return matched



# ──────────────────────────────────────────────────────────────────────────────
# 5) Escape special regex characters in a keyword or multi-word phrase
static func escape_regex(text: String) -> String:
	var specials := ["\\", ".", "+", "*", "?", "^", "$", "(", ")", "[", "]", "{", "}", "|"]
	for c in specials:
		text = text.replace(c, "\\" + c)
	return text


# ──────────────────────────────────────────────────────────────────────────────
# 6) Wrap each matched symptom in [color=violet]…[/color] in the “book” text
static func highlight_symptoms_text(original: String, matched: Array) -> String:
	var out := original
	for sym in matched:
		var escaped_sym := escape_regex(sym)
		var pattern := "\\b" + escaped_sym + "\\b"
		var regex := RegEx.new()
		if regex.compile(pattern) != OK:
			continue
		var result := ""
		var last_end := 0
		var matches := regex.search_all(out)
		for m in matches:
			result += out.substr(last_end, m.get_start() - last_end)
			result += "[color=violet]" + out.substr(m.get_start(), m.get_end() - m.get_start()) + "[/color]"
			last_end = m.get_end()
		result += out.substr(last_end)
		out = result
	return out
