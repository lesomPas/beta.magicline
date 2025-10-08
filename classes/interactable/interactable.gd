class_name Interactable extends Area2D
 
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

@export var immediate_interact: bool = false


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


func set_label_visible(value: bool) -> void:
	pass

func interact(human: Human) -> void:
	print("[Intercated] %s" % name)
	interacted.emit()
	on_interact(human)

func on_interact(human: Human) -> void:
	pass

func _on_body_entered(human: Human) -> void:
	human.register_interactable(self)
	if immediate_interact:
		interact(human)

func _on_body_exited(human: Human) -> void:
	human.unregister_interactable(self)
