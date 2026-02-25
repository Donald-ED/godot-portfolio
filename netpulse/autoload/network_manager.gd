extends Node

signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal connection_failed
signal connection_succeeded

const PORT := 9999
const MAX_PLAYERS := 4

var peer: ENetMultiplayerPeer

func host_game() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error != OK:
		push_error("Failed to create server: %s" % error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	player_connected.emit(1)

func join_game(address: String) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error != OK:
		push_error("Failed to join: %s" % error)
		connection_failed.emit()
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(func(): connection_succeeded.emit())
	multiplayer.connection_failed.connect(func(): connection_failed.emit())
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	player_connected.emit(id)

func _on_peer_disconnected(id: int) -> void:
	player_disconnected.emit(id)

func disconnect_from_game() -> void:
	if peer:
		peer.close()
		multiplayer.multiplayer_peer = null

func is_host() -> bool:
	return multiplayer.is_server()

func get_player_count() -> int:
	if not peer:
		return 0
	return multiplayer.get_peers().size() + 1

@rpc("any_peer", "call_local", "reliable")
func register_player(data: Dictionary) -> void:
	var sender = multiplayer.get_remote_sender_id()
	PlayerRegistry.add_player(sender, data)
