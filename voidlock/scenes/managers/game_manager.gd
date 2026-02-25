extends Node

signal score_changed(new_score: int)
signal wave_changed(new_wave: int)
signal game_over

var score: int = 0
var current_wave: int = 0
var is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

func start_wave(wave_num: int) -> void:
	current_wave = wave_num
	wave_changed.emit(current_wave)

func trigger_game_over() -> void:
	game_over.emit()
	get_tree().paused = true

func restart() -> void:
	score = 0
	current_wave = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
