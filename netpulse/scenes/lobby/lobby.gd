extends Control

@onready var host_button := $VBoxContainer/HostButton
@onready var join_button := $VBoxContainer/JoinButton
@onready var address_input := $VBoxContainer/AddressInput
@onready var player_list := $VBoxContainer/PlayerList
@onready var start_button := $VBoxContainer/StartButton
@onready var status_label := $VBoxContainer/StatusLabel

func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	start_button.pressed.connect(_on_start_pressed)
	start_button.visible = false
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.connection_succeeded.connect(_on_connection_succeeded)
	NetworkManager.connection_failed.connect(_on_connection_failed)

func _on_host_pressed() -> void:
	NetworkManager.host_game()
	status_label.text = "Hosting on port %d..." % NetworkManager.PORT
	host_button.disabled = true
	join_button.disabled = true
	start_button.visible = true
	NetworkManager.register_player.rpc({"name": "Host"})

func _on_join_pressed() -> void:
	var address = address_input.text if address_input.text != "" else "localhost"
	NetworkManager.join_game(address)
	status_label.text = "Connecting to %s..." % address
	host_button.disabled = true
	join_button.disabled = true

func _on_connection_succeeded() -> void:
	status_label.text = "Connected!"
	NetworkManager.register_player.rpc({"name": "Player %d" % multiplayer.get_unique_id()})

func _on_connection_failed() -> void:
	status_label.text = "Connection failed!"
	host_button.disabled = false
	join_button.disabled = false

func _on_player_connected(id: int) -> void:
	_update_player_list()

func _on_player_disconnected(id: int) -> void:
	PlayerRegistry.remove_player(id)
	_update_player_list()

func _on_start_pressed() -> void:
	if NetworkManager.is_host() and PlayerRegistry.players.size() >= 2:
		_start_game.rpc()

@rpc("authority", "call_local", "reliable")
func _start_game() -> void:
	GameFlow.start_game_rotation()

func _update_player_list() -> void:
	for child in player_list.get_children():
		child.queue_free()
	for id in PlayerRegistry.players:
		var label = Label.new()
		label.text = PlayerRegistry.get_player_name(id)
		player_list.add_child(label)
