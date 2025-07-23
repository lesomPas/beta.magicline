class_name AttributeCollection extends Resource

@export var attributes: Array[Attribute]: set = setter_attributes

var attributes_runtime_dict: Dictionary[String, Attribute] = {}
# Dictionary[String, Array[Attribute]]
var derived_attributes_dict = {}


func setter_attributes(value: Array[Attribute]) -> void:
	attributes = value

	_create_runtime_attributes()
	_create_derived_attributes()
	_init_attributes()


func find_attribute(attribute_name: String) -> Attribute:
	if attributes_runtime_dict.has(attribute_name):
		return attributes_runtime_dict[attribute_name]
	push_warning("AttributeCollection: 未找到指定的属性对象 %s" % attribute_name)
	return null

func process(delta: float) -> void:
	for name in attributes_runtime_dict:
		var runtime_attribute: Attribute = attributes_runtime_dict[name]
		runtime_attribute.process(delta)

#region internal
func _create_runtime_attributes() -> void:
	attributes_runtime_dict.clear()
	for attr in attributes:
		if attributes_runtime_dict.has(attr.attribute_name):
			push_warning("AttributeCollection: 重复属性名称 %s" % attr.attribute_name)
			continue

		var duplicated_attribute = attr.duplicate(true) as Attribute
		duplicated_attribute.attribute_collection = self
		attributes_runtime_dict[attr.attribute_name] = duplicated_attribute
		duplicated_attribute.attribute_changed.connect(_on_attribute_changed)

func _create_derived_attributes() -> void:
	derived_attributes_dict.clear()
	for _name in attributes_runtime_dict:
		var runtime_attribute: Attribute = attributes_runtime_dict[_name]
		var derived_attribute_names: Array[String] = runtime_attribute.derived_from()

		for derived_name in derived_attribute_names:
			var derived_attribute: Attribute = find_attribute(derived_name)
			if not is_instance_valid(derived_attribute):
				push_warning("bulid derived_attribute failed: NotFind %s" % derived_name)

			if not derived_attributes_dict.has(derived_attribute.attribute_name):
				derived_attributes_dict[derived_attribute.attribute_name] = []
			var relative_attributes: Array = derived_attributes_dict[derived_attribute.attribute_name]
			relative_attributes.append(runtime_attribute)

func _init_attributes():
	for _name in attributes_runtime_dict:
		var runtime_attribute: Attribute = attributes_runtime_dict[_name]
		runtime_attribute.recompute_attribute()

func _on_attribute_changed(attribute: Attribute):
	_update_derived_attribute(attribute)

func _update_derived_attribute(derived_attribute: Attribute):
	if derived_attributes_dict.has(derived_attribute.attribute_name):
		var relative_attributes: Array[Attribute] = derived_attributes_dict[derived_attribute.attribute_name]
		for attribute in relative_attributes:
			attribute.recompute_attribute()
#endregion
