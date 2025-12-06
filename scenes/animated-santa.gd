extends Node2D

@onready var _santa_standing = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_santa_standing.play()
