extends Node

signal illness_changed(new_illness)
signal load_bok(illnessIndices: Array[int], diagnose_mode: bool)

@export var bookOfKnowledge: BookOfKnowledge
var content_loader: ContentLoader = ContentLoader.new()

var current_illness: String= ""
var illnesses: Array[IllnessData] = []

func _ready() -> void:
	connect("load_bok", Callable(self, "_on_load_bok"))

func _on_load_bok(illnessesIndices: Array[int], diagnose_mode: bool) -> void:
	illnesses = content_loader.load_bok_data(illnessesIndices);
	initialize_bok(diagnose_mode)

func initialize_bok(diagnose_mode: bool) -> void:
	bookOfKnowledge = BookOfKnowledge.new(
		illnesses,
		diagnose_mode
	)


func set_illness(new_illness: String) -> void:
	if current_illness != new_illness:
		current_illness = new_illness
		emit_signal("illness_changed", new_illness)
