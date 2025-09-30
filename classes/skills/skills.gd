class_name RealSkills extends Node

signal finished(objects: Array[Human])
signal stopped(objects: Array[Human])
signal interrupted(objects: Array[Human])

var objs: Array[Human] = []

var skip_initialize: bool = false   # 跳过初始化
var init_conditional_stop: bool = false   # 不满足初始化条件立即停止

# enable on continuity is true
var continuity: bool = false   # 延续性
var only_enter_conditional: bool = true   # 只在进入的时候检查循环条件, 不满足停止.
var interval: float = 0.5   # 运行间隔 (s)
var duration: float = 2.0   # 运行时长 (s)
var loop_conditional_stop: bool = false   # 不满足循环条件立即停止

# effect internal args
var _remaining_ms: int = 0
var _interval_clock: float = 0.0
var _effecting: bool = false

func _init() -> void:
	if !continuity && skip_initialize:
		push_error("warning at effect")
		return


func effect(objects: Array[Human]) -> void:
	objs = objects

	if objs.is_empty():
		finished.emit(objs)
		return

	if _effecting:
		stopped.emit(objs)
		return

	if !skip_initialize:
		# 有初始化，满足初始化条件
		if initialize_effect_condition():
			on_initialize_effect()
		# 如果设定不满足初始化条件立即停止
		elif init_conditional_stop:
			stopped.emit(objs)
			return

	if continuity:
		# 有延续性且满足条件
		if loop_effect_condition():
			_remaining_ms = int(duration * 1000) 
			_interval_clock = 0.0
			_effecting = true
			set_physics_process(true)
		# 有延续性但不满足条件, 且进行入循环检测或者不满足条件立即停止
		elif only_enter_conditional || loop_conditional_stop:
			stopped.emit(objs)


func _physics_process(delta: float) -> void:
	if !_effecting:
		return

	_remaining_ms -= int(delta * 1000)
	if exit_condition():
		stop()
		finished.emit(objs)
		return

	_interval_clock += delta
	if _interval_clock < interval:
		return

	_interval_clock -= interval
	# 循环条件只检查一次的立即作用
	if only_enter_conditional:
		on_loop_effect()
		return

	# 满足循环条件的作用
	if loop_effect_condition():
		on_loop_effect()
	# 如果设定不满足循环条件直接停止
	elif loop_conditional_stop:
		stop()
		stopped.emit(objs)


func is_effecting() -> bool:
	return _effecting

func interrupt() -> void:
	_effecting = false
	set_physics_process(false)
	interrupted.emit(objs)

func run() -> void:
	if exit_condition():
		push_warning("directly exit at effect")
		return
	_effecting = true
	set_physics_process(true)

func stop() -> void:
	_remaining_ms = 0
	_interval_clock = 0.0
	_effecting = false
	set_physics_process(false)

#region subclass need to override
func exit_condition() -> bool:
	return _remaining_ms <= 0

func initialize_effect_condition() -> bool:
	return true

func loop_effect_condition() -> bool:
	return true

func on_initialize_effect() -> void:
	pass

func on_loop_effect() -> void:
	pass

#endregion
