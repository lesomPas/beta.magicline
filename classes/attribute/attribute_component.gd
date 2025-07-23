class_name AttributeComponent extends Node

@export var attribute_collection: AttributeCollection

func _physics_process(delta: float) -> void:
	if is_instance_valid(attribute_collection):
		attribute_collection.process(delta)

func get_attribute_value(attribute_name: String) -> float:
	var attribute: Attribute = attribute_collection.find_attribute(attribute_name)
	return attribute.value()


func find_attribute(attribute_name: String) -> Attribute:
	return attribute_collection.find_attribute(attribute_name)
