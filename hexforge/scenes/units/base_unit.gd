class_name BaseUnit extends Node2D

@export var unit_data: UnitData
var current_health: int
var hex_coord: Vector2i
var team: int = 0
var has_moved: bool = false
var has_acted: bool = false

signal unit_selected(unit: BaseUnit)
signal unit_died(unit: BaseUnit)


func _ready() -> void:
	if unit_data:
		current_health = unit_data.max_health


func reset_actions() -> void:
	has_moved = false
	has_acted = false


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		unit_died.emit(self)


func heal(amount: int) -> void:
	if unit_data:
		current_health = mini(current_health + amount, unit_data.max_health)


func move_to(coord: Vector2i, pixel_pos: Vector2) -> void:
	hex_coord = coord
	var tween = create_tween()
	tween.tween_property(self, "position", pixel_pos, 0.3).set_ease(Tween.EASE_OUT)
	has_moved = true


func can_act() -> bool:
	return not has_acted


func can_move() -> bool:
	return not has_moved
