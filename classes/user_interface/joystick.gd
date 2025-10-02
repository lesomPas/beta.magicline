extends Sprite2D

var enabled: bool = true
var visibility: bool = true:
	set(value):
		self.visible = value
		$point.visible = value

var radius: float = self.texture.get_size().x / 2
var global_radius: float = 0.0
var ondarging: int = -1
@export var recovery_time: float = 0.2

# 添加纹理导出变量
@export var normal_texture: Texture2D  # 正常状态纹理
@export var pressed_texture: Texture2D  # 选中状态纹理

func _ready() -> void:
	MagiclineDirector.connect_signal(
		MagiclineDirector.get_ui_manager(),
		"ui_block_changed",
		_on_ui_block_changed
	)
	if normal_texture:
		$point.texture = normal_texture

func _input(event: InputEvent) -> void:
	if not enabled:
		if ondarging != -1:
			_return_point(event)
		return

	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var mouse_position: float = (event.position - self.global_position).length()

		if mouse_position <= global_radius or event.get_index() == ondarging:
			ondarging = event.get_index()
			$point.set_global_position(event.position)

			# 更换为选中纹理
			if pressed_texture:
				$point.texture = pressed_texture

			if $point.position.length() > radius:
				$point.set_position($point.position.normalized()*radius)

	if event is InputEventScreenTouch and !event.is_pressed():
		if event.get_index() == ondarging:
			_return_point(event)


func _return_point(event: InputEvent) -> void:
	ondarging = -1
	$point.texture = normal_texture

	var tween = get_tree().create_tween() 
	tween.tween_property($point, "position", Vector2.ZERO, recovery_time).set_trans(Tween.TRANS_CIRC)

func get_current_position() -> Vector2:
	return $point.position.normalized() if enabled else Vector2.ZERO

func _on_ui_block_changed(blocked) -> void:
	enabled = !blocked
