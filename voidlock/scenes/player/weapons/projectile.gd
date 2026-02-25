extends Area2D

var speed: float = 400.0
var damage: int = 10
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 3.0

func _ready() -> void:
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
