class_name AttributeModifier extends Resource

enum OperationType {
	add,
	sub,
	mult,
	divide,
	update
}

var type: OperationType
var value: float

func _init(_type: OperationType = OperationType.add, _value: float = 0.0) -> void:
	type = _type
	value = _value

static func add(_value: float = 0.0) -> AttributeModifier: 
	return AttributeModifier.new(OperationType.add, _value)

static func subtract(_value: float = 0.0) -> AttributeModifier: 
	return AttributeModifier.new(OperationType.sub, _value)

static func multiply(_value: float = 0.0) -> AttributeModifier: 
	return AttributeModifier.new(OperationType.mult, _value)

static func divide(_value: float = 0.0) -> AttributeModifier: 
	return AttributeModifier.new(OperationType.divide, _value)

static func update(_value: float = 0.0) -> AttributeModifier: 
	return AttributeModifier.new(OperationType.update, _value)

func operate(_base_value: float) -> float:
	match type:
		OperationType.add: return _base_value + value
		OperationType.sub: return _base_value - value
		OperationType.mult: return _base_value * value
		OperationType.divide: return 0.0 if is_zero_approx(value) else _base_value / value
		OperationType.update: return value
	return 0.0
