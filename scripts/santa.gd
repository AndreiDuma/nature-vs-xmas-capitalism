extends Node2D
class_name Santa

enum State {STANDING, CHOPPING}

@export var state: State = State.STANDING
@export var selected: bool = false

signal clicked

func move(to: Vector2) -> void:
	create_tween().tween_property(self, "position", to, 0.25).set_trans(Tween.TRANS_SINE)

func saw(to: Vector2) -> void:
	$Sprite.play("saw")
	$Chainsaw.play()
	await get_tree().create_timer(0.2).timeout
	create_tween().tween_property(self, "position", to, 0.75).set_trans(Tween.TRANS_QUAD)

func _on_click() -> void:
	clicked.emit()

func _on_chainsaw_finished():
	$Sprite.play("stand")

func _update_halo() -> void:
	$Halo.visible = selected

func _process(_delta):
	_update_halo()
