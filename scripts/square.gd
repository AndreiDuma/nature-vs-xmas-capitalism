extends Area2D
class_name Square

signal clicked

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		clicked.emit()
