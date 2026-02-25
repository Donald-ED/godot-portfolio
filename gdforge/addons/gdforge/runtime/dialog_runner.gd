class_name DialogRunner extends Node

signal dialog_started
signal line_displayed(speaker: String, text: String)
signal choices_presented(choices: Array[String])
signal dialog_ended

@export var dialog_tree: DialogTree
var current_entry_id: int
var variables: Dictionary = {}

func start() -> void:
	current_entry_id = dialog_tree.start_node_id
	dialog_started.emit()
	_process_entry()

func select_choice(index: int) -> void:
	var next = dialog_tree.get_next_entries(current_entry_id)
	if index < next.size():
		current_entry_id = next[index].to_id
		_process_entry()

func advance() -> void:
	var next = dialog_tree.get_next_entries(current_entry_id)
	if next.size() > 0:
		current_entry_id = next[0].to_id
		_process_entry()
	else:
		dialog_ended.emit()

func set_variable(key: String, value: Variant) -> void:
	variables[key] = value

func get_variable(key: String, default: Variant = null) -> Variant:
	return variables.get(key, default)

func _process_entry() -> void:
	var entry = dialog_tree.get_entry(current_entry_id)
	if not entry:
		dialog_ended.emit()
		return
	match entry.type:
		"dialog":
			var text = _interpolate(entry.text)
			line_displayed.emit(entry.speaker, text)
		"condition":
			var result = _evaluate(entry.condition)
			var next = dialog_tree.get_next_entries(current_entry_id)
			for conn in next:
				if (result and conn.from_port == 0) or (not result and conn.from_port == 1):
					current_entry_id = conn.to_id
					_process_entry()
					return
			dialog_ended.emit()
		"choice":
			choices_presented.emit(entry.choices)

func _interpolate(text: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\{(\\w+)\\}")
	for m in regex.search_all(text):
		text = text.replace(m.get_string(), str(variables.get(m.get_string(1), "")))
	return text

func _evaluate(condition: String) -> bool:
	var parts = condition.split(" ")
	if parts.size() == 3:
		var val = variables.get(parts[0], 0)
		match parts[1]:
			"==": return val == parts[2].to_int()
			">=": return val >= parts[2].to_int()
			"<=": return val <= parts[2].to_int()
			">": return val > parts[2].to_int()
			"<": return val < parts[2].to_int()
	return false
