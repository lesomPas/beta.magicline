class_name Block extends Node

@export var x: int = 0
@export var y: int = 0

const width: float = 1080.0

#region initial functions
func _init(_x: int = 0, _y: int = 0) -> void:
	x = _x
	y = _y

static func blockz() -> Block:
	return Block.new()

static func blockd(from: Block) -> Block:
	return Block.new(from.x, from.y)

static func block(_x: int, _y: int) -> Block:
	return Block.new(_x, _y)

static func blockv(godot_position: Vector2) -> Block:
	return Block.block(floor(godot_position.x / 64.0), floor((width - godot_position.y) / 64.0))
#endregion

#region math functions
func abs(_block: Block) -> Block:
	return block(absi(_block.x), absi(_block.y))

func aspect(_block: Block) -> float:
	return float(_block.x) / float(_block.y)

func distance_squared_to(_block: Block) -> int:
	return (self.x - _block.x) ** 2 + (self.y - _block.y) ** 2

func distance_to(_block: Block) -> float:
	return sqrt(distance_squared_to(_block))

func length() -> float:
	return sqrt(length_spuared())

func length_spuared() -> float:
	return self.x ** 2 + self.y ** 2

func sign() -> Block:
	return block(sign(self.x), sign(self.y))
#endregion

func _in_range(value: float, _min: float, _max: float) -> bool:
	return (value >= _min) and (value <= _max)

func convert_to_position() -> Vector2:
	return Vector2(x * 64.0, width - y * 64.0)

func contain(position: Vector2) -> bool:
	var block_position: Vector2 = convert_to_position()
	return _in_range(position.x, block_position.x, block_position.x + 64.0) and \
		   _in_range(position.y, block_position.y - 64.0, block_position.y)
