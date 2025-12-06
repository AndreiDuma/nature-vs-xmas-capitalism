extends Node2D

const GRID_UNIT_SIZE = 96
const UNIT_X := Vector2i.DOWN * GRID_UNIT_SIZE
const UNIT_Y := Vector2i.RIGHT * GRID_UNIT_SIZE

var board = Board.new()
var nodes = []

func _ready() -> void:
	var tree = preload("res://scenes/santa.tscn").instantiate()
	add_child(tree)

#func _ready() -> void:
	#for i in range(board.SIZE):
		#nodes.append([])
		#for j in range(board.SIZE):
			#var node = null
			#var p = Position.new(i, j)
			#if not Board.is_allowed_position(p):
				#continue
			#var piece = board.get_piece(p)
			#if piece == Board.SANTA:
				#node = Santa.new()
			#if piece == Board.TREE:
				#node = SnowyTree.new()
			#self.add_child(node)
			#nodes[i].append(node)
