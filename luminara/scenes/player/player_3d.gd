extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 6.0
@export var gravity := 20.0
@export var rotation_speed := 10.0
@export var mouse_sensitivity := 0.002

@onready var camera_pivot := $CameraPivot
@onready var model := $Model
@onready var light_staff := $Model/LightStaff
@onready var animation_player := $AnimationPlayer

var is_aiming: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x - event.relative.y * mouse_sensitivity,
			-PI/4, PI/4
		)
	if event.is_action_pressed("aim_light"):
		is_aiming = true
		light_staff.visible = true
	elif event.is_action_released("aim_light"):
		is_aiming = false
		light_staff.visible = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var cam_basis := camera_pivot.global_transform.basis
	var direction := (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		var target_angle := atan2(-direction.x, -direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, rotation_speed * delta)
		_play_animation("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		_play_animation("idle")
	if is_aiming:
		var aim_ray = camera_pivot.global_transform.basis * Vector3.FORWARD
		light_staff.look_at(light_staff.global_position + aim_ray)
	move_and_slide()

func _play_animation(anim_name: String) -> void:
	if animation_player and animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
