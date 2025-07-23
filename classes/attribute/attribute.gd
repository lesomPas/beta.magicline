class_name Attribute extends Resource

signal attribute_changed(attribute: Attribute)
signal buff_added(attribute: Attribute, buff: AttributeBuff) 
signal buff_removed(attribute: Attribute, buff: AttributeBuff)

@export var attribute_name: String
@export var base_value: float = 0.0: set = setter_base_value
@export var lower_limit: float
@export var upper_limit: float

var computed_value: float = 0.0: set = setter_computed_value
var buffs: Array[AttributeBuff] = []
var is_initialized_base_value = false

var attribute_collection: AttributeCollection
 
#region setter
@warning_ignore("shadowed_variable")
func setter_base_value(value: float) -> void:
	if not is_initialized_base_value:
		is_initialized_base_value = true
		base_value = value
		computed_value = value

@warning_ignore("shadowed_variable")
func setter_computed_value(value: float) -> void:
	computed_value = value
	attribute_changed.emit(self)
#endregion

#region buff functions
func apply_buff(buff: AttributeBuff): 
	if not is_instance_valid(buff):
		return

	var should_append_buff: bool = true
	var pending_add_buff: AttributeBuff = buff

	if not buff.buff_name.is_empty():
		var existing_buff: AttributeBuff = find_buff(buff.buff_name)
		if is_instance_valid(existing_buff):
			match existing_buff.merging:
				AttributeBuff.DurationMerging.restart: existing_buff.restart_duration()
				AttributeBuff.DurationMerging.addition: existing_buff.extend_duration(existing_buff.duration)
			pending_add_buff = existing_buff
			should_append_buff = false

	if should_append_buff:
		buffs.append(pending_add_buff)
		pending_add_buff = buff

	buff_added.emit(self, buff)
	attribute_changed.emit(self)

func remove_buff(buff: AttributeBuff): 
	buffs.erase(buff)
	buff_removed.emit(self, buff)
	attribute_changed.emit(self)

func find_buff(buff_name: String) -> AttributeBuff:
	for _buff in buffs:
		if _buff.buff_name == buff_name:
			return _buff
	return null

func get_buff_size() -> int:
	return buffs.size()
#endregion

func notify_attribute_changed():
	attribute_changed.emit(self)

func process(delta: float) -> void:
	var pending_remove_buff: Array[AttributeBuff] = []
	for buff in buffs:
		if buff.has_duration():
			buff.remaining_time = max(buff.remaining_time - delta, 0.0)
			if is_zero_approx(buff.remaining_time):
				pending_remove_buff.append(buff)
	for buff in pending_remove_buff:
		remove_buff(buff)

	process_function(delta)

func get_base_value() -> float:
	return base_value

func value() -> float:
	var attribute_value = computed_value
	for _buff in buffs:
		attribute_value = _buff.operate(attribute_value)
	attribute_value = post_attribute_value_changed(attribute_value)
	return attribute_value

func get_value(name: String) -> float:
	return attribute_collection.find_attribute(name).value()

func get_attribute(name: String) -> Attribute:
	return attribute_collection.find_attribute(name)

func recompute_return() -> Attribute:
	computed_value = _compute_value(computed_value)
	return self

func recompute_attribute() -> void:
	computed_value = _compute_value(computed_value)


#region subclass override functions
func custom_compute(_operated_value: float, _compute_params: Array[Attribute]) -> float:
	return clampf(_operated_value, lower_limit, upper_limit)

func derived_from() -> Array[String]:
	return []

func post_attribute_value_changed(_value: float) -> float:
	return clamp(_value, lower_limit, upper_limit)

func process_function(delta: float) -> void:
	return 
#endregion

#region operator function
func set_value(_value: float) -> void:
	var operated_value: float = AttributeModifier.update(_value).operate(computed_value) 
	computed_value = _compute_value(operated_value)

func add(_value: float) -> void:
	var operated_value: float = AttributeModifier.add(_value).operate(computed_value) 
	computed_value = _compute_value(operated_value)

func subtract(_value: float) -> void:
	var operated_value: float = AttributeModifier.subtract(_value).operate(computed_value) 
	computed_value = _compute_value(operated_value)

func multiply(_value: float) -> void:
	var operated_value: float = AttributeModifier.multiply(_value).operate(computed_value) 
	computed_value = _compute_value(operated_value)

func divied(_value: float) -> void:
	var operated_value: float = AttributeModifier.divide(_value).operate(computed_value) 
	computed_value = _compute_value(operated_value)
#endregion

#region internal
func _compute_value(_operated_value: float) -> float:
	# 计算公式运算结果
	var derived_attribute: Array[Attribute] = []
	var derived_attribute_names: Array[String] = derived_from()
	#  从属性集中拿到属性对象
	for _name in derived_attribute_names:
		var _attribute: Attribute = attribute_collection.find_attribute(_name)
		derived_attribute.append(_attribute)
	return custom_compute(_operated_value, derived_attribute)
#endregion
