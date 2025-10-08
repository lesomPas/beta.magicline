extends Node

const player_id: String = "operator.0"

# core value in game
var debug_mode: bool = true:
	set = set_debug_mode

# core signal
signal debug_mode_changed(mode: bool)

# core managers in game
var _ui_manager: UIManager
var _announce_manager: AnnounceManager
var _time_manager: TimeManager
var _name_map: NameMap
var _scene_manager: SceneManager
var _log_service: LogService

func _enter_tree() -> void:
	_ui_manager = UIManager.new()
	_announce_manager = AnnounceManager.new()
	_time_manager = TimeManager.new()
	_name_map = NameMap.new()
	_scene_manager = SceneManager.new()
	_log_service = LogService.new()

	add_child(_ui_manager)
	add_child(_announce_manager)
	add_child(_time_manager)
	add_child(_name_map)
	add_child(_scene_manager)
	add_child(_log_service)


func _ready() -> void:
	debug_mode = true


func set_debug_mode(value: bool) -> void:
	if debug_mode != value:
		debug_mode = value
		self.announce("Debug Mode is " + ("On" if value else "Off"))
		debug_mode_changed.emit(value)


func connect_signal(manager: Node, signal_name: StringName, target: Callable, deferred: bool = false) -> void:
	if not manager.has_signal(signal_name):
		push_error("invaild signal: " + signal_name)
		return

	var flags := CONNECT_DEFERRED if deferred else 0
	manager.connect(
		signal_name,
		target,
		flags
	)

	tree_exiting.connect(
		func():
			if manager && manager.has_signal(signal_name) && manager.is_connected(signal_name, target):
				manager.disconnect(signal_name, target)
	)


func get_ui_manager() -> UIManager:
	return _ui_manager

func get_announce_manager() -> AnnounceManager:
	return _announce_manager

func get_time_manager() -> TimeManager:
	return _time_manager

func get_name_map() -> NameMap:
	return _name_map

func get_scene_manager() -> SceneManager:
	return _scene_manager

func get_player() -> Player:
	return _name_map.get_by_id(player_id) as Player

func get_log_service() -> LogService:
	return _log_service


func change_ui_block(blocked: bool) -> void:
	_ui_manager.set_ui_block(blocked)

func announce(content: String) -> void:
	_announce_manager.announce(content)

func get_format_daily_time() -> String:
	return _time_manager.format_daily_time()

func get_format_day_time() -> String:
	return _time_manager.format_day_time()

func register_human_info(human: Human = null, _name: String = "", _cn_name: String = "", _id: String = "") -> void:
	_name_map.register(human, _name, _cn_name, _id)

func change_scene(path: String, entry_point: String) -> void:
	_scene_manager.change_scene(path, entry_point)
