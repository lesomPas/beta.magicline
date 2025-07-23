class_name ExtendedCamera2D extends Camera2D

# 预设震动强度
const light_shake: float = 2.0
const medium_shake: float = 4.0
const strong_shake: float = 6.0

# 默认震动时间
@export var default_shake_duration: float = 0.2

var is_shaking: bool = false
var shake_timer: float = 0.0
var original_offset: Vector2 = Vector2.ZERO
var current_strength: float = 0.0

func _ready() -> void:
	# 保存初始偏移量
	original_offset = self.offset

func _process(delta: float) -> void:
	if is_shaking:
		_update_shake(delta)

func stop_shake() -> void:
	self.offset = original_offset
	is_shaking = false
	shake_timer = 0.0
	current_strength = 0.0

func shake(strength: float = light_shake, shake_duration: float = default_shake_duration) -> void:
	if strength <= 0: 
		return
	is_shaking = true
	shake_timer = shake_duration
	current_strength = strength
	_apply_shake(current_strength)

func _update_shake(delta: float) -> void:
	shake_timer -= delta
	if shake_timer <= 0:
		is_shaking = false
		self.offset = original_offset
	else:
		# 计算线性变化强度因子
		var strength_factor: float = shake_timer / default_shake_duration
		_apply_shake(current_strength * strength_factor)

func _apply_shake(strength: float) -> void:
	offset = original_offset + Vector2(
		randf_range(-strength, strength),
		randf_range(-strength, strength)
	)
