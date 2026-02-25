@tool
class_name DialogTree extends Resource

@export var entries: Array[DialogEntry] = []
@export var connections: Array[Dictionary] = []
@export var start_node_id: int = 0

func get_entry(id: int) -> DialogEntry:
	for entry in entries:
		if entry.id == id:
			return entry
	return null

func get_next_entries(from_id: int) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for conn in connections:
		if conn.from_id == from_id:
			results.append(conn)
	return results

func export_json(path: String) -> void:
	var data := {
		"entries": entries.map(func(e): return e.to_dict()),
		"connections": connections,
		"start": start_node_id
	}
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
