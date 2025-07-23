class_name MotionInterface extends Node

var should_attack: bool = false

@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var coyote_timer: Timer = $CoyoteTimer

func delay_process(delta: float) -> void:
	should_attack = false

func get_direction() -> float:
	return 1.0

func jump():
	jump_request_timer.start()

func attack() -> void:
	should_attack = true
