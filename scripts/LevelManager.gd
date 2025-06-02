extends Node

class_name LevelManager

signal level_changed(new_level)
signal level_unlocked(level_index)

@export var current_level_data: LevelData = null
@export var current_level: int = 0
@export var unlocked_levels: Array = [1]# Start with level 1 unlocked
var content_loader: ContentLoader = ContentLoader.new()

func change_level(new_level: int) -> void:
	if current_level != new_level:
		current_level = new_level
		current_level_data = content_loader.load_level_data(new_level)
		emit_signal("level_changed", new_level)
		print("Changing to level %s..." % current_level)
	else:
		print("Already on level %s" % current_level)

func unlock_level(level_index: int) -> void:
	if not unlocked_levels.has(level_index):
		unlocked_levels.append(level_index)
		emit_signal("level_unlocked", level_index)
		print("Level %s unlocked!" % level_index)
	else:
		print("Level %s is already unlocked." % level_index)
