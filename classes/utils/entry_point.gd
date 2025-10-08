class_name EntryPoint extends Marker2D

@export var direction: float = 1.0

func _ready() -> void:
	add_to_group("/main/scene/teleporters")
