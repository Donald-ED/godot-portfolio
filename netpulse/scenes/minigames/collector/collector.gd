extends Node2D

@export var game_time: float = 30.0
@export var spawn_interval: float = 1.5
@export var arena_size: Vector2 = Vector2(800, 600)

var timer: float = 0.0
var spawn_timer: float = 0.0
var scores: Dictionary = {}
var game_active: bool = false

func _ready() -> void:
	game_active = true
	timer = game_time
	spawn_timer = 0.0
	for id in PlayerRegistry.players:
		scores[id] = 0
	_spawn_players()

func _process(delta: float) -> void:
	if not game_active:
		return
	timer -= delta
	spawn_timer -= delta
	if spawn_timer <= 0:
		_spawn_collectible()
		spawn_timer = spawn_interval
	if timer <= 0:
		_end_collection()

func _spawn_players() -> void:
	var idx = 0
	for id in PlayerRegistry.players:
		var player = preload("res://scenes/player/mp_player.tscn").instantiate()
		player.name = str(id)
		player.position = Vector2(100 + idx * 200, 300)
		$Players.add_child(player)
		idx += 1

func _spawn_collectible() -> void:
	var collectible = Area2D.new()
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 15.0
	shape.shape = circle
	collectible.add_child(shape)
	var sprite = Sprite2D.new()
	collectible.add_child(sprite)
	collectible.position = Vector2(
		randf_range(-arena_size.x / 2, arena_size.x / 2),
		randf_range(-arena_size.y / 2, arena_size.y / 2)
	)
	collectible.body_entered.connect(func(body):
		if body is CharacterBody2D:
			var player_id = body.name.to_int()
			if player_id in scores:
				scores[player_id] += 1
			collectible.queue_free()
	)
	$Collectibles.add_child(collectible)

func _end_collection() -> void:
	game_active = false
	if multiplayer.is_server():
		GameFlow.report_results(scores)
