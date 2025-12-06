extends Node2D
class_name Santa

enum State {STANDING, CHOPPING}

@export var state: State = State.STANDING
@export var selected: bool = false

func _process(_delta):
	match state:
		State.STANDING:
			$Sprite.play("stand")
		State.CHOPPING:
			$Sprite.play("chop")
			
	$Halo.visible = selected
