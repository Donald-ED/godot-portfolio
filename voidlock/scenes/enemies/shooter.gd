extends State

@export var shoot_range: float = 300.0
@export var fire_rate: float = 1.0
@export var retreat_speed: float = 80.0
@export var projectile_scene: PackedScene

var enemy: CharacterBody2D
var shoot_timer: float = 0.0

func enter() -> void:
	enemy = get_parent().get_parent()
	shoot_timer = 0.0

func physics_update(delta: float) -> void:
	if not enemy.target:
		transitioned.emit(self, "idle")
		return
	var dist = enemy.global_position.distance_to(enemy.target.global_position)
	if dist < shoot_range * 0.5:
		var away = enemy.target.global_position.direction_to(enemy.global_position)
		enemy.velocity = away * retreat_speed
	else:
		enemy.velocity = Vector2.ZERO
	enemy.move_and_slide()
	shoot_timer -= delta
	if shoot_timer <= 0:
		_fire()
		shoot_timer = fire_rate

func _fire() -> void:
	if projectile_scene and enemy.target:
		var bullet = projectile_scene.instantiate()
		bullet.global_position = enemy.global_position
		bullet.direction = enemy.global_position.direction_to(enemy.target.global_position)
		bullet.rotation = bullet.direction.angle()
		get_tree().current_scene.add_child(bullet)
