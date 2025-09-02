class_name LinearProjectile extends Hitbox

@export var speed: float = 1200.0

var direction_vector: Vector2 = Vector2.RIGHT

func setup(direction: Vector2) -> void:
	direction_vector = direction.normalized()
	rotate(direction.angle())

func _process(delta: float) -> void:
	global_position += direction_vector * speed * delta

func _on_hit(hurtbox: Hurtbox) -> void:
	pass
