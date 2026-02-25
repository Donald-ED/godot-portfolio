extends Control

@export var dialog_runner: DialogRunner
@onready var speaker_label := $Panel/VBoxContainer/SpeakerLabel
@onready var text_label := $Panel/VBoxContainer/TextLabel
@onready var choices_container := $Panel/VBoxContainer/ChoicesContainer
@onready var continue_button := $Panel/VBoxContainer/ContinueButton

var is_showing: bool = false
var char_display_speed: float = 0.03
var current_text: String = ""
var displayed_chars: int = 0
var text_timer: float = 0.0

func _ready() -> void:
	visible = false
	continue_button.pressed.connect(_on_continue)
	if dialog_runner:
		dialog_runner.dialog_started.connect(_on_dialog_started)
		dialog_runner.line_displayed.connect(_on_line_displayed)
		dialog_runner.choices_presented.connect(_on_choices_presented)
		dialog_runner.dialog_ended.connect(_on_dialog_ended)

func _process(delta: float) -> void:
	if is_showing and displayed_chars < current_text.length():
		text_timer += delta
		if text_timer >= char_display_speed:
			text_timer = 0.0
			displayed_chars += 1
			text_label.text = current_text.substr(0, displayed_chars)

func _on_dialog_started() -> void:
	visible = true
	is_showing = true

func _on_line_displayed(speaker: String, text: String) -> void:
	speaker_label.text = speaker
	current_text = text
	displayed_chars = 0
	text_timer = 0.0
	text_label.text = ""
	choices_container.visible = false
	continue_button.visible = true

func _on_choices_presented(choices: Array[String]) -> void:
	choices_container.visible = true
	continue_button.visible = false
	for child in choices_container.get_children():
		child.queue_free()
	for i in range(choices.size()):
		var btn = Button.new()
		btn.text = choices[i]
		var idx = i
		btn.pressed.connect(func(): dialog_runner.select_choice(idx))
		choices_container.add_child(btn)

func _on_continue() -> void:
	if displayed_chars < current_text.length():
		displayed_chars = current_text.length()
		text_label.text = current_text
	else:
		dialog_runner.advance()

func _on_dialog_ended() -> void:
	visible = false
	is_showing = false
