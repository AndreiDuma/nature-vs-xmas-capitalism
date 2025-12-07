extends Node2D
class_name Restart

signal clicked

func _on_mouse_entered() -> void:
	create_tween().tween_property($Sprite, "rotation", 0.5, 0.1).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited() -> void:
	create_tween().tween_property($Sprite, "rotation", 0.0, 0.25).set_trans(Tween.TRANS_SINE)

func _on_click() -> void:
	create_tween().tween_property($Sprite, "rotation", -2*PI, 0.25).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.2).timeout
	clicked.emit()
