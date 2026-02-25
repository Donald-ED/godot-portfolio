@tool
extends GraphNode

var condition_edit: LineEdit

func _ready() -> void:
	title = "Condition"
	resizable = true
	condition_edit = LineEdit.new()
	condition_edit.placeholder_text = "variable == value"
	condition_edit.custom_minimum_size.x = 200
	add_child(condition_edit)
	set_slot(0, true, 0, Color.WHITE, true, 0, Color.GREEN)
	var false_label = Label.new()
	false_label.text = "False →"
	false_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(false_label)
	set_slot(1, false, 0, Color.WHITE, true, 1, Color.RED)

func save_data() -> DialogEntry:
	var entry = DialogEntry.new()
	entry.condition = condition_edit.text if condition_edit else ""
	return entry

func load_data(entry: DialogEntry) -> void:
	if condition_edit:
		condition_edit.text = entry.condition
