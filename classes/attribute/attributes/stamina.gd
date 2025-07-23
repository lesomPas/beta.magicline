class_name StaminaAttribute extends Attribute

var player: Human

var stamina_increment: float = 2.0
var normal_clock: float = 0.0
var syncope_duration: float = 0.0
var state = player.BodyStates.normal

func process_function(delta: float) -> void:
	var stamina_point: float = self.value()
	if stamina_point >= 25.0:
		state = player.BodyStates.normal
		normal_clock += delta

		stamina_increment = 5.0 if (player.physics_state_machine.state_time >= 5.0 and \
									player.physics_state_machine.current_state == player.PhysicsState.idle) else 2.0
		if normal_clock >= 1.0:
			normal_clock = 0.0
			self.add(stamina_increment)

	elif stamina_point > 0.0 and stamina_point < 25.0:
		state = player.BodyStates.dizzy

	else:
		state = player.BodyStates.syncope
		syncope_duration += delta

		if syncope_duration >= 120.0:
			self.set_value(10.0)
			syncope_duration = 0.0
