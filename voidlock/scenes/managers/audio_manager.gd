extends Node

var sfx_bus := AudioServer.get_bus_index("SFX") if AudioServer.get_bus_index("SFX") != -1 else 0
var music_bus := AudioServer.get_bus_index("Music") if AudioServer.get_bus_index("Music") != -1 else 0

func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.volume_db = volume_db
	player.bus = "SFX"
	player.play()
	player.finished.connect(player.queue_free)

func play_music(stream: AudioStream, volume_db: float = -10.0) -> void:
	for child in get_children():
		if child is AudioStreamPlayer and child.bus == "Music":
			child.stop()
			child.queue_free()
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.volume_db = volume_db
	player.bus = "Music"
	player.play()
