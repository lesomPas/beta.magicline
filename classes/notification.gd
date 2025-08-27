extends Node2D

# 导出变量，方便在编辑器中调整
@export var wait_duration: float = 2.0  # 在屏幕右侧等待的时间
@export var move_duration: float = 0.5  # 移动动画持续时间

@onready var label: PanelContainer = $CanvasLayer/PanelContainer

# 通知队列
var notification_queue: Array[String] = []
var is_animating: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		self.add_notification(" 哇哦，你吃到了毒蘑菇! ")

func _ready():
	# 初始隐藏标签
	label.visible = false
	
	# 设置初始位置在屏幕右侧外部
	var viewport_size = get_viewport().get_visible_rect().size
	label.position.x = viewport_size.x + label.size.x

# 添加通知到队列
func add_notification(text: String):
	notification_queue.append(text)
	if not is_animating:
		show_next_notification()

# 显示下一个通知
func show_next_notification():
	if notification_queue.is_empty():
		is_animating = false
		return

	is_animating = true
	var text = notification_queue.pop_front()
	$CanvasLayer/PanelContainer/NotificationLab.text = text

	# 确保标签尺寸更新
	await get_tree().process_frame

	# 设置初始位置在屏幕右侧外部
	var viewport_size = get_viewport().get_visible_rect().size
	label.position.x = viewport_size.x + label.size.x
	label.visible = true

	# 创建进入动画
	var enter_tween = create_tween().set_trans(Tween.TRANS_CIRC)
	var target_x = viewport_size.x - label.size.x  # 右边缘对齐屏幕右边缘
	enter_tween.tween_property(label, "position:x", target_x, move_duration)
	enter_tween.tween_callback(start_wait_timer)

# 开始等待计时器
func start_wait_timer():
	var timer = get_tree().create_timer(wait_duration)
	timer.timeout.connect(start_return_animation)

# 开始返回动画
func start_return_animation():
	var viewport_size = get_viewport().get_visible_rect().size
	var target_x = viewport_size.x + label.size.x  # 完全离开屏幕右侧

	# 创建返回动画
	var return_tween = create_tween()
	return_tween.tween_property(label, "position:x", target_x, move_duration)
	return_tween.tween_callback(finish_notification)

# 完成通知动画
func finish_notification():
	label.visible = false
	is_animating = false
	show_next_notification()
