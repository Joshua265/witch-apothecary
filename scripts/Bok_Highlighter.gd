extends Node

# Extract symptom keywords from any line of text
static func extract_keywords(text: String) -> Array:
    var symptom_keywords = [
        "fatigue", "tired", "dizzy", "dizziness", "fever",
        "headaches", "headache", "congestion", "nausea",
        "rash", "pain", "sore", "cough", "shortness of breath",
        "stress", "anxiety"
    ]
    var found = []
    var lower = text.to_lower()
    for w in symptom_keywords:
        if lower.find(w) != -1:
            found.append(w)
    return found

# Extract numeric vitals reported in text
static func extract_vitals(text: String) -> Dictionary:
    var vitals = {}
    var lower = text.to_lower()
    var re = RegEx.new()

    # Temperature (°C)
    re.compile(r"(\d+(?:\.\d+)?)\s*(°c|celsius)")
    var m = re.search(lower)
    if m:
        vitals["temperature"] = float(m.get_string(1))

    # Pulse (bpm)
    re.compile(r"(\d+)\s*(bpm|beats per minute)")
    m = re.search(lower)
    if m:
        vitals["pulse"] = int(m.get_string(1))

    # Breathing (br/min)
    re.compile(r"(\d+)\s*(br/min|breaths per minute)")
    m = re.search(lower)
    if m:
        vitals["breathing"] = int(m.get_string(1))

    return vitals

# Match against illness rules using revealed_info keys and actual patient data
static func match_symptoms(illness: Dictionary, revealed_info: Array) -> Array:
    var matched = []
    var rules = illness.get("matching_rules", {})
    for key in rules.keys():
        var rule = rules[key]
        if typeof(rule) == TYPE_BOOL and rule and key in revealed_info:
            matched.append(key)
        elif typeof(rule) == TYPE_DICTIONARY and rule.has("min") and key in revealed_info:
            var val = GameState.current_patient.get(key, 0)
            var min_val = float(str(rule["min"]).split(" ")[0])
            if val >= min_val:
                matched.append(key)
    return matched

# Highlight matched words in the Symptoms text
static func highlight_symptoms_text(original: String, matched: Array) -> String:
    var out = original.duplicate()
    for sym in matched:
        var pat = "\\b" + RegEx.escape(sym) + "\\b"
        out = out.replace_regex(pat, "[color=yellow]" + sym + "[/color]")
    return out
