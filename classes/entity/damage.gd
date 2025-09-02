class_name Damage extends RefCounted

var amount: float
var source: Node2D

func _init(_amount: float, _source: Node2D) -> void:
	amount = _amount
	source = _source
