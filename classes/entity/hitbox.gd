class_name Hitbox extends Area2D

signal hit(hurtbox: Hurtbox)

@export var amount: float = 10.0

func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox: Hurtbox) -> void:
	print("hitting: %s -> %s" % [owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
