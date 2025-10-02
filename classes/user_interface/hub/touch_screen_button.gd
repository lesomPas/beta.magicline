extends TouchScreenButton

var _origin_shape2d: Shape2D
var _null_shape2d: Shape2D

func _ready() -> void:
	MagiclineDirector.connect_signal(
		MagiclineDirector.get_ui_manager(),
		"ui_block_changed",
		_on_ui_block_changed
	)

	_origin_shape2d = shape

	_null_shape2d = CircleShape2D.new()
	_null_shape2d.radius = 0.0

func _on_ui_block_changed(blocked: bool) -> void:
	shape = _null_shape2d if blocked else _origin_shape2d
