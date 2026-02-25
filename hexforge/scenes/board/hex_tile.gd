extends Area2D

var coord: Vector2i
var walkable: bool = true
var is_highlighted: bool = false
var highlight_color: Color = Color.YELLOW

signal clicked(coord: Vector2i)
signal hovered(coord: Vector2i)


func setup(hex_coord: Vector2i, pixel_pos: Vector2) -> void:
	coord = hex_coord
	position = pixel_pos


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(coord)


func _mouse_enter() -> void:
	hovered.emit(coord)
	modulate = Color(1.2, 1.2, 1.2)


func _mouse_exit() -> void:
	if not is_highlighted:
		modulate = Color.WHITE


func set_highlight(enabled: bool, color: Color = Color.YELLOW) -> void:
	is_highlighted = enabled
	highlight_color = color
	modulate = color if enabled else Color.WHITE
