extends RefCounted
class_name Logic

enum {INVALID, VALID}
enum {I = INVALID, V = VALID}

enum Piece {EMPTY, SANTA, TREE}
enum {EMPTY = Piece.EMPTY, SANTA = Piece.SANTA, TREE = Piece.TREE}
enum {E = EMPTY, S = SANTA, T = TREE}

enum GameState {TURN_SANTA, TURN_TREES, TURN_ANY, WIN_SANTA, WIN_TREES}

const BOARD_SIZE = 7

const _valid_board_positions = [
	[I, I, V, V, V, I, I],
	[I, I, V, V, V, I, I],
	[V, V, V, V, V, V, V],
	[V, V, V, V, V, V, V],
	[V, V, V, V, V, V, V],
	[I, I, V, V, V, I, I],
	[I, I, V, V, V, I, I],
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

#const _initial_board_almost_santa_win = [
	#[I, I, E, E, E, I, I],
	#[I, I, E, E, E, I, I],
	#[E, E, E, E, E, E, E],
	#[E, E, E, E, E, E, E],
	#[E, E, E, E, E, E, E],
	#[I, I, E, T, E, I, I],
	#[I, I, E, S, E, I, I],
#]

#var _initial_board_almost_trees_win = [
	#[I, I, E, E, E, I, I],
	#[I, I, E, E, E, I, I],
	#[E, E, E, E, E, E, E],
	#[E, E, E, E, E, E, E],
	#[T, T, T, T, T, T, T],
	#[I, I, T, T, T, I, I],
	#[I, I, E, S, T, I, I],
#]

var _board = initial_board.duplicate_deep()

const initial_game_state = GameState.TURN_ANY
var game_state := initial_game_state

static func _is_valid_position(p: Position) -> bool:
	if p.x < 0 || p.x > 6 || p.y < 0 || p.y > 6:
		return false
	return _valid_board_positions[p.x][p.y] == VALID

static func _neighbor_positions(p: Position, include_diagonals: bool) -> Array[Position]:
	assert(_is_valid_position(p))
	var candidates: Array[Position] = []
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
	return candidates.filter(_is_valid_position)

func _get_piece(p: Position) -> Piece:
	assert(_is_valid_position(p))
	return _board[p.x][p.y]

func _set_piece(p: Position, piece: Piece):
	assert(_is_valid_position(p))
	_board[p.x][p.y] = piece

func _available_moves(p: Position, include_diagonals: bool) -> Array[Position]:
	assert(_is_valid_position(p) and _get_piece(p) in [SANTA, TREE])
	return _neighbor_positions(p, include_diagonals).filter(
		func (np): return _get_piece(np) == EMPTY
	)

#
# Utilities
#

static func valid_positions() -> Array[Position]:
	var ps: Array[Position] = []
	for i in range(Logic.BOARD_SIZE):
		for j in range(Logic.BOARD_SIZE):
			var p = Position.new(i, j)
			if Logic._is_valid_position(p):
				ps.append(p)
	return ps

#
# Santa
#

func get_santa_position() -> Position:
	var santa_position = null
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var p = Position.new(x, y)
			if not _is_valid_position(p):
				continue
			if _get_piece(p) == SANTA:
				assert(santa_position == null)
				santa_position = p
	assert(santa_position != null)
	return santa_position

func available_santa_moves() -> Array[Position]:
	return _available_moves(get_santa_position(), true)

func available_santa_kills() -> Array[Position]:
	var sp = get_santa_position()
	var kills: Array[Position] = []
	for np in _neighbor_positions(sp, true):
		if _get_piece(np) != TREE:
			continue
		var dp = Position.new(np.x - sp.x, np.y - sp.y)
		var op = Position.new(np.x + dp.x, np.y + dp.y)
		if not _is_valid_position(op):
			continue
		if _get_piece(op) == EMPTY:
			kills.append(op)
	return kills

func santa_move(to: Position) -> bool:
	assert(_is_valid_position(to))
	var from = get_santa_position()

	if not can_santa_play():
		return false

	if to.in_array(available_santa_moves()):
		# Successful Santa move.
		_set_piece(from, Piece.EMPTY)
		_set_piece(to, Piece.SANTA)
		game_state = GameState.TURN_TREES
		return true

	# Impossible move
	return false

func santa_kill_and_move(to: Position) -> Position:
	assert(_is_valid_position(to))
	var from = get_santa_position()

	if not can_santa_play():
		return null

	if to.in_array(available_santa_kills()):
		# Successful kill & move.
		_set_piece(from, Piece.EMPTY)
		_set_piece(to, Piece.SANTA)
		@warning_ignore("integer_division")
		var victim = Position.new(((from.x + to.x) / 2), (from.y + to.y) / 2)
		assert(_get_piece(victim) == TREE)
		_set_piece(victim, Piece.EMPTY)
		if available_santa_kills() == []:
			game_state = GameState.TURN_TREES
		elif get_tree_positions() == []:
			game_state = GameState.WIN_SANTA
		else:
			game_state = GameState.TURN_ANY
		return victim

	# Impossible kill & move.
	return null

func can_santa_play() -> bool:
	return game_state in [GameState.TURN_SANTA, GameState.TURN_ANY]

func did_santa_win() -> bool:
	return get_tree_positions() == []

#
# Trees
#

func get_tree_positions() -> Array[Position]:
	var ps: Array[Position] = []
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			var p = Position.new(x, y)
			if not _is_valid_position(p):
				continue
			if _get_piece(p) == TREE:
				ps.append(p)
	return ps

func available_tree_moves(p: Position) -> Array[Position]:
	assert(_is_valid_position(p) and _get_piece(p) == TREE)
	return _available_moves(p, false)

func tree_move(from: Position, to: Position) -> bool:
	assert(_is_valid_position(from))
	assert(_is_valid_position(to))
	assert(_get_piece(from) == TREE)

	if not can_trees_play():
		return false

	if to.in_array(available_tree_moves(from)):
		# Successful move.
		_set_piece(from, Piece.EMPTY)
		_set_piece(to, Piece.TREE)
		if did_trees_win():
			game_state = GameState.WIN_TREES
		else:
			game_state = GameState.TURN_SANTA
		return true

	# Impossible move.
	return false

func can_trees_play() -> bool:
	return game_state in [GameState.TURN_TREES, GameState.TURN_ANY]

func did_trees_win() -> bool:
	return available_santa_moves() == [] and available_santa_kills() == []

#
# Game state
#

func is_game_over() -> bool:
	return game_state in [GameState.WIN_SANTA, GameState.WIN_TREES]

func restart_game():
	_board = initial_board.duplicate_deep()
	game_state = initial_game_state
