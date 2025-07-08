extends Node2D

var system_window_scene = preload("res://system_window.tscn")

func _on_button_pressed() -> void:
	print($Control/Label.text)
	Data.systemSelected = $Control/Label.text
	
	# Create a new system window instead of changing scenes
	var system_window = system_window_scene.instantiate()
	system_window.title = "System: " + Data.systemSelected
	
	# Position windows with slight offset to avoid overlap
	var existing_windows = get_tree().get_first_node_in_group("galaxy_map")
	if existing_windows and existing_windows.has_method("get_system_window_count"):
		var offset = existing_windows.get_system_window_count() * 30
		system_window.position = Vector2i(100 + offset, 100 + offset)
	else:
		system_window.position = Vector2i(100, 100)
	
	get_tree().root.add_child(system_window)
	
	# Register the window with the map for cleanup
	var map = get_tree().get_first_node_in_group("galaxy_map")
	if map == null:
		# Fallback: find the map node by searching the scene tree
		map = get_tree().current_scene
		if map.has_method("add_system_window"):
			map.add_system_window(system_window)
	else:
		map.add_system_window(system_window)
	
	# Show the window
	system_window.show()
