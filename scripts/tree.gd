extends Node2D
class_name XmaxTree

enum State {SNOWY, FALLING, DECORATED, DEAD}

@export var state: State = State.SNOWY
@export var selected: bool = false

func _process(_delta):
	match state:
		State.SNOWY:
			$Sprite.play("snowy")
		State.FALLING:
			$Sprite.play("falling", 0.75)
			if $Sprite.frame == 3:
				state = State.DEAD
		State.DECORATED:
			$Sprite.play("decorated")
		State.DEAD:
			fade()
	
	$Halo.visible = selected

func fade():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color.TRANSPARENT, 1.0)
