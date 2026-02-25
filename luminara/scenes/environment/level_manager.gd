extends Node

var current_level: int = 0
var total_levels: int = 5

signal level_completed(level_num: int)
signal all_levels_completed

func load_level(level_num: int) -> void:
	current_level = level_num
	var path = "res://scenes/levels/level_%02d.tscn" % level_num
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func complete_current_level() -> void:
	level_completed.emit(current_level)
	if current_level >= total_levels:
		all_levels_completed.emit()
	else:
		load_level(current_level + 1)

func restart_level() -> void:
	load_level(current_level)
