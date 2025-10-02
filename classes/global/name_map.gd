class_name NameMap extends Node

var _name_map: Dictionary[String, Human] = {}
var _cn_name_map: Dictionary[String, Human] = {}
var _id_map: Dictionary[String, Human] = {}


func get_by_name(name: String) -> Human:
	return _name_map.get(name)

func get_by_cn_name(cn_name: String) -> Human:
	return _cn_name_map.get(cn_name)

func get_by_id(id: String) -> Human:
	return _id_map.get(id)

func has_any(_name: String = "", _cn_name: String = "", _id: String = "") -> bool:
	return _name_map.has(_name) or _cn_name_map.has(_cn_name) or _id_map.has(_id)

func get_all() -> Array[Human]:
	return _id_map.values()


func setup() -> void:
	_name_map.clear()
	_cn_name_map.clear()
	_id_map.clear()

func register(human: Human, _name: String, _cn_name: String, _id: String) -> bool:
	if human == null or not is_instance_valid(human):
		push_error("Register: Human 实例无效")
		return false
	if _name.is_empty() or _cn_name.is_empty() or _id.is_empty():
		push_error("Register: 存在空字符串键")
		return false

	if has_any(_name, _cn_name, _id):
		push_error("Register: 键已存在 → %s / %s / %s" % [_name, _cn_name, _id])
		return false

	_name_map[_name] = human
	_cn_name_map[_cn_name] = human
	_id_map[_id] = human

	if MagiclineDirector.debug_mode:
		print("Registered: %s | %s | %s" % [_name, _cn_name, _id])
	return true
