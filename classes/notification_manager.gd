class_name NotificationManager extends CanvasLayer

@export var wait_duration: float = 2.0  # 在屏幕右侧等待的时间
@export var move_duration: float = 0.5  # 移动动画持续时间

var notifications: Queue = Queue.new()
var is_animating: bool = false

func annuonce(content: String) -> void:
	notifications.put_item(content)
	if !is_animating:
		show_annuonce()

func show_annuonce() -> void:
	if notifications.empty():
		is_animating = false
		return

	is_animating = true
	var content: String = " " + notifications.get_item() + " "

	var label: Label = Label.new()
	label.visible = false
	label.text = content
	var viewport_size = get_viewport().get_visible_rect().size
	label.position.x = label.size.x + viewport_size.x

func 
