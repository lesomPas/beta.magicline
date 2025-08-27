extends MotionInterface

@onready var joystick := get_node("/root/start/CanvasLayer/joystick")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()

	if Input.is_action_just_pressed("jump"):
		jump_request_timer.start()

	if Input.is_action_just_released("jump"):
		jump_request_timer.stop()
		if owner.velocity.y < owner.jump_velocity / 2:
			owner.velocity.y = owner.jump_velocity / 2

	if Input.is_action_pressed("interact") and !owner.interacting_with.is_empty():
		owner.interacting_with.back().interact()

	if Input.is_key_pressed(KEY_R):
		owner.health_attribute.subtract(10.0)
		owner.stamina_attribute.set_value(0.0)

func delay_process(delta: float) -> void:
	should_attack = false

func get_direction() -> float:
	var direction: float
	var joystick_position: Vector2 = joystick.get_current_position()

	if not is_zero_approx(joystick_position.x):
		direction = joystick_position.x
	else:
		direction = Input.get_axis("move_left", "move_right")
	return direction
