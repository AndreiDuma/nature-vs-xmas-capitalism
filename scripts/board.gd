extends Node2D

const BOARD_UNIT_SIZE = 96

var board = Board.new()
var santa: Santa = null
var trees: Array[Array] = []

func from_logical(p: Position) -> Vector2:
	return BOARD_UNIT_SIZE * Vector2(p.y - 3, p.x - 3)

func get_tree_node(p: Position) -> XmaxTree:
	assert(board.get_piece(p) == Board.TREE)
	return trees[p.x][p.y]

func set_tree_node(p, c: XmaxTree) -> void:
	assert(board.get_piece(p) == Board.TREE)
	trees[p.x][p.y] = c

func update_santa_position() -> void:
	santa.position = from_logical(board.get_santa_position())

func update_tree_position(p: Position) -> void:
	assert(board.get_piece(p) == Board.TREE)
	get_tree_node(p).position = from_logical(p)

func _ready() -> void:
	# Instantiate trees
	trees.resize(Board.SIZE)
	trees.fill([])
	for ts in trees:
		ts.resize(Board.SIZE)
		ts.fill(null)

	for i in Board.SIZE:
		for j in Board.SIZE:
			var p = Position.new(i, j)
			if not Board.is_allowed_position(p):
				continue
			if board.get_piece(p) == Board.TREE:
				var tree: XmaxTree = preload("res://scenes/tree.tscn").instantiate()
				set_tree_node(p, tree)
				add_child(tree)
				update_tree_position(p)

	# Instantiate Santa
	santa = preload("res://scenes/santa.tscn").instantiate()
	update_santa_position()
	add_child(santa)

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		var from = Position.new(4, 0)
		var to = Position.new(3, 0)
		board.move(from, to)

	update_santa_position()
	for tp in board.get_tree_positions():
		update_tree_position(tp)
