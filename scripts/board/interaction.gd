extends Node2D
class_name Interaction

const BOARD_UNIT_SIZE = 96

var _logic: Logic = Logic.new()

var _trees: Array[Array] = _make_board()
var _santa: Santa = null

var _selected = null
var _santa_selected := false
var _tree_selected: Position = null

func _make_board(value = null) -> Array[Array]:
	var _board: Array[Array] = []
	_board.resize(Logic.SIZE)
	for i in range(Logic.SIZE):
		_board[i] = []
		_board[i].resize(Logic.SIZE)
		_board[i].fill(value)
	return _board

func _to_vector(p: Position) -> Vector2:
	return BOARD_UNIT_SIZE * Vector2(p.y - 3, p.x - 3)

func _set_selected(node) -> void:
	assert(node != null)
	node.selected = true
	if _selected != null and node != _selected:
		_selected.selected = false
	_selected = node

func clear_selected() -> void:
	if _selected != null:
		_selected.selected = false
	_selected = null
	_tree_selected = null
	_santa_selected = false

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
	clear_selected()

#
# Trees
#

func _get_tree(p: Position) -> XmaxTree:
	return _trees[p.x][p.y]

func _set_tree(p: Position, c: XmaxTree) -> void:
	_trees[p.x][p.y] = c

func _instantiate_trees() -> void:
	for p in _logic.get_tree_positions():
		var tree: XmaxTree = preload("res://scenes/tree.tscn").instantiate()
		tree.name = "Tree %s" % p
		tree.position = _to_vector(p)
		tree.clicked.connect(_on_tree_clicked.bind(p))
		$Trees.add_child(tree)
		_set_tree(p, tree)

func _select_tree(p: Position) -> void:
	_set_selected(_get_tree(p))
	_tree_selected = p

func _on_tree_clicked(p: Position) -> void:
	print("tree clicked: " + str(p))
	clear_selected()
	if _logic.can_trees_play():
		_select_tree(p)

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

func _select_santa() -> void:
	_set_selected(_santa)
	_santa_selected = true

func _on_santa_clicked() -> void:
	print("santa clicked")
	clear_selected()
	if _logic.can_santa_play():
		_select_santa()

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
