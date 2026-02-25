@tool
extends Control

@onready var graph_edit := $GraphEdit
@onready var file_menu := $Toolbar/FileMenu
@onready var add_dialog_btn := $Toolbar/AddDialogButton
@onready var add_condition_btn := $Toolbar/AddConditionButton
@onready var add_choice_btn := $Toolbar/AddChoiceButton

var current_tree: DialogTree
var node_counter: int = 0
var dialog_node_scene = preload("res://addons/gdforge/editor/dialog_node.tscn")
var condition_node_scene = preload("res://addons/gdforge/editor/condition_node.tscn")

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	graph_edit.connection_request.connect(_on_connection_request)
	graph_edit.disconnection_request.connect(_on_disconnection_request)
	add_dialog_btn.pressed.connect(_add_dialog_node)
	add_condition_btn.pressed.connect(_add_condition_node)
	add_choice_btn.pressed.connect(_add_choice_node)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)
	if current_tree:
		current_tree.connections.append({
			"from_id": _get_node_id(from_node),
			"from_port": from_port,
			"to_id": _get_node_id(to_node),
			"to_port": to_port
		})

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	if current_tree:
		current_tree.connections = current_tree.connections.filter(func(c):
			return not (c.from_id == _get_node_id(from_node) and c.from_port == from_port and
				       c.to_id == _get_node_id(to_node) and c.to_port == to_port))

func _add_dialog_node() -> void:
	var node = dialog_node_scene.instantiate()
	_setup_node(node, "dialog")
	graph_edit.add_child(node)

func _add_condition_node() -> void:
	var node = condition_node_scene.instantiate()
	_setup_node(node, "condition")
	graph_edit.add_child(node)

func _add_choice_node() -> void:
	var node = dialog_node_scene.instantiate()
	_setup_node(node, "choice")
	node.setup_as_choice()
	graph_edit.add_child(node)

func _setup_node(node: GraphNode, type: String) -> void:
	node_counter += 1
	node.name = "%s_%d" % [type, node_counter]
	node.position_offset = Vector2(randf_range(50, 400), randf_range(50, 300))
	node.set_meta("node_id", node_counter)
	node.set_meta("node_type", type)

func _get_node_id(node_name: StringName) -> int:
	var node = graph_edit.get_node(NodePath(node_name))
	return node.get_meta("node_id", -1)

func load_tree(tree: DialogTree) -> void:
	_clear_graph()
	current_tree = tree
	for entry in tree.entries:
		var node: GraphNode
		match entry.type:
			"dialog":
				node = dialog_node_scene.instantiate()
			"condition":
				node = condition_node_scene.instantiate()
			"choice":
				node = dialog_node_scene.instantiate()
				node.setup_as_choice()
		if node:
			node.set_meta("node_id", entry.id)
			node.set_meta("node_type", entry.type)
			node.name = "%s_%d" % [entry.type, entry.id]
			graph_edit.add_child(node)
			node.load_data(entry)
	for conn in tree.connections:
		var from_name = _find_node_by_id(conn.from_id)
		var to_name = _find_node_by_id(conn.to_id)
		if from_name and to_name:
			graph_edit.connect_node(from_name, conn.from_port, to_name, conn.to_port)

func save_tree() -> DialogTree:
	if not current_tree:
		current_tree = DialogTree.new()
	current_tree.entries.clear()
	current_tree.connections.clear()
	for child in graph_edit.get_children():
		if child is GraphNode:
			var entry = child.save_data()
			entry.id = child.get_meta("node_id")
			entry.type = child.get_meta("node_type")
			current_tree.entries.append(entry)
	for conn_info in graph_edit.get_connection_list():
		current_tree.connections.append({
			"from_id": _get_node_id(conn_info.from_node),
			"from_port": conn_info.from_port,
			"to_id": _get_node_id(conn_info.to_node),
			"to_port": conn_info.to_port
		})
	return current_tree

func _clear_graph() -> void:
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			child.queue_free()
	node_counter = 0

func _find_node_by_id(id: int) -> StringName:
	for child in graph_edit.get_children():
		if child is GraphNode and child.get_meta("node_id") == id:
			return child.name
	return &""

func export_json(path: String) -> void:
	var tree = save_tree()
	tree.export_json(path)
