extends Node2D
class_name Square

signal clicked

func _on_click() -> void:
	clicked.emit()
