extends MotionInterface

@onready var joystick := get_node("/root/start/CanvasLayer/Control2/joystick")

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("attack"):
		attack()

	if Input.is_action_just_pressed("jump"):
		jump_request_timer.start()

	if Input.is_action_just_released("jump"):
		jump_request_timer.stop()
		if owner.velocity.y < owner.jump_velocity / 2:
			owner.velocity.y = owner.jump_velocity / 2

		#var witch: InteractiveNPC = NameMap.name_map.get("sb")
		#witch.interface.jump()

	if Input.is_action_just_pressed("interact"):
		var interactable_obj: Interactable = get_parent().interactable_objs.back()
		if interactable_obj && !interactable_obj.immediate_interact:
			interactable_obj.interact(get_parent())

	if Input.is_key_pressed(KEY_0):
		MagiclineDirector.change_ui_block(true)
	
	if Input.is_key_pressed(KEY_1):
		MagiclineDirector.change_ui_block(false)

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
