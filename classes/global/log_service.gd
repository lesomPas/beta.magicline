class_name LogService extends Node

@export var level_console: int = 1   # 0=Error 1=Warn 2=Info 3=Debug
@export var level_file: int = 1

signal log_event(level: int, time: float, module: String, msg: String, data: Dictionary)


func error(module: String, msg: String, data: Dictionary = {}) -> void:
	self.push(0, module, msg, data)

func warning(module: String, msg: String, data: Dictionary = {}) -> void:
	self.push(1, module, msg, data)

func info(module: String, msg: String, data: Dictionary = {}) -> void:
	self.push(2, module, msg, data)

func debug(module: String, msg: String, data: Dictionary = {}) -> void:
	self.push(3, module, msg, data)


func push(level: int, module: String, msg: String, data: Dictionary = {}) -> void:
	var t := Time.get_datetime_string_from_system()
	_on_log(level, t, module, msg, data)
	log_event.emit(level, t, module, msg, data)


func _on_log(level: int, time: String, module: String, msg: String, data: Dictionary) -> void:
	if level <= level_console:
		if level == 0:
			print_rich("[color=red][%s][/color] %s: %s %s" % [level, module, msg, data])
		elif level == 1:
			print_rich("[color=yellow][%s][/color] %s: %s %s" % [level, module, msg, data])
		elif level == 2:
			print("[%s] %s: %s %s" % [level, module, msg, data])

	if  MagiclineDirector.debug_mode && level == 3:
		print_rich("[color=blue][%s][/color] %s: %s %s" % [level, module, msg, data])

	if level <= level_file:
		pass
		#_file_write(level, time, module, msg, data)


func _file_write(level: int, time: String, module: String, msg: String, data: Dictionary) -> void:
	# 每天一个文件，异步写
	var fname = "user://log_%s.log" % Time.get_datetime_string_from_system()
	var line = "%d | %f | %s | %s | %s\n" % [level, time, module, msg, data]
	FileAccess.open_compressed(fname, FileAccess.WRITE_READ).store_line(line)
