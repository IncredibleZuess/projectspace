extends Control


func _on_login_pressed() -> void:
	get_tree().change_scene_to_file("res://login_screen.tscn")
