extends CharacterBody2D

@export var speed: float = 200.0
@export var dash_speed: float = 500.0
@export var dash_duration: float = 0.15
@export var max_health: int = 100

var is_dashing: bool = false
var dash_timer: float = 0.0
var current_health: int
var current_weapon: WeaponData

signal health_changed(new_health: int)
signal player_died

func _ready() -> void:
	current_health = max_health

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and not is_dashing:
		_start_dash(input_dir)
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = input_dir * dash_speed
	else:
		velocity = input_dir * speed
	look_at(get_global_mouse_position())
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		_shoot()

func _start_dash(direction: Vector2) -> void:
	is_dashing = true
	dash_timer = dash_duration

func _shoot() -> void:
	if current_weapon:
		var bullet = current_weapon.projectile_scene.instantiate()
		bullet.global_position = global_position
		bullet.rotation = rotation
		bullet.speed = current_weapon.projectile_speed
		bullet.damage = current_weapon.damage
		get_tree().current_scene.add_child(bullet)

func take_damage(amount: int) -> void:
	if is_dashing:
		return
	current_health -= amount
	health_changed.emit(current_health)
	if current_health <= 0:
		player_died.emit()
