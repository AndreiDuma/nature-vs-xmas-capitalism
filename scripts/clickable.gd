extends Area2D

signal clicked

var mouse_inside := false

func _on_mouse_entered() -> void:
	mouse_inside = true

func _on_mouse_exited() -> void:
	mouse_inside = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside:
		clicked.emit()
		get_viewport().set_input_as_handled()
