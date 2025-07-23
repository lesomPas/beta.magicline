class_name AttributeBuff extends Resource

@export var buff_name: String
@export var operation: AttributeModifier.OperationType = AttributeModifier.OperationType.add
@export var value: float = 0.0
@export var policy: DurationPolicy = DurationPolicy.infinite
@export var duration: float = 0.0
@export var merging: DurationMerging = DurationMerging.restart

enum DurationPolicy {
	infinite,
	has_duration 
}

enum DurationMerging {
	restart,
	addition,
	no_effect
}

var attribute_modifier: AttributeModifier
var remaining_time: float = 0.0

func _init(_operation := AttributeModifier.OperationType.add, _value: float = 0.0, name: String = "") -> void:
	buff_name = name
	attribute_modifier = AttributeModifier.new(_operation, _value)

#region operator functions
static func add(_value: float = 0.0) -> AttributeBuff:
	return AttributeBuff.new(AttributeModifier.OperationType.add, _value)

static func subtract(_value: float = 0.0) -> AttributeBuff:
	return AttributeBuff.new(AttributeModifier.OperationType.sub, _value)

static func multiply(_value: float = 0.0) -> AttributeBuff:
	return AttributeBuff.new(AttributeModifier.OperationType.mult, _value)

static func divide(_value: float = 0.0) -> AttributeBuff:
	return AttributeBuff.new(AttributeModifier.OperationType.divide, _value)

static func update(_value: float = 0.0) -> AttributeBuff:
	return AttributeBuff.new(AttributeModifier.OperationType.update, _value)
#endregion

func get_value() -> float:
	return attribute_modifier.value

func operate(_base_value: float) -> float:
	return attribute_modifier.operate(_base_value)

func has_duration() -> bool:
	return policy == DurationPolicy.has_duration

func set_duration(time: float) -> AttributeBuff:
	duration = time
	remaining_time = duration
	policy = DurationPolicy.has_duration if duration > 0 else DurationPolicy.infinite
	return self

func restart_duration():
	remaining_time = duration

func extend_duration(_time: float):
	remaining_time += _time
