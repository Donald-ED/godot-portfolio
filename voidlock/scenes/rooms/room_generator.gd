class_name RoomGenerator extends Node

@export var map_width: int = 50
@export var map_height: int = 50
@export var min_room_size: int = 6
@export var max_room_size: int = 12
@export var max_depth: int = 5

var rooms: Array[Rect2i] = []
var corridors: Array[Array] = []

class BSPNode:
	var rect: Rect2i
	var left: BSPNode
	var right: BSPNode
	var room: Rect2i

	func _init(r: Rect2i) -> void:
		rect = r

func generate() -> Dictionary:
	rooms.clear()
	corridors.clear()
	var root = BSPNode.new(Rect2i(0, 0, map_width, map_height))
	_split(root, 0)
	_create_rooms(root)
	_create_corridors(root)
	return {"rooms": rooms, "corridors": corridors}

func _split(node: BSPNode, depth: int) -> void:
	if depth >= max_depth:
		return
	var split_h = randf() > 0.5
	if split_h:
		if node.rect.size.y < min_room_size * 2:
			return
		var split_y = randi_range(node.rect.position.y + min_room_size, node.rect.end.y - min_room_size)
		node.left = BSPNode.new(Rect2i(node.rect.position, Vector2i(node.rect.size.x, split_y - node.rect.position.y)))
		node.right = BSPNode.new(Rect2i(Vector2i(node.rect.position.x, split_y), Vector2i(node.rect.size.x, node.rect.end.y - split_y)))
	else:
		if node.rect.size.x < min_room_size * 2:
			return
		var split_x = randi_range(node.rect.position.x + min_room_size, node.rect.end.x - min_room_size)
		node.left = BSPNode.new(Rect2i(node.rect.position, Vector2i(split_x - node.rect.position.x, node.rect.size.y)))
		node.right = BSPNode.new(Rect2i(Vector2i(split_x, node.rect.position.y), Vector2i(node.rect.end.x - split_x, node.rect.size.y)))
	_split(node.left, depth + 1)
	_split(node.right, depth + 1)

func _create_rooms(node: BSPNode) -> void:
	if node.left and node.right:
		_create_rooms(node.left)
		_create_rooms(node.right)
	else:
		var w = randi_range(min_room_size, mini(max_room_size, node.rect.size.x - 2))
		var h = randi_range(min_room_size, mini(max_room_size, node.rect.size.y - 2))
		var x = randi_range(node.rect.position.x + 1, node.rect.end.x - w - 1)
		var y = randi_range(node.rect.position.y + 1, node.rect.end.y - h - 1)
		node.room = Rect2i(x, y, w, h)
		rooms.append(node.room)

func _create_corridors(node: BSPNode) -> void:
	if node.left and node.right:
		_create_corridors(node.left)
		_create_corridors(node.right)
		var left_center = _get_room_center(node.left)
		var right_center = _get_room_center(node.right)
		corridors.append([left_center, right_center])

func _get_room_center(node: BSPNode) -> Vector2i:
	if node.room != Rect2i():
		return node.room.position + node.room.size / 2
	if node.left:
		return _get_room_center(node.left)
	return _get_room_center(node.right)
