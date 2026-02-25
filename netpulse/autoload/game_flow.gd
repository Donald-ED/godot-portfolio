extends Node

signal minigame_starting(game_name: String)
signal minigame_ended(results: Dictionary)
signal all_games_finished(final_scores: Dictionary)

var minigame_scenes: Array[String] = [
	"res://scenes/minigames/race/race.tscn",
	"res://scenes/minigames/arena/arena.tscn",
	"res://scenes/minigames/collector/collector.tscn"
]

var current_game_index: int = -1
var round_scores: Dictionary = {}
var total_scores: Dictionary = {}

func start_game_rotation() -> void:
	total_scores.clear()
	for id in PlayerRegistry.players:
		total_scores[id] = 0
	current_game_index = -1
	_next_minigame()

func _next_minigame() -> void:
	current_game_index += 1
	if current_game_index >= minigame_scenes.size():
		all_games_finished.emit(total_scores)
		return
	var scene_path = minigame_scenes[current_game_index]
	minigame_starting.emit(scene_path.get_file().get_basename())
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(scene_path)

func report_results(results: Dictionary) -> void:
	round_scores = results
	for id in results:
		if id in total_scores:
			total_scores[id] += results[id]
	minigame_ended.emit(results)
	await get_tree().create_timer(5.0).timeout
	_next_minigame()

func get_rankings() -> Array:
	var sorted_ids = total_scores.keys()
	sorted_ids.sort_custom(func(a, b): return total_scores[a] > total_scores[b])
	return sorted_ids
