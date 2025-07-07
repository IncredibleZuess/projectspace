extends Node2D

func _on_button_pressed() -> void:
	
	print($Control/Label.text)
	Data.systemSelected = $Control/Label.text
	get_tree().change_scene_to_file("res://system_map.tscn")
