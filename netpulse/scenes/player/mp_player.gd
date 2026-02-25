extends CharacterBody2D

@export var speed := 300.0
@export var player_color := Color.WHITE

@onready var sprite := $Sprite2D
@onready var name_label := $NameLabel
@onready var sync := $MultiplayerSynchronizer

var player_name: String = "Player"

func _ready() -> void:
	if not is_multiplayer_authority():
		set_physics_process(false)
	var id = name.to_int()
	if id in PlayerRegistry.players:
		player_name = PlayerRegistry.get_player_name(id)
		player_color = PlayerRegistry.get_player_color(id)
	if sprite:
		sprite.modulate = player_color
	if name_label:
		name_label.text = player_name

func _physics_process(_delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
