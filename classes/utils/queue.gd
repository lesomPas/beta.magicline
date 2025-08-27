class_name Queue extends Node

var data: Array = []

func put_item(content: Variant) -> void:
	data.append(content)

func get_item() -> Variant:
	return data.pop_at(0)

func empty() -> bool:
	return data.is_empty()

func length() -> int:
	return 0
