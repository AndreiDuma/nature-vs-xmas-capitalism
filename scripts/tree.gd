extends Node2D
class_name SnowyTree

@onready var _tree = $AnimatedSprite2D

enum State {SNOWY, DECORATED}

@export var state := State.SNOWY

func _process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		state = State.DECORATED
	else:
		state = State.SNOWY

	match state:
		State.SNOWY:
			_tree.play("snowy")
		State.DECORATED:
			_tree.play("decorated")
