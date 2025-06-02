class_name IllnessData

var name: String
var info: Dictionary

func _init(initial_name: String, initial_info: Dictionary) -> void:
	self.name = initial_name
	self.info = initial_info

static var illnesses = [
		IllnessData.new("Simple Cold/Flu", {
			"Symptoms": "Congestion, headache, fatigue, and mild fever.",
			"Diagnosis": "Likely a viral upper respiratory infection (common cold or influenza).",
			"Treatment": "Supportive care with rest, hydration, and herbal supplements such as elderberry extract, echinacea, pelargonium sidoides extract, and warming ginger/garlic teas."
		}),
		IllnessData.new("Food Poisoning", {
			"Symptoms": "Nausea, abdominal pain, dizziness, and occasional vomiting.",
			"Diagnosis": "Likely due to ingestion of contaminated food resulting in foodborne illness.",
			"Treatment": "Supportive care with oral rehydration and electrolyte replacement; complementary options include ginger tea (for nausea), peppermint tea (to ease stomach discomfort), and chamomile tea (to soothe gastrointestinal irritation)."
		}),
		IllnessData.new("Overexertion", {
			"Symptoms": "Muscle soreness, fatigue, lightheadedness, and occasional shortness of breath.",
			"Diagnosis": "Likely related to overexertion compounded by dehydration.",
			"Treatment": "Rest and increased fluid intake; complementary herbal treatments include topical arnica montana cream to reduce pain and inflammation, and ginger (via massage oil or compress) to ease muscle soreness."
		}),
		IllnessData.new("Dehydration", {
			"Symptoms": "Dry mouth, dizziness, episodes of fainting, and fatigue.",
			"Diagnosis": "Likely due to insufficient fluid intake or excessive fluid loss.",
			"Treatment": "Rehydration with water or oral rehydration solutions; herbal teas such as chamomile orpeppermint may help soothe symptoms."
		}),
		IllnessData.new("Sprained Ankle", {
			"Symptoms": "Swelling, pain, and difficulty in movement of the ankle.",
			"Diagnosis": "Likely an acute sprain involving the ankle ligaments.",
			"Treatment": "Begin with RICE therapy (rest, ice, compression, elevation) and complement with topical arnica montana cream and cooled chamomile tea compresses to reduce inflammation."
		}),
		IllnessData.new("Sore Throat (Viral or Allergic)", {
			"Symptoms": "Sore throat, mild cough, swollen lymph nodes, and slight fever.",
			"Diagnosis": "Likely due to a viral infection or mild allergic reaction.",
			"Treatment": "Support with warm saltwater gargles and fluid intake; herbal options include teas made from sage and thyme (for their antimicrobial and anti-inflammatory properties), marshmallow root or slippery elm (to soothe mucous membranes), licorice root, and chamomile tea."
		}),
		IllnessData.new("Rash / Skin Irritation", {
			"Symptoms": "Redness, itching, and possible bumps or welts on the skin.",
			"Diagnosis": "Likely a localized allergic reaction or contact irritation.",
			"Treatment": "Topical application of herbal preparations such as calendula officinalis ointment, aloe vera gel, or chamomile extract to reduce inflammation and promote healing."
		}),
		IllnessData.new("Constipation", {
			"Symptoms": "Abdominal discomfort, bloating, and infrequent or difficult bowel movements.",
			"Diagnosis": "Likely related to low dietary fiber, inadequate fluid intake, or stress-related changes in bowel motility.",
			"Treatment": "Increase dietary fiber and fluids; for short-term relief, use herbal stimulant laxatives such as senna (Senna alexandrina) to promote bowel movements."
		}),
		IllnessData.new("Ear Infection", {
			"Symptoms": "Ear pain, mild fever, and muffled hearing.",
			"Diagnosis": "Likely acute otitis media or outer ear infection of viral or bacterial origin.",
			"Treatment": "Standard management includes maintaining ear hygiene and pain control; complementary herbal options may include carefully prepared garlic-mullein oil drops to leverage antimicrobial properties, and (if appropriate) diluted tea tree oil preparations. Use these remedies only under professional guidance."
		}),
		IllnessData.new("Anxiety / Stress-Induced Symptoms", {
			"Symptoms": "Racing heartbeat, shortness of breath, sweating, and restlessness.",
			"Diagnosis": "Symptoms consistent with anxiety or stress-related conditions.",
			"Treatment": "Along with standard stress management practices (e.g., deep breathing, mindfulness), consider herbal support such as lemon balm tea, chamomile, valerian root, and optionally passionflower or lavender (via teas or aromatherapy) to promote relaxation."
		}),
		IllnessData.new("Sinus Infection", {
			"Symptoms": "Nasal congestion, headache, facial pressure, cough, and mild fever.",
			"Diagnosis": "Likely acute sinusitis, commonly of viral origin.",
			"Treatment": "Supportive care with hydration, rest, and steam inhalation; complementary herbal therapies include the use of eucalyptus oil (in steam inhalation), peppermint oil (for its cooling decongestant effects), and thyme tea for its antimicrobial support."
		})
	]
