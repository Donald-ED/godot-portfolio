class_name MoveAbility extends Ability


func _init() -> void:
	ability_name = "Move"
	description = "Move to an adjacent tile"


func get_valid_targets(source_coord: Vector2i, grid: HexGrid) -> Array[Vector2i]:
	return grid.get_reachable_tiles(source_coord, range_val)


func use(source: BaseUnit, target_coord: Vector2i, grid: HexGrid) -> void:
	super.use(source, target_coord, grid)
	var pixel_pos = HexGrid.axial_to_pixel(target_coord.x, target_coord.y)
	source.move_to(target_coord, pixel_pos)
