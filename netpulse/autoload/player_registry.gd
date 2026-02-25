extends Node

var players: Dictionary = {}

signal player_added(id: int)
signal player_removed(id: int)
signal players_updated

func add_player(id: int, data: Dictionary) -> void:
	players[id] = {
		"name": data.get("name", "Player %d" % id),
		"color": data.get("color", Color.WHITE),
		"ready": false
	}
	player_added.emit(id)
	players_updated.emit()

func remove_player(id: int) -> void:
	players.erase(id)
	player_removed.emit(id)
	players_updated.emit()

func set_ready(id: int, ready: bool) -> void:
	if id in players:
		players[id].ready = ready
		players_updated.emit()

func all_ready() -> bool:
	for id in players:
		if not players[id].ready:
			return false
	return players.size() >= 2

func get_player_name(id: int) -> String:
	if id in players:
		return players[id].name
	return "Unknown"

func get_player_color(id: int) -> Color:
	if id in players:
		return players[id].color
	return Color.WHITE

func clear() -> void:
	players.clear()
	players_updated.emit()
