extends Node3D

@export var bridge_length: float = 5.0
@export var segments: int = 10
@export var activation_time: float = 0.5

var is_active: bool = false
var activation_timer: float = 0.0
var bridge_segments: Array[MeshInstance3D] = []

func _ready() -> void:
	_create_bridge_segments()

func _process(delta: float) -> void:
	if is_active:
		activation_timer += delta
	else:
		activation_timer -= delta
	activation_timer = clamp(activation_timer, 0, activation_time)
	var progress = activation_timer / activation_time
	_update_bridge_visual(progress)

func activate() -> void:
	is_active = true
	$CollisionShape3D.disabled = false

func deactivate() -> void:
	is_active = false
	$CollisionShape3D.disabled = true

func _create_bridge_segments() -> void:
	var segment_length = bridge_length / segments
	for i in range(segments):
		var mesh_instance = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(1.0, 0.2, segment_length)
		mesh_instance.mesh = box
		mesh_instance.position.z = i * segment_length - bridge_length / 2
		add_child(mesh_instance)
		bridge_segments.append(mesh_instance)

func _update_bridge_visual(progress: float) -> void:
	for i in range(bridge_segments.size()):
		var segment_progress = clamp((progress * segments) - i, 0.0, 1.0)
		bridge_segments[i].visible = segment_progress > 0.0
		var material = bridge_segments[i].get_active_material(0)
		if material is StandardMaterial3D:
			material.albedo_color.a = segment_progress
