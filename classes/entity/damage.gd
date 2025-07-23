class_name Damage extends RefCounted

var amount: float
var source: Entity

func _init(_amount: float, _source: Entity) -> void:
	amount = _amount
	source = _source
