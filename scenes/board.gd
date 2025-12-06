extends Node2D

enum {INVALID, EMPTY, SANTA, TREE}
enum {I = INVALID, E = EMPTY, S = SANTA, T = TREE}

const empty_board = [
	[I, I, E, E, E, I, I],
	[I, I, E, E, E, I, I],
	[E, E, E, E, E, E, E],
	[E, E, E, E, E, E, E],
	[E, E, E, E, E, E, E],
	[I, I, E, E, E, I, I],
	[I, I, E, E, E, I, I],
]

const initial_board = [
	[I, I, E, E, E, I, I],
	[I, I, E, S, E, I, I],
	[E, E, E, E, E, E, E],
	[E, E, E, E, E, E, E],
	[T, T, T, T, T, T, T],
	[I, I, T, T, T, I, I],
	[I, I, T, T, T, I, I],
]

@onready
var board = initial_board;

static func is_allowed_position(x: int, y: int) -> bool:
	if x < 0 || x > 6 || y < 0 || y > 6:
		return false
	return empty_board[x][y] == EMPTY

static func neighbor_positions(x: int, y: int, include_diagonals: bool) -> Array:
	assert(is_allowed_position(x, y))
	var candidates = []
	for dx_dy in [[-1, 0], [0, -1], [1, 0], [0, 1]]:
		var dx = dx_dy[0]
		var dy = dx_dy[1]
		candidates.append([x + dx, y + dy])
	if x % 2 == y % 2 and include_diagonals:
		for dx in [-1, 1]:
			for dy in [-1, 1]:
				candidates.append([x + dx, y + dy])
	return candidates.filter(func (x_y):
		return is_allowed_position(x_y[0], x_y[1])
	)

func available_moves(x: int, y: int, include_diagonals: bool) -> Array:
	assert(is_allowed_position(x, y) and board[x][y] in [SANTA, TREE])
	return neighbor_positions(x, y, include_diagonals).filter(
		func (x_y): return board[x_y[0]][x_y[1]] == EMPTY
	)

func available_santa_moves(x: int, y: int) -> Array:
	assert(is_allowed_position(x, y) and board[x][y] == SANTA)
	return available_moves(x, y, true)

func available_santa_kills(x: int, y: int) -> Array:
	var kills = []
	for pos in neighbor_positions(x, y, true):
		var nx = pos[0];
		var ny = pos[1];
		if board[nx][ny] != TREE:
			continue
		var dx = nx - x;
		var dy = ny - y;
		var ox = nx + dx;
		var oy = ny + dy;
		if not is_allowed_position(ox, oy):
			continue
		if board[ox][oy] == EMPTY:
			kills.append([ox, oy])
	return kills

func available_tree_moves(x: int, y: int) -> Array:
	assert(is_allowed_position(x, y) and board[x][y] == TREE)
	return available_moves(x, y, false)

func move(x: int, y: int, to_x: int, to_y: int) -> bool:
	assert(is_allowed_position(x, y))
	assert(is_allowed_position(to_x, to_y))

	if board[x][y] == SANTA:
		if [to_x, to_y] in available_santa_moves(x, y):
			board[x][y] = EMPTY;
			board[to_x][to_y] = SANTA;
			# TODO: Consider emitting a signal `santa_moved`.
			return true
		elif [to_x, to_y] in available_santa_kills(x, y):
			board[x][y] = EMPTY;
			board[to_x][to_y] = SANTA;
			@warning_ignore("integer_division")
			var tx = (x + to_x) / 2
			@warning_ignore("integer_division")
			var ty = (y + to_y) / 2
			assert(board[tx][ty] == TREE)
			board[tx][ty] = EMPTY
			# TODO: Consider emitting a signal `tree_killed`.
			return true
		else:
			return false

	if board[x][y] == TREE:
		if [to_x, to_y] in available_tree_moves(x, y):
			board[x][y] = EMPTY;
			board[to_x][to_y] = TREE;
			# TODO: Consider emitting a signal `tree_moved`.
			return true

	return false

func _ready() -> void:
	#print(neighbor_positions(2, 2))
	#print(neighbor_positions(2, 2, false))
	#print(available_moves(1, 3, true))
	#print(available_moves(6, 4, true))
	#print(available_tree_moves(2, 4))
	print(available_santa_moves(1, 3))
	print(available_santa_kills(1, 3))
	print(move(1, 3, 3, 4))
