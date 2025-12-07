extends Node2D

const BOARD_UNIT_SIZE = 96

var _logic: Logic = Logic.new()

var _santa: Santa = null
var _trees: Array[Array] = []

func _to_vector(p: Position) -> Vector2:
	return BOARD_UNIT_SIZE * Vector2(p.y - 3, p.x - 3)

### Santa ###

func _instantiate_santa() -> void:
	_santa = preload("res://scenes/santa.tscn").instantiate()
	_update_santa_position()
	_santa.clicked.connect(_on_santa_clicked)
	add_child(_santa)

func _update_santa_position() -> void:
	_santa.position = _to_vector(_logic.get_santa_position())

func _on_santa_clicked() -> void:
	print("santa clicked")

### Trees ###

func _get_tree(p: Position) -> XmaxTree:
	return _trees[p.x][p.y]

func _set_tree(p: Position, c: XmaxTree) -> void:
	_trees[p.x][p.y] = c

func _instantiate_trees() -> void:
	_trees.resize(Logic.SIZE)
	_trees.fill([])
	for ts in _trees:
		ts.resize(Logic.SIZE)
		ts.fill(null)

	for i in range(Logic.SIZE):
		for j in range(Logic.SIZE):
			var p = Position.new(i, j)
			if not Logic._is_valid_position(p):
				continue
			if _logic._get_piece(p) == Logic.TREE:
				var tree: XmaxTree = preload("res://scenes/tree.tscn").instantiate()
				_set_tree(p, tree)
				_update_tree_position(p)
				tree.clicked.connect(_on_tree_clicked)
				add_child(tree)

func _update_tree_position(p: Position) -> void:
	_get_tree(p).position = _to_vector(p)

func _on_tree_clicked(tree: XmaxTree) -> void:
	print("tree clicked: " + str(tree))

#
# Godot overrides
#

func _ready() -> void:
	_instantiate_santa()
	_instantiate_trees()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		var from = Position.new(4, 0)
		var to = Position.new(3, 0)
		_logic.tree_move(from, to)

	_update_santa_position()
	for tp in _logic.get_tree_positions():
		_update_tree_position(tp)
