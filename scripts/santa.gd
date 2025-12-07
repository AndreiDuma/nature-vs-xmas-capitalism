extends Node2D
class_name Santa

enum State {STANDING, CHOPPING}

@export var state: State = State.STANDING
@export var selected: bool = false

signal clicked

func move(to: Vector2) -> void:
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.tween_property(self, "position", to, 0.5) #.set_trans(Tween.TRANS_BOUNCE)

func saw(to: Vector2) -> void:
	move(to)
	$Sprite.play("saw")
	$Chainsaw.play()

func _on_click() -> void:
	clicked.emit()

func _on_chainsaw_finished():
	$Sprite.play("stand")

func _update_halo() -> void:
	$Halo.visible = selected

func _process(_delta):
	if Input.is_key_pressed(KEY_C):
		saw(position)

	_update_halo()
