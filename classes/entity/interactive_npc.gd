class_name InteractiveNPC extends Human

enum NPCState {
	idle = PhysicsState.idle,
	walk = PhysicsState.walk,
	jump = PhysicsState.jump,
	fall = PhysicsState.fall,
	attack = PhysicsState.attack,
	hurt = PhysicsState.hurt,
	follow
}

var player: Human
@onready var wall_checker: RayCast2D = $graphics/WallChecker
@onready var floor_checker: RayCast2D = $graphics/FloorChecker
@onready var player_checker: Area2D = $graphics/PlayerChecker

func _ready() -> void:
	ground_states.append(NPCState.follow)

func _tick_physics(state: int, delta: float) -> void:
	if state < 6:
		self.internal_tick_physics(state, delta)
		return

	interface.delay_process(delta)
	match state:
		NPCState.follow:
			pass

	_is_first_tick = false


func _transition_state(from: int, to: int) -> void:
	if to < 6:
		self.internal_transition_state(from, to)
		return

	if from not in ground_states and to in ground_states:
		interface.coyote_timer.stop()

	match to:
		NPCState.follow:
			player = player_checker.get_overlapping_bodies()[0]
			animation_player.play("walk")


func internal_get_next_state(state: int) -> int:
	if pending_damage:
		return PhysicsState.hurt

	var can_jump: bool = is_on_floor() or interface.coyote_timer.time_left > 0
	if can_jump and interface.jump_request_timer.time_left > 0:
		return PhysicsState.jump

	if state in ground_states and not is_on_floor():
		return PhysicsState.fall

	var movement := interface.get_direction()
	var is_still := is_zero_approx(movement) and is_zero_approx(velocity.x)

	match state:
		PhysicsState.idle:
			if interface.should_attack:
				return PhysicsState.attack
			if not is_still:
				return PhysicsState.walk

		PhysicsState.walk:
			if interface.should_attack:
				return PhysicsState.attack
			if is_still:
				return PhysicsState.idle

		PhysicsState.jump:
			if velocity.y >= 0:
				return PhysicsState.fall

		PhysicsState.fall:
			if is_on_floor():
				return PhysicsState.idle if is_still else PhysicsState.walk

		PhysicsState.attack:
			if not animation_player.is_playing():
				return PhysicsState.idle

		PhysicsState.hurt:
			if not animation_player.is_playing():
				return PhysicsState.idle

		NPCState.follow:
			if Input.is_action_pressed("reset"):
				return PhysicsState.idle

			if not player_checker.has_overlapping_bodies():
				return PhysicsState.idle

	return PhysicsStateMachine.KeepCurrent


func tick_physics(state: int, delta: float) -> void:
	self._tick_physics(state, delta)
 
func get_next_state(state: int) -> int:
	return self.internal_get_next_state(state)

func transition_state(from: int, to: int) -> void:
	self._transition_state(from, to)
