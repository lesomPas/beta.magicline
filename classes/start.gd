extends Node2D

@onready var joystick: Sprite2D = %joystick

@onready var pos: Label = %PositionLab
@onready var state: Label = %StateLab
@onready var time: Label = %TimeLab
@onready var time_manager: TimeManager = %TimeManager

var _day_time: String = ""
var _days: int = 0

func _ready() -> void:
	_day_time = time_manager.format_day_time()
	joystick.global_radius = joystick.radius * joystick.scale.x

func _process(delta: float) -> void:
	var block: Block = Block.blockv(%player.global_position)
	pos.text = " position::(%s, %s) " % [
		block.x, 
		block.y, 
	]
	state.text = " state: <%s> " % [
		%player.BodyStates.keys()[%player.body_state]
	]
	time.text = " time: %s %s days: %d " % [
		_day_time,
		time_manager.format_daily_time(),
		_days
	]


func _on_time_manager_day_changed(days: int) -> void:
	_day_time = time_manager.format_day_time()
	_days = days
