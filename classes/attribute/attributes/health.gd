class_name HealthAttribute extends Attribute

var player: Human
var normal_clock: float = 0.0
var dying_duration: float = 0.0
var state = player.BodyStates.normal

func _in_range(_value: float, _min: float, _max: float) -> bool:
	return (_value >= _min) and (_value <= _max)

func process_function(delta: float) -> void:
	var stamina_point: float = get_value("stamina")
	normal_clock += delta
	if stamina_point >= 20.0 and normal_clock >= 1.0:
		self.add(stamina_point / 20.0)
		normal_clock = 0.0

	var health_point: float = self.value()
	if _in_range(health_point, 25.0, 100.0):
		state = player.BodyStates.normal

	elif _in_range(health_point, 15.0, 25.0):
		state = player.BodyStates.dizzy

	elif _in_range(health_point, 5.0, 15.0):
		state = player.BodyStates.syncope

	elif player.body_state <= player.BodyStates.dying:
		state = player.BodyStates.dying
	_try_to_skip(delta)

func _try_to_skip(delta: float) -> void:
	if player.body_state != player.BodyStates.dying:
		dying_duration = 0.0
		return
	dying_duration += delta
	if dying_duration >= 9.0:
		state = player.BodyStates.skip

func translate_hp(points: float) -> void:
	var magic_attribute: Attribute = get_attribute("magic_point")
	if magic_attribute.value() < points:
		return

	magic_attribute.subtract(points)
	self.add(points * 3)

func translate_mp(points: float) -> void:
	if self.value() < points:
		return

	get_attribute("magic_point").add(points / 4.0)
	self.subtract(points)
