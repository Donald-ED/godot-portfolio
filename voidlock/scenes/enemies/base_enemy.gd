extends CharacterBody2D

@export var max_health: int = 30
@export var move_speed: float = 100.0
@export var contact_damage: int = 10

var current_health: int
var target: Node2D

signal enemy_died(enemy: Node2D)

func _ready() -> void:
	current_health = max_health
	target = get_tree().get_first_node_in_group("player")

func take_damage(amount: int) -> void:
	current_health -= amount
	_flash_white()
	if current_health <= 0:
		_die()

func _flash_white() -> void:
	if material:
		material.set_shader_parameter("flash_strength", 1.0)
		var tween = create_tween()
		tween.tween_property(material, "shader_parameter/flash_strength", 0.0, 0.15)

func _die() -> void:
	enemy_died.emit(self)
	queue_free()
