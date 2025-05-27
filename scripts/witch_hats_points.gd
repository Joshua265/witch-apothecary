extends HBoxContainer

# Image paths
const EMPTY_HAT_PATH = "res://sprites/points/empty.png"
const FILLED_HAT_PATH = "res://sprites/points/filled.png"

# Array to hold the hat textures
var hats := []

func _ready():
	for i in range(3):
		var hat = TextureRect.new()
		hat.texture = load(EMPTY_HAT_PATH)
		hat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		hat.custom_minimum_size = Vector2(32, 32) #this doesnt hold oofHBoxContainer
		hat.expand_mode = TextureRect.EXPAND_FIT_WIDTH

		#hat.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		self.add_child(hat)
		hats.append(hat)

	#update_hats()


func update_hats(level: String):
	print("Called")
	print(GameState.current_points)
	var points = GameState.level_scores[level]
	var margins = GameState.patient_data_instance.patients[level]["point_margins"]

	for i in range(hats.size()):
		if points >= margins[i]:
			hats[i].texture = load(FILLED_HAT_PATH)
		else:
			hats[i].texture = load(EMPTY_HAT_PATH)
