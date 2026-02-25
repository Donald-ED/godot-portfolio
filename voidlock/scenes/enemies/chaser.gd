extends State

@export var chase_speed: float = 120.0
var enemy: CharacterBody2D

func enter() -> void:
	enemy = get_parent().get_parent()

func physics_update(delta: float) -> void:
	if enemy.target:
		var direction = enemy.global_position.direction_to(enemy.target.global_position)
		enemy.velocity = direction * chase_speed
		enemy.move_and_slide()
	else:
		transitioned.emit(self, "idle")
