extends Node2D
class_name SnowyTree

enum State {SNOWY, FALLING, DECORATED}

@export var state: State = State.SNOWY
@export var selected: bool = false

func _process(_delta):
	match state:
		State.SNOWY:
			$Sprite.play("snowy")
		State.FALLING:
			$Sprite.play("falling")
		State.DECORATED:
			$Sprite.play("decorated")
	
	$Halo.visible = selected
