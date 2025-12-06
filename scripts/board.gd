extends Node2D

const BOARD_UNIT_SIZE = 96

var board = Board.new()
var santa: Santa = null
var trees = []

func to_transform(p: Position) -> Vector2:
	return BOARD_UNIT_SIZE * Vector2(p.y - 3, p.x - 3)

func _ready() -> void:
	santa = preload("res://scenes/santa.tscn").instantiate()
	santa.hide()
	add_child(santa)
	santa.translate(to_transform(board.get_santa_position()))
	santa.show()

#func _process(_delta: float) -> void:
	##santa.transform = to_transform(board.get_santa_position())
	#santa.translate(to_transform(board.get_santa_position()))
