extends Node3D

@export var is_rotatable: bool = true
@export var rotation_speed_deg: float = 45.0

var incoming_light_dir: Vector3 = Vector3.ZERO
var reflected_dir: Vector3 = Vector3.ZERO

@onready var mirror_mesh := $MirrorMesh
@onready var ray_cast := $RayCast3D

func _physics_process(_delta: float) -> void:
	if incoming_light_dir != Vector3.ZERO:
		var normal = -mirror_mesh.global_transform.basis.z
		reflected_dir = incoming_light_dir - 2 * incoming_light_dir.dot(normal) * normal
		ray_cast.target_position = reflected_dir * 50.0
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if collider.has_method("receive_light"):
				collider.receive_light(reflected_dir)

func receive_light(direction: Vector3) -> void:
	incoming_light_dir = direction

func rotate_mirror(direction: float) -> void:
	if is_rotatable:
		rotate_y(deg_to_rad(direction * rotation_speed_deg))
