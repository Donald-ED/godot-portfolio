@tool
class_name DialogCondition extends Resource

@export var variable_name: String = ""
@export var operator: String = "=="
@export var value: String = ""

func evaluate(variables: Dictionary) -> bool:
	var var_value = variables.get(variable_name, 0)
	var compare = value.to_int() if value.is_valid_int() else value
	match operator:
		"==": return var_value == compare
		"!=": return var_value != compare
		">": return var_value > compare
		"<": return var_value < compare
		">=": return var_value >= compare
		"<=": return var_value <= compare
	return false

func to_string() -> String:
	return "%s %s %s" % [variable_name, operator, value]

static func from_string(s: String) -> DialogCondition:
	var cond = DialogCondition.new()
	var parts = s.split(" ")
	if parts.size() >= 3:
		cond.variable_name = parts[0]
		cond.operator = parts[1]
		cond.value = parts[2]
	return cond
