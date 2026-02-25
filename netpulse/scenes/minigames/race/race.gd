extends Node2D

@export var track_length: float = 2000.0
@export var time_limit: float = 30.0

var timer: float = 0.0
var finished_players: Dictionary = {}
var race_active: bool = false

func _ready() -> void:
	race_active = true
	timer = time_limit
	_spawn_players()

func _process(delta: float) -> void:
	if not race_active:
		return
	timer -= delta
	if timer <= 0:
		_end_race()

func _spawn_players() -> void:
	var spawn_points = $SpawnPoints.get_children()
	var idx = 0
	for id in PlayerRegistry.players:
		var player_scene = preload("res://scenes/player/mp_player.tscn")
		var player = player_scene.instantiate()
		player.name = str(id)
		if idx < spawn_points.size():
			player.position = spawn_points[idx].position
		$Players.add_child(player)
		idx += 1

func _on_player_finished(id: int) -> void:
	if id not in finished_players:
		finished_players[id] = finished_players.size() + 1
		if finished_players.size() >= PlayerRegistry.players.size():
			_end_race()

func _end_race() -> void:
	race_active = false
	var results: Dictionary = {}
	var points = [10, 6, 3, 1]
	for id in finished_players:
		var place = finished_players[id] - 1
		results[id] = points[place] if place < points.size() else 0
	for id in PlayerRegistry.players:
		if id not in results:
			results[id] = 0
	if multiplayer.is_server():
		GameFlow.report_results(results)
