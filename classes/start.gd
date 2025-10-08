extends Node2D

@onready var joystick: Sprite2D = %joystick

@onready var fps_lab: Label = %FPSLab
@onready var version_lab: Label = %VersionLab
@onready var pos: Label = %PositionLab
@onready var state: Label = %StateLab
@onready var time: Label = %TimeLab
@onready var attribute_lab: Label = %AttributeLab
@onready var velocity_lab: Label = %VelocityLab

@onready var witch: CharacterBody2D = $witch

@onready var player: Player = %player
@onready var debug_labs: VFlowContainer = $CanvasLayer/Control/VFlowContainer

var _day_time: String = ""
var _days: int = 0

func _ready() -> void:
	MagiclineDirector.connect_signal(
		MagiclineDirector.get_time_manager(),
		"day_changed",
		_on_day_changed
	)

	_day_time = MagiclineDirector.get_format_day_time()
	joystick.global_radius = joystick.radius * joystick.scale.x


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		var p: bool = !debug_labs.visible
		debug_labs.visible = p
		MagiclineDirector.set_debug_mode(p)

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
		MagiclineDirector.get_format_daily_time(),
		_days
	]
	attribute_lab.text = " %.2f/100.0h %.2f/120.0m %.2f/100.0s " % [
		player.health_attribute.value(),
		player.magic_attribute.value(),
		player.stamina_attribute.value()
	]
	velocity_lab.text = " velocity: x %.2f/b y %.2f/b " % [
		player.velocity.x / 64.0,
		player.velocity.y / 64.0
	]
	fps_lab.text = " FPS: %d " % Engine.get_frames_per_second()
	version_lab.text = " 测试版 / ver %s " % ProjectSettings.get("application/config/version")

func update_player(pos: Vector2, direction: float = 1.0) -> void:
	$%player.teleport_to(pos, direction)

func _on_day_changed(days: int) -> void:
	_day_time = MagiclineDirector.get_format_day_time()
	_days = days
