@tool
class_name DialogEntry extends Resource

@export var id: int = 0
@export var type: String = "dialog"
@export var speaker: String = ""
@export var text: String = ""
@export var choices: Array[String] = []
@export var condition: String = ""
@export var position: Vector2 = Vector2.ZERO

func to_dict() -> Dictionary:
	return {
		"id": id,
		"type": type,
		"speaker": speaker,
		"text": text,
		"choices": choices,
		"condition": condition
	}

static func from_dict(data: Dictionary) -> DialogEntry:
	var entry = DialogEntry.new()
	entry.id = data.get("id", 0)
	entry.type = data.get("type", "dialog")
	entry.speaker = data.get("speaker", "")
	entry.text = data.get("text", "")
	entry.choices = data.get("choices", [])
	entry.condition = data.get("condition", "")
	return entry
