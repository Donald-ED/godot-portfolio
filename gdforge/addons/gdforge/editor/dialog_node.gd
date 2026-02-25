@tool
extends GraphNode

var speaker_edit: LineEdit
var text_edit: TextEdit
var choices_container: VBoxContainer
var is_choice_mode: bool = false

func _ready() -> void:
	title = "Dialog"
	speaker_edit = LineEdit.new()
	speaker_edit.placeholder_text = "Speaker name"
	add_child(speaker_edit)
	set_slot(0, true, 0, Color.WHITE, true, 0, Color.WHITE)
	text_edit = TextEdit.new()
	text_edit.placeholder_text = "Dialog text..."
	text_edit.custom_minimum_size = Vector2(250, 80)
	text_edit.scroll_fit_content_height = true
	add_child(text_edit)
	set_slot(1, false, 0, Color.WHITE, false, 0, Color.WHITE)

func setup_as_choice() -> void:
	is_choice_mode = true
	title = "Choice"
	if text_edit:
		text_edit.placeholder_text = "Choice prompt..."
	choices_container = VBoxContainer.new()
	add_child(choices_container)
	_add_choice_slot("Option 1")
	_add_choice_slot("Option 2")
	var add_btn = Button.new()
	add_btn.text = "+"
	add_btn.pressed.connect(func(): _add_choice_slot("New option"))
	add_child(add_btn)

func _add_choice_slot(default_text: String) -> void:
	var edit = LineEdit.new()
	edit.text = default_text
	edit.custom_minimum_size.x = 200
	choices_container.add_child(edit)
	var idx = choices_container.get_child_count() + 1
	set_slot(idx, false, 0, Color.WHITE, true, 0, Color.GREEN)

func save_data() -> DialogEntry:
	var entry = DialogEntry.new()
	entry.speaker = speaker_edit.text if speaker_edit else ""
	entry.text = text_edit.text if text_edit else ""
	if is_choice_mode and choices_container:
		entry.choices = []
		for child in choices_container.get_children():
			if child is LineEdit:
				entry.choices.append(child.text)
	return entry

func load_data(entry: DialogEntry) -> void:
	if speaker_edit:
		speaker_edit.text = entry.speaker
	if text_edit:
		text_edit.text = entry.text
	if entry.choices.size() > 0 and not is_choice_mode:
		setup_as_choice()
	if is_choice_mode and choices_container:
		for child in choices_container.get_children():
			child.queue_free()
		for choice in entry.choices:
			_add_choice_slot(choice)
