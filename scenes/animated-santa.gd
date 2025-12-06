extends Node2D

@onready var _santa = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_santa.play("stand")

func _process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		_santa.play("chop")
	else:
		_santa.play("stand")
