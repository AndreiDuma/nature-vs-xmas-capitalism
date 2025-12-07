extends Node2D
class_name Santa

enum State {STANDING, CHOPPING}

@export var state: State = State.STANDING
@export var selected: bool = false

signal clicked

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		clicked.emit()

func _process(_delta):
	match state:
		State.STANDING:
			$Sprite.play("stand")
		State.CHOPPING:
			$Sprite.play("chop")
			
	$Halo.visible = selected
