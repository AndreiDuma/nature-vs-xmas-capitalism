extends Node2D

enum Allowed {Y, N}
enum Entity {S, T}

const allowed_positions = [
	[0, 0, 1, 0, 1, 0, 0],
	[0, 0, 0, 1, 0, 0, 0],
	[1, 0, 1, 0, 1, 0, 1],
	[0, 1, 0, 1, 0, 1, 0],
	[1, 0, 1, 0, 1, 0, 1],
	[0, 0, 0, 1, 0, 0, 0],
	[0, 0, 1, 0, 1, 0, 0],
]



static func is_allowed_position(x: int, y: int) -> bool:
	if x < 0 || x > 6 || y < 0 || y > 6:
		return false
	return allowed_positions[x][y] == 1
	
static func neighbor_positions(x: int, y: int, include_diagonals=true) -> Array:
	assert(is_allowed_position(x, y))
	var candidates = []
	if x % 2 == 0 and y % 2 == 0:
		for dx_dy in [[-2, 0], [0, -2], [2, 0], [0, 2]]:
			var dx = dx_dy[0]
			var dy = dx_dy[1]
			candidates.append([x + dx, y + dy])
	if include_diagonals:
		for dx in [-1, 1]:
			for dy in [-1, 1]:
				candidates.append([x + dx, y + dy])
	return candidates.filter(func (x_y):
		return is_allowed_position(x_y[0], x_y[1])
	)

func _ready() -> void:
	print(neighbor_positions(2, 2))
	print(neighbor_positions(2, 2, false))
