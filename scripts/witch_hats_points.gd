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
		hat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hat.custom_minimum_size = Vector2(64, 64) #this doesnt hold oof
	
		hat.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		self.add_child(hat)
		hats.append(hat)

	#update_hats()


func update_hats():
	print("Called")
	print(GameState.current_points)
	var points = GameState.current_points
	var margins = GameState.current_level_point_margin

	for i in range(hats.size()):
		if points >= margins[i]:
			hats[i].texture = load(FILLED_HAT_PATH)
		else:
			hats[i].texture = load(EMPTY_HAT_PATH)
