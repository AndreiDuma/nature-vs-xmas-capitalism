extends Node2D

func _on_restart_clicked() -> void:
	print("restart clicked")

func _on_background_clicked() -> void:
	print("background clicked")
	$Board.clear_selected()
