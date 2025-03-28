extends Panel

@export var clipboard : Panel 
@export var animation_player : AnimationPlayer 
@export var area : Area2D  
@export var hover_distance : float = 10  
var closed_position : Vector2  
var is_open : bool = false 
var is_hovered : bool = false 

func _ready():
	closed_position = clipboard.position
	is_open = false
	is_hovered = false
	print("Clipboard initialized at position: ", closed_position)
	
	#area.mouse_filter_mode = Area2D.MouseFilterMode.Pass
	area.input_event.connect(_on_area_input_event) 

func _process(delta):
	var mouse_position = get_global_mouse_position()
	
	if clipboard.get_rect().has_point(mouse_position):
		if !is_hovered:
			print("Mouse hovering near clipboard. Triggering hover effect.")
			animate_hover_in()
			is_hovered = true
	else:
		if is_hovered: 
			animate_hover_out()
			is_hovered = false	

func _on_area_input_event(event: InputEvent) -> void:
	print("Miaumiau1!")
	if event is InputEventMouseButton:
		print("Miaumiau!")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left mouse button clicked on Area2D inside ClipboardNode!")
			_on_clipboard_pressed()
			
func animate_hover_in():
	print("Playing hover_in animation: Moving clipboard up.")
	animation_player.play("hover_in")

func animate_hover_out():
	print("Playing hover_out animation: Moving clipboard back down.")
	animation_player.play_backwards("hover_in")
	#animation_player.play("hover_out")

func _on_clipboard_pressed():
	if !is_open:
		print("Clipboard pressed. Opening clipboard.")
		animation_player.play("open")
		is_open = true
	else:
		print("Clipboard pressed again. Closing clipboard.")
		animation_player.play_backwards("open")
		is_open = false
