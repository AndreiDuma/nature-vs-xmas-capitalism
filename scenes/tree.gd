extends Node2D

@onready var _tree = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_tree.play("snowy-stand")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		_tree.play("decorated-stand")
	else:
		_tree.play("snowy-stand")
