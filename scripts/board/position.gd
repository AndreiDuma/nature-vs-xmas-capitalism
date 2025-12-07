extends RefCounted
class_name Position

var x
var y

func _init(_x, _y):
	x = _x
	y = _y

func _to_string() -> String:
	return "({0}, {1})".format([x, y])

func equals(other: Position) -> bool:
	return x == other.x and y == other.y

func in_array(array: Array[Position]) -> bool:
	return array.find_custom(func (p): return p.equals(self)) != -1
