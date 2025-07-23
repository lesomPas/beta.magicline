extends MotionInterface

@onready var turn_back_timer: Timer = $TurnBackTimer

var physics_state_machine: PhysicsStateMachine

func _ready() -> void:
	await owner.ready
	physics_state_machine = owner.physics_state_machine

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		pass

	if Input.is_action_just_pressed("follow"):
		pass
