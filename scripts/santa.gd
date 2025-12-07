extends Node2D
class_name Santa

enum State {STANDING, CHOPPING}

@export var state: State = State.STANDING
@export var selected: bool = false

signal clicked

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		clicked.emit()

func _on_chainsaw_finished():
	$Sprite.play("stand")

func play(animation: String) -> void:
	$Sprite.play(animation)
	if animation == "chop":
		$Chainsaw.play()

func _process(_delta):
	if Input.is_key_pressed(KEY_C):
		play("chop")

	$Halo.visible = selected
