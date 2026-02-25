extends Node2D

@export var round_time: float = 45.0
@export var shrink_interval: float = 10.0
@export var arena_radius: float = 500.0

var timer: float = 0.0
var alive_players: Array[int] = []
var current_radius: float
var arena_active: bool = false

func _ready() -> void:
	arena_active = true
	timer = round_time
	current_radius = arena_radius
	alive_players = PlayerRegistry.players.keys()
	_spawn_players()

func _process(delta: float) -> void:
	if not arena_active:
		return
	timer -= delta
	if fmod(timer, shrink_interval) < delta:
		current_radius -= 50.0
	for player in $Players.get_children():
		if player.global_position.length() > current_radius:
			_eliminate_player(player.name.to_int())
	if timer <= 0 or alive_players.size() <= 1:
		_end_arena()

func _spawn_players() -> void:
	var idx = 0
	for id in PlayerRegistry.players:
		var player = preload("res://scenes/player/mp_player.tscn").instantiate()
		player.name = str(id)
		var angle = idx * TAU / PlayerRegistry.players.size()
		player.position = Vector2.from_angle(angle) * 200.0
		$Players.add_child(player)
		idx += 1

func _eliminate_player(id: int) -> void:
	alive_players.erase(id)

func _end_arena() -> void:
	arena_active = false
	var results: Dictionary = {}
	for id in PlayerRegistry.players:
		results[id] = 10 if id in alive_players else 0
	if multiplayer.is_server():
		GameFlow.report_results(results)
