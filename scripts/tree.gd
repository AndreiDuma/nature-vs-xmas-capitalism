extends Node2D
class_name XmaxTree

enum State {SNOWY, FALLING, DECORATED, DEAD}

@export var state: State = State.SNOWY
@export var selected: bool = false

signal clicked

func fade():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color.TRANSPARENT, 1.0)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		clicked.emit()

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
