extends Panel

@export var clipboard : Panel 
@export var animation_player : AnimationPlayer 
@export var hover_distance : float = 10  
var closed_position : Vector2  
var is_open : bool = false 
var is_hovered : bool = false 

func _ready():
	closed_position = clipboard.position
	is_open = false
	is_hovered = false
	mouse_filter = Control.MOUSE_FILTER_STOP 

func _process(delta):
	var mouse_position = get_global_mouse_position()
	
	if clipboard.get_rect().has_point(mouse_position):
		if !is_hovered:
			animate_hover_in()
			is_hovered = true
	else:
		if is_hovered and !is_open: 
			animate_hover_out()
			is_hovered = false	
			
func animate_hover_in():
	animation_player.play("hover_in")

func animate_hover_out():
	animation_player.play_backwards("hover_in")
	#animation_player.play("hover_out")

func _on_clipboard_pressed():
	if !is_open:
		animation_player.play("open")
		is_open = true
	else:
		animation_player.play_backwards("open")
		is_open = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_clipboard_pressed();
