extends Node

#TODO: add more for the next level - second patient
var illnesses = [
	{
		"name": "Simple Cold/Flu",
		"info": {
			"Symptoms": "Congestion, headache, fatigue, and mild fever." , 
			"Diagnosis": "Likely a viral upper respiratory infection (common cold or influenza).",
			"Treatment": "Supportive care with rest, hydration, and herbal supplements such as elderberry extract, echinacea, pelargonium sidoides extract, and warming ginger/garlic teas."
		},
		"matching_rules": {
			"rise in temperature": true,
			"temperature": {"min": "38.5 °C"},
			"headaches": true,
			"fatigue": true,
			"congestion": true
		}
	},
	{
		"name": "Overexertion",
		"info": {
			"Symptoms": "Muscle soreness, fatigue, lightheadedness, and occasional shortness of breath.",
			"Diagnosis": "Likely related to overexertion compounded by dehydration.",
			"Treatment": "Rest and increased fluid intake; complementary herbal treatments include topical arnica montana cream to reduce pain and inflammation, and ginger (via massage oil or compress) to ease muscle soreness."
		},
		"matching_rules": {
			"dehydration": true,
			"inadequate hydration": true,
			"sore": true,
			"lightheaded": true,
			'dizziness': true,
			"fatigue": true,
			"experiences shortness of breath": true,
			"breathing": {"min": "20 br/min"} # elevated breathing rate
		}
	},
	{
		"name": "Food Poisoning",
		"info": {
			"Symptoms": "Nausea, abdominal pain, dizziness, and occasional vomiting.",
			"Diagnosis": "Likely due to ingestion of contaminated food resulting in foodborne illness.",
			"Treatment": "Supportive care with oral rehydration and electrolyte replacement; complementary options include ginger tea (for nausea), peppermint tea (to ease stomach discomfort), and chamomile tea (to soothe gastrointestinal irritation)."
		},
		"matching_rules": {
			"nausea": true,
			"abdominal pain": true,
			"dizziness": true,
			"vomiting": true
		}
	},
	{
		"name": "Dehydration",
		"info": {
			"Symptoms": "Dry mouth, dizziness, episodes of fainting, and fatigue.",
			"Diagnosis": "Likely caused by insufficient fluid intake or excessive fluid loss (e.g., from exertion).",
			"Treatment": "Prompt rehydration with fluids and electrolytes; consider hydrating herbal options like aloe vera juice to provide both water and gentle gastrointestinal soothing."
		},
		"matching_rules": {
			"dehydration": true,
			"fatigue": true,
			"dizziness": true,
			"fainting": true
			#"heart_rate": {"min": 100}, # tachycardia
		}
	},
	{
		"name": "Sprained Ankle",
		"info": {
			"Symptoms": "Swelling, pain, and difficulty in movement of the ankle.",
			"Diagnosis": "Likely an acute sprain involving the ankle ligaments.",
			"Treatment": "Begin with RICE therapy (rest, ice, compression, elevation) and complement with topical arnica montana cream and cooled chamomile tea compresses to reduce inflammation."
		},
		"matching_rules": {
			"ankle": true,
			"swelling": true,
			"pain": true		}
	},
	{
		"name": "Sore Throat (Viral or Allergic)",
		"info": {
			"Symptoms": "Sore throat, mild cough, swollen lymph nodes, and slight fever.",
			"Diagnosis": "Likely due to a viral infection or mild allergic reaction.",
			"Treatment": "Support with warm saltwater gargles and fluid intake; herbal options include teas made from sage and thyme (for their antimicrobial and anti-inflammatory properties), marshmallow root or slippery elm (to soothe mucous membranes), licorice root, and chamomile tea."
		},
		"matching_rules": {
			"sore throat": true,
			"cough": true,
			"rise in temperature": true,
			"temperature": {"min": "38.5 °C"}
		}
	},
	{
		"name": "Rash / Skin Irritation",
		"info": {
			"Symptoms": "Redness, itching, and possible bumps or welts on the skin.",
			"Diagnosis": "Likely a localized allergic reaction or contact irritation.",
			"Treatment": "Topical application of herbal preparations such as calendula officinalis ointment, aloe vera gel, or chamomile extract to reduce inflammation and promote healing."
		},
		"matching_rules": {
			"rash": true,
			"itching": true,
			"bumps": true,
			"welts": true,
			"skin": true,
			"irritation": true
		}
	},
	{
		"name": "Constipation",
		"info": {
			"Symptoms": "Abdominal discomfort, bloating, and infrequent or difficult bowel movements.",
			"Diagnosis": "Likely related to low dietary fiber, inadequate fluid intake, or stress-related changes in bowel motility.",
			"Treatment": "Increase dietary fiber and fluids; for short-term relief, use herbal stimulant laxatives such as senna (Senna alexandrina) to promote bowel movements."
		},	
		"matching_rules": {
			"bloating": true,
			"constipation": true,
			"abdominal discomfort": true
			# bowl movement not because regular in the text
		}
	},
	{
		"name": "Ear Infection",
		"info": {
			"Symptoms": "Ear pain, mild fever, and muffled hearing.",
			"Diagnosis": "Likely acute otitis media or outer ear infection of viral or bacterial origin.",
			"Treatment": "Standard management includes maintaining ear hygiene and pain control; complementary herbal options may include carefully prepared garlic-mullein oil drops to leverage antimicrobial properties, and (if appropriate) diluted tea tree oil preparations. Use these remedies only under professional guidance."
		},
		"matching_rules": {
			"ear pain": true,
			"rise in temperature": true,
			"temperature": {"min": "38.5 °C"}
		}
	},
	{
		"name": "Anxiety / Stress-Induced Symptoms",
		"info": {
			"Symptoms": "Racing heartbeat, shortness of breath, sweating, and restlessness.",
			"Diagnosis": "Symptoms consistent with anxiety or stress-related conditions.",
			"Treatment": "Along with standard stress management practices (e.g., deep breathing, mindfulness), consider herbal support such as lemon balm tea, chamomile, valerian root, and optionally passionflower or lavender (via teas or aromatherapy) to promote relaxation."
		},
		"matching_rules": {
			"heart_rate": {"min": "100 bpm"},
			"experiences shortness of breath": true,
			"sweating": true,
			"restlessness": true,
			"stress": true
		}
	},
	{
		"name": "Sinus Infection",
		"info": {
			"Symptoms": "Nasal congestion, headache, facial pressure, cough, and mild fever.",
			"Diagnosis": "Likely acute sinusitis, commonly of viral origin.",
			"Treatment": "Supportive care with hydration, rest, and steam inhalation; complementary herbal therapies include the use of eucalyptus oil (in steam inhalation), peppermint oil (for its cooling decongestant effects), and thyme tea for its antimicrobial support."
		},
		"matching_rules": {
			"forehead and temples": true,
			"nasal congestion": true,
			"facial pressure": true,
			"headaches": true,
			"cough": true,
			"rise in temperature": true,
			"temperature": {"min": "38.5 °C"}
		}
	}
]
