class_name Entity extends CharacterBody2D

#region attriubte
enum PhysicsState {
	idle,
	walk,
	jump,
	fall,
	attack,
	hurt
}

var ground_states: Array[int] = [
	PhysicsState.idle,
	PhysicsState.walk,
	PhysicsState.attack
]

var pending_damage: Damage

var default_gravity: float = ProjectSettings.get("physics/2d/default_gravity") as float * 2

var direction: float = 1.0:
	set(value):
		direction = value
		$graphics.scale.x = sign(value)

@export var run_velocity: float = 160.0
@export var jump_velocity: float = -320.0

var floor_acceleration: float = 800.0:
	get(): return run_velocity * 5

var air_acceleration: float = 8000.0:
	get(): return run_velocity * 50

var _is_first_tick: bool = false
#endregion

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var interface: MotionInterface = $MotionInterface
@onready var physics_state_machine: PhysicsStateMachine = $PhysicsStateMachine


#region motion
func move(gravity: float, delta: float) -> void:
	var movement: float = interface.get_direction()
	var acceleration: float = floor_acceleration if is_on_floor() else air_acceleration

	velocity.x = move_toward(velocity.x, movement * run_velocity, acceleration * delta)
	velocity.y += gravity * delta

	if not is_zero_approx(movement):
		direction = movement

	move_and_slide()


func stand(gravity: float, delta: float) -> void:
	var acceleration := floor_acceleration if is_on_floor() else air_acceleration
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta
	
	move_and_slide()
#endregion

#region internal
func internal_tick_physics(state: int, delta: float) -> void:
	interface.delay_process(delta)

	match state:
		PhysicsState.idle, PhysicsState.walk, PhysicsState.fall:
			move(default_gravity, delta)

		PhysicsState.jump:
			move(0.0 if _is_first_tick else default_gravity, delta)

		PhysicsState.attack, PhysicsState.hurt:
			stand(default_gravity, delta)

	_is_first_tick = false


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

	return PhysicsStateMachine.KeepCurrent


func internal_transition_state(from: int, to: int) -> void:
	if from not in ground_states and to in ground_states:
		interface.coyote_timer.stop()

	match to:
		PhysicsState.idle:
			animation_player.play("idle")
		
		PhysicsState.walk:
			animation_player.play("walk")
		
		PhysicsState.jump:
			animation_player.play("jump")
			velocity.y = jump_velocity
			interface.coyote_timer.stop()
			interface.jump_request_timer.stop()

		PhysicsState.fall:
			animation_player.play("fall")
			if from in ground_states:
				interface.coyote_timer.start()

		PhysicsState.attack:
			animation_player.play("attack")

		PhysicsState.hurt:
			animation_player.play("hurt")
			print("of!!!!!!!!!!!!!")

	_is_first_tick = true
#endregion


func tick_physics(state: int, delta: float) -> void:
	self.internal_tick_physics(state, delta)
 
func get_next_state(state: int) -> int:
	return self.internal_get_next_state(state)

func transition_state(from: int, to: int) -> void:
	self.internal_transition_state(from, to)


func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pending_damage = Damage.new(10.0, hitbox.owner)
