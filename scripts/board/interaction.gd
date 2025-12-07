extends Node2D
class_name Interaction

const BOARD_UNIT_SIZE = 96

var _logic: Logic = Logic.new()

var _trees: Array[Array] = _make_board()
var _santa: Santa = null

func _to_vector(p: Position) -> Vector2:
	return BOARD_UNIT_SIZE * Vector2(p.y - 3, p.x - 3)

func _make_board(value = null) -> Array[Array]:
	var _board: Array[Array] = []
	_board.resize(Logic.SIZE)
	_board.fill([])
	for row in _board:
		row.resize(Logic.SIZE)
		row.fill(value)
	return _board

#
# Squares
#

func _instantiate_squares() -> void:
	for p in Logic.valid_positions():
		var square: Square = preload("res://scenes/square.tscn").instantiate()
		square.name = "Square %s" % p
		square.position = _to_vector(p)
		square.clicked.connect(_on_square_clicked.bind(p))
		$Squares.add_child(square)

func _on_square_clicked(p: Position) -> void:
	print("square clicked: " + str(p))

#
# Trees
#

func _get_tree(p: Position) -> XmaxTree:
	return _trees[p.x][p.y]

func _set_tree(p: Position, c: XmaxTree) -> void:
	_trees[p.x][p.y] = c

func _instantiate_trees() -> void:
	for i in range(Logic.SIZE):
		for j in range(Logic.SIZE):
			var p = Position.new(i, j)
			if not Logic._is_valid_position(p):
				continue
			if _logic._get_piece(p) == Logic.TREE:
				var tree: XmaxTree = preload("res://scenes/tree.tscn").instantiate()
				tree.name = "Tree %s" % p
				_set_tree(p, tree)
				_update_tree_position(p)
				tree.clicked.connect(_on_tree_clicked.bind(p))
				$Trees.add_child(tree)

func _update_tree_position(p: Position) -> void:
	_get_tree(p).position = _to_vector(p)

func _on_tree_clicked(p: Position) -> void:
	print("tree clicked: " + str(p))

#
# Santa
#

func _instantiate_santa() -> void:
	_santa = preload("res://scenes/santa.tscn").instantiate()
	_update_santa_position()
	_santa.clicked.connect(_on_santa_clicked)
	add_child(_santa)

func _update_santa_position() -> void:
	_santa.position = _to_vector(_logic.get_santa_position())

func _on_santa_clicked() -> void:
	print("santa clicked")

#
# Godot overrides
#

func _ready() -> void:
	_instantiate_squares()
	_instantiate_trees()
	_instantiate_santa()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		var from = Position.new(4, 0)
		var to = Position.new(3, 0)
		_logic.tree_move(from, to)

	_update_santa_position()
	for tp in _logic.get_tree_positions():
		_update_tree_position(tp)
