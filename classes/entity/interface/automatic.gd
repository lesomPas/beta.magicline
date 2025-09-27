class_name AutomaticInterface extends MotionInterface

@onready var turn_back_timer: Timer = $TurnBackTimer

var physics_state_machine: PhysicsStateMachine
var npc: InteractiveNPC = owner
var movement: float = 1.0

func _ready() -> void:
	await owner.ready
	physics_state_machine = owner.physics_state_machine

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		pass

	if Input.is_action_just_pressed("follow"):
		pass

func change_movement() -> float:
	var alpha_movement = randf_range(0.75, 1.25)
	return alpha_movement - 2.0 if alpha_movement > 1 else alpha_movement

func jmup() -> void:
	jump_request_timer.start()
	#await get_tree().create_timer(0.05).timeout
	#jump_request_timer.stop()

func get_direction() -> float:
	match physics_state_machine.current_state:
		npc.PhysicsState.idle:
			movement = 0.0 if physics_state_machine.state_time < 7.5 else change_movement()

		npc.PhysicsState.walk:
			if turn_back_timer.time_left <= 0.0:
				turn_back_timer.start(randi_range(3, 6))
				movement = change_movement()

			movement = movement if physics_state_machine.state_time < 7.5 else 0.0

		npc.NPCState.follow:
			var delta_position: Vector2 = npc.direction_to()
			var dircetion: float = sign(delta_position.x)

			movement = dircetion if delta_position.length() >= 200.0 else 0.0

	return movement
