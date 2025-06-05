class_name BoKManager

extends Node

var content_loader: ContentLoader = ContentLoader.new()

var current_illness: String= ""
var illnesses: Array[IllnessData] = []

signal bok_loaded(illnesses: Array[IllnessData])

func _ready() -> void:
	GameState.connect("load_bok", Callable(self, "_on_load_bok"))

func _on_load_bok(illnessesIndices: Array[int]) -> void:
	illnesses = content_loader.load_bok_data(illnessesIndices);
	emit_signal("bok_loaded", illnesses)


func set_illness(new_illness: String) -> void:
	if current_illness != new_illness:
		current_illness = new_illness
		emit_signal("illness_changed", new_illness)
