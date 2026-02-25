class_name Ability extends Resource

@export var ability_name: String = ""
@export var description: String = ""
@export var range_val: int = 1
@export var damage: int = 0
@export var cooldown: int = 0
@export var icon: Texture2D

var current_cooldown: int = 0


func can_use() -> bool:
	return current_cooldown <= 0


func use(source: BaseUnit, target_coord: Vector2i, grid: HexGrid) -> void:
	current_cooldown = cooldown


func tick_cooldown() -> void:
	if current_cooldown > 0:
		current_cooldown -= 1


func get_valid_targets(source_coord: Vector2i, grid: HexGrid) -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	for coord in grid.tiles:
		if HexGrid.distance(source_coord, coord) <= range_val:
			targets.append(coord)
	return targets
