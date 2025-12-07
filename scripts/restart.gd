extends Node2D
class_name Restart

signal clicked

func _on_click() -> void:
	clicked.emit()
