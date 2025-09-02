class_name InteractableObject extends Area2D

signal interacted

@export var enable: bool = true:
	set(value):
		enable = value
		self.monitoring = value

@export var player_enable: bool = true:
	set(value):
		set_collision_mask_value(2, value)
		player_enable = value

@export var npc_enable: bool = true:
	set(value):
		set_collision_mask_value(3, value)
		npc_enable = value

@export var no_lab: bool = false
@export var tip: String = ""
@export var no_outline: bool = false

@export var immediate_interact: bool = false

var lab_visible: bool = false:
	set(value):
		if no_lab:
			return
		$Label.visible = value
		lab_visible = value

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, player_enable)
	set_collision_mask_value(3, npc_enable)

	body_entered.connect(
		_on_body_entered
	)
	body_exited.connect(
		_on_body_exited
	)

	if !no_lab:
		$Label.theme = load("res://style/tip.tres")
		$Label.text = "  " + tip + "  "
	if !no_outline:
		$Sprite2D.material = load("res://shader/sprite_outline.gdshader")

func interact(human: Human) -> void:
	print("[Intercated] %s" % name)
	interacted.emit()

func _on_body_entered(human: Human) -> void:
	human.register_interactable(self)
	if !no_outline:
		$Sprite2D.set_instance_shader_parameter("shader_parameter/outline_width", 1.0)
	if immediate_interact:
		interact(human)

func _on_body_exited(human: Human) -> void:
	human.unregister_interactable(self)
	if !no_outline:
		$Sprite2D.set_instance_shader_parameter("shader_parameter/outline_width", 0.0)
