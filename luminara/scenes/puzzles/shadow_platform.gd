extends StaticBody3D

@export var activation_threshold: float = 0.3
@export var transition_speed: float = 3.0

var light_level: float = 1.0
var is_solid: bool = false
var target_opacity: float = 0.0

@onready var mesh := $MeshInstance3D
@onready var collision := $CollisionShape3D

func _process(delta: float) -> void:
	var should_be_solid = light_level < activation_threshold
	if should_be_solid != is_solid:
		is_solid = should_be_solid
		collision.disabled = not is_solid
	target_opacity = 1.0 if is_solid else 0.2
	var material = mesh.get_active_material(0)
	if material is ShaderMaterial:
		var current = material.get_shader_parameter("opacity")
		material.set_shader_parameter("opacity", lerp(current, target_opacity, transition_speed * delta))

func update_light_level(level: float) -> void:
	light_level = level
