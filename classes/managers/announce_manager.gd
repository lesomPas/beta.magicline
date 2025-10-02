class_name AnnounceManager extends CanvasLayer

@export var wait_duration: float = 2.5  # 在屏幕右侧等待的时间
@export var move_duration: float = 0.5  # 移动动画持续时间

var notifications: Queue = Queue.new()
var labels: Queue = Queue.new()
var exit_labels: Queue = Queue.new()


func announce(content: String) -> void:
	notifications.put_item(content)
	show_announce()

func show_announce() -> void:
	if notifications.empty():
		return

	var content: String = " " + notifications.get_item() + " "

	var label: Label = Label.new()
	label.visible = false
	label.text = content
	label.theme = load("res://style/announce.tres")

	lower_announce()
	self.add_child(label)
	labels.put_item(label)

	var viewport_size = get_viewport().get_visible_rect().size
	label.position.x = label.size.x + viewport_size.x
	label.position.y = 10.0
	label.visible = true

	var tween: Tween = create_tween().set_trans(Tween.TRANS_CIRC)
	var target_x = viewport_size.x - label.size.x
	tween.tween_property(label, "position:x", target_x, move_duration)
	tween.tween_callback(show_announce)
	tween.tween_callback(return_announce).set_delay(wait_duration)


func return_announce() -> void:
	var label: Label = labels.get_item()
	exit_labels.put_item(label)

	var viewport_size = get_viewport().get_visible_rect().size
	var target_x = viewport_size.x + label.size.x

	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(label, "position:x", target_x, move_duration)
	tween.tween_callback(func():
		exit_labels.get_item().queue_free()
	).set_delay(move_duration)


func lower_announce() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(true)

	for label: Label in (labels.get_data() + exit_labels.get_data()):
		var target_y = label.position.y + label.size.y + 10.0
		tween.tween_property(label, "position:y", target_y, 0.1)
