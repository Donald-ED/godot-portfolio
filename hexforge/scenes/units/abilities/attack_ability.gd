class_name AttackAbility extends Ability


func _init() -> void:
	ability_name = "Attack"
	description = "Attack an enemy unit"
	damage = 15


func get_valid_targets(source_coord: Vector2i, grid: HexGrid) -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	for coord in grid.tiles:
		if HexGrid.distance(source_coord, coord) <= range_val:
			if grid.tiles[coord].unit and grid.tiles[coord].unit.team != 0:
				targets.append(coord)
	return targets


func use(source: BaseUnit, target_coord: Vector2i, grid: HexGrid) -> void:
	super.use(source, target_coord, grid)
	var target_unit = grid.tiles[target_coord].unit
	if target_unit:
		target_unit.take_damage(damage)
