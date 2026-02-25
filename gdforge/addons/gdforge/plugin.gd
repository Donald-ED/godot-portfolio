@tool
extends EditorPlugin

var editor_dock: Control

func _enter_tree() -> void:
	editor_dock = preload("res://addons/gdforge/editor/dialog_editor.tscn").instantiate()
	add_control_to_bottom_panel(editor_dock, "Dialog Editor")
	add_custom_type("DialogTree", "Resource",
		preload("res://addons/gdforge/resources/dialog_tree.gd"),
		get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons"))

func _exit_tree() -> void:
	remove_control_from_bottom_panel(editor_dock)
	remove_custom_type("DialogTree")
	if editor_dock:
		editor_dock.queue_free()
