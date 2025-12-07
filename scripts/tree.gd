extends Node2D
class_name XmaxTree

enum State {SNOWY, FALLING, DEAD, DECORATED}

@export var state: State = State.SNOWY
@export var selected: bool = false

signal clicked

func move(to: Vector2) -> void:
	create_tween().tween_property(self, "position", to, 0.25).set_trans(Tween.TRANS_SINE)

func die():
	await get_tree().create_timer(0.5).timeout
	state = State.FALLING

func _update_animation():
	match state:
		State.SNOWY:
			$Sprite.play("snowy")
		State.FALLING:
			$Sprite.play("falling", 0.75)
			if $Sprite.frame == 3:
				state = State.DEAD
		State.DEAD:
			var tween = create_tween()
			tween.tween_property($Sprite, "modulate", Color.TRANSPARENT, 1.0)
			tween.tween_callback(queue_free)
		State.DECORATED:
			$Sprite.play("decorated")

func _update_halo():
	$Halo.visible = selected

func _on_click() -> void:
	clicked.emit()

func _process(_delta):
	_update_animation()
	_update_halo()
