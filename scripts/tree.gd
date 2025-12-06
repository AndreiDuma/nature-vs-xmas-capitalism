extends Node2D
class_name SnowyTree

enum State {SNOWY, DECORATED}

@export var state: State = State.SNOWY
@export var selected: bool = false

func _process(_delta):
	match state:
		State.SNOWY:
			$Sprite.play("snowy")
		State.DECORATED:
			$Sprite.play("decorated")
	
	$Halo.visible = selected
