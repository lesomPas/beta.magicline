extends Sprite2D

var enabled: bool = true:
	set(value):
		self.visible = value
		$point.visible = value
		enabled = value

var radius: float = self.texture.get_size().x / 2
var global_radius: float = 0.0
var ondarging: int = -1
@export var recovery_time: float = 0.2

func _input(event: InputEvent) -> void:
	if not enabled:
		return

	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var mouse_position: float = (event.position - self.global_position).length()

		if mouse_position <= global_radius or event.get_index() == ondarging:
			ondarging = event.get_index()
			$point.set_global_position(event.position)

			if $point.position.length() > radius:
				$point.set_position($point.position.normalized()*radius)

	if event is InputEventScreenTouch and !event.is_pressed():
		if event.get_index() == ondarging:
			ondarging = -1

			var tween = get_tree().create_tween() 
			tween.tween_property($point, "position", Vector2.ZERO, recovery_time).set_trans(Tween.TRANS_LINEAR)

func get_current_position() -> Vector2:
	return $point.position.normalized() if enabled else Vector2.ZERO
