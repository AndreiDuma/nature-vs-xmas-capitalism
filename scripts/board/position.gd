extends RefCounted
class_name Position

var x
var y

func _init(_x, _y):
	x = _x
	y = _y

func _to_string() -> String:
	return "({0}, {1})".format([x, y])
