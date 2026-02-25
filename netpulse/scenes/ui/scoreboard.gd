extends Control

@onready var score_container := $VBoxContainer

func update_scores(scores: Dictionary) -> void:
	for child in score_container.get_children():
		child.queue_free()
	var sorted_ids = scores.keys()
	sorted_ids.sort_custom(func(a, b): return scores[a] > scores[b])
	for id in sorted_ids:
		var hbox = HBoxContainer.new()
		var name_label = Label.new()
		name_label.text = PlayerRegistry.get_player_name(id)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var score_label = Label.new()
		score_label.text = str(scores[id])
		hbox.add_child(name_label)
		hbox.add_child(score_label)
		score_container.add_child(hbox)
