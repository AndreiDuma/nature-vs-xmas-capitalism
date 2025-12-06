extends Node2D

enum {I, V}

const empty_board = [
	[I, I, E, E, E, I, I],
	[I, I, E, E, E, I, I],
	[E, E, E, E, E, E, E],
	[E, E, E, E, E, E, E],
	[E, E, E, E, E, E, E],
	[I, I, E, E, E, I, I],
	[I, I, E, E, E, I, I],
]

enum Piece {EMPTY, SANTA, TREE}
enum {EMPTY = Piece.EMPTY, SANTA = Piece.SANTA, TREE = Piece.TREE}
enum {E = EMPTY, S = SANTA, T = TREE}

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

static func is_allowed_position(p: Position) -> bool:
	if p.x < 0 || p.x > 6 || p.y < 0 || p.y > 6:
		return false
	return empty_board[p.x][p.y] == EMPTY

func get_piece(p: Position) -> Piece:
	assert(is_allowed_position(p))
	return board[p.x][p.y]

func set_piece(p: Position, piece: Piece):
	assert(is_allowed_position(p))
	board[p.x][p.y] = piece

static func neighbor_positions(p: Position, include_diagonals: bool) -> Array:
	assert(is_allowed_position(p))
	var candidates = []
	for d in [
		Position.new(-1, 0),
		Position.new(0, -1),
		Position.new(1, 0),
		Position.new(0, 1),
	]:
		candidates.append(Position.new(p.x + d.x, p.y + d.y))
	if p.x % 2 == p.y % 2 and include_diagonals:
		for dx in [-1, 1]:
			for dy in [-1, 1]:
				candidates.append(Position.new(p.x + dx, p.y + dy))
	return candidates.filter(func (cp): return is_allowed_position(cp))

func available_moves(p: Position, include_diagonals: bool) -> Array:
	assert(is_allowed_position(p) and get_piece(p) in [SANTA, TREE])
	return neighbor_positions(p, include_diagonals).filter(
		func (np): return get_piece(np) == EMPTY
	)

func available_santa_moves(p: Position) -> Array:
	assert(is_allowed_position(p) and get_piece(p) == SANTA)
	return available_moves(p, true)

func available_santa_kills(p: Position) -> Array:
	var kills = []
	for np in neighbor_positions(p, true):
		if get_piece(np) != TREE:
			continue
		var dp = Position.new(np.x - p.x, np.y - p.y)
		var op = Position.new(np.x + dp.x, np.y + dp.y)
		if not is_allowed_position(op):
			continue
		if get_piece(op) == EMPTY:
			kills.append([op.x, op.y])
	return kills

func available_tree_moves(p: Position) -> Array:
	assert(is_allowed_position(p) and get_piece(p) == TREE)
	return available_moves(p, false)

func move(from: Position, to: Position) -> bool:
	assert(is_allowed_position(from))
	assert(is_allowed_position(to))

	if get_piece(from) == SANTA:
		if [to.x, to.y] in available_santa_moves(from):
			board.set_piece(from, EMPTY)
			board.set_piece(to, SANTA)
			# TODO: Consider emitting a signal `santa_moved`.
			return true
		elif [to.x, to.y] in available_santa_kills(from):
			board.set_piece(from, EMPTY)
			board.set_piece(to, SANTA)
			@warning_ignore("integer_division")
			var t = Position.new(((from.x + to.x) / 2), (from.y + to.y) / 2)
			assert(get_piece(t) == TREE)
			board.set_piece(t, EMPTY)
			# TODO: Consider emitting a signal `tree_killed`.
			return true
		else:
			return false

	if get_piece(from) == TREE:
		if [to.x, to.y] in available_tree_moves(from):
			board.set_piece(from, EMPTY)
			board.set_piece(to, TREE)
			# TODO: Consider emitting a signal `tree_moved`.
			return true

	return false

func _ready() -> void:
	pass
