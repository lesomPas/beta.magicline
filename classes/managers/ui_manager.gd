class_name UIManager extends Node

signal ui_block_changed(blocked: bool)

func set_ui_block(value: bool) -> void:
	ui_block_changed.emit(value)
	MagiclineDirector.announce("输入已" + ("关闭!" if value else "开启!"))
