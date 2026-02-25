class_name HexGrid extends Node2D

const TILE_SIZE := Vector2(64, 56)
var tiles: Dictionary = {}

signal tile_clicked(coord: Vector2i)
signal tile_hovered(coord: Vector2i)


static func axial_to_pixel(q: int, r: int) -> Vector2:
	var x = TILE_SIZE.x * (3.0 / 2.0 * q)
	var y = TILE_SIZE.y * (sqrt(3.0) / 2.0 * q + sqrt(3.0) * r)
	return Vector2(x, y)


static func pixel_to_axial(pixel: Vector2) -> Vector2i:
	var q = (2.0 / 3.0 * pixel.x) / TILE_SIZE.x
	var r = (-1.0 / 3.0 * pixel.x + sqrt(3.0) / 3.0 * pixel.y) / TILE_SIZE.y
	return _axial_round(q, r)


static func _axial_round(q: float, r: float) -> Vector2i:
	var s = -q - r
	var rq = round(q)
	var rr = round(r)
	var rs = round(s)
	var q_diff = abs(rq - q)
	var r_diff = abs(rr - r)
	var s_diff = abs(rs - s)
	if q_diff > r_diff and q_diff > s_diff:
		rq = -rr - rs
	elif r_diff > s_diff:
		rr = -rq - rs
	return Vector2i(int(rq), int(rr))


static func get_neighbors(q: int, r: int) -> Array[Vector2i]:
	return [
		Vector2i(q + 1, r), Vector2i(q + 1, r - 1), Vector2i(q, r - 1),
		Vector2i(q - 1, r), Vector2i(q - 1, r + 1), Vector2i(q, r + 1)
	]


static func distance(a: Vector2i, b: Vector2i) -> int:
	return (abs(a.x - b.x) + abs(a.x + a.y - b.x - b.y) + abs(a.y - b.y)) / 2


func get_reachable_tiles(origin: Vector2i, movement: int) -> Array[Vector2i]:
	var visited: Array[Vector2i] = [origin]
	var fringes: Array[Array] = [[origin]]
	for k in range(1, movement + 1):
		fringes.append([])
		for hex in fringes[k - 1]:
			for neighbor in get_neighbors(hex.x, hex.y):
				if neighbor not in visited and _is_walkable(neighbor):
					visited.append(neighbor)
					fringes[k].append(neighbor)
	return visited


func find_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var open_set: Array[Vector2i] = [start]
	var came_from: Dictionary = {}
	var g_score: Dictionary = {start: 0}
	var f_score: Dictionary = {start: distance(start, goal)}
	while open_set.size() > 0:
		var current = _get_lowest_f(open_set, f_score)
		if current == goal:
			return _reconstruct_path(came_from, current)
		open_set.erase(current)
		for neighbor in get_neighbors(current.x, current.y):
			if not _is_walkable(neighbor):
				continue
			var tentative_g = g_score[current] + 1
			if tentative_g < g_score.get(neighbor, INF):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + distance(neighbor, goal)
				if neighbor not in open_set:
					open_set.append(neighbor)
	return []


func _get_lowest_f(open_set: Array[Vector2i], f_score: Dictionary) -> Vector2i:
	var lowest = open_set[0]
	for coord in open_set:
		if f_score.get(coord, INF) < f_score.get(lowest, INF):
			lowest = coord
	return lowest


func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = [current]
	while current in came_from:
		current = came_from[current]
		path.insert(0, current)
	return path


func _is_walkable(coord: Vector2i) -> bool:
	if coord not in tiles:
		return false
	return tiles[coord].walkable


func create_grid(radius: int) -> void:
	for q in range(-radius, radius + 1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2 + 1):
			_add_tile(Vector2i(q, r))


func _add_tile(coord: Vector2i) -> void:
	tiles[coord] = {"walkable": true, "unit": null, "terrain": "grass"}
