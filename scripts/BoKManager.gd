extends Node

signal illness_changed(new_illness)

var current_illness: String= ""
var bok_data: Dictionary = {}
var content_loader: ContentLoader = null

func _ready() -> void:
	content_loader = ContentLoader.new()
	add_child(content_loader)
	content_loader.connect("content_loaded", Callable(self, "_on_content_loaded"))
	load_bok_data()

func load_bok_data() -> void:
	content_loader.load_bok_data()

func _on_content_loaded(content_type: String, data: Dictionary) -> void:
	if content_type == "bok":
		bok_data = data
		emit_signal("illness_changed", bok_data)

func set_illness(new_illness: String) -> void:
	if current_illness != new_illness:
		current_illness = new_illness
		emit_signal("illness_changed", new_illness)
