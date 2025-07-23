extends Node2D

@onready var joystick: Sprite2D = %joystick

func _ready() -> void:
	joystick.global_radius = joystick.radius * joystick.scale.x
