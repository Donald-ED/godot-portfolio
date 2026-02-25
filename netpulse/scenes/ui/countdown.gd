extends Control

@onready var label := $Label

signal countdown_finished

func start_countdown(from: int = 3) -> void:
	visible = true
	for i in range(from, 0, -1):
		label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	label.text = "GO!"
	await get_tree().create_timer(0.5).timeout
	visible = false
	countdown_finished.emit()
