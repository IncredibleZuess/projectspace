extends Camera2D

@export var speed = 200

func _input(event):
	var camera_speed = 150 # Adjust for desired speed
	var zoom_speed = Vector2(0.1,0.1) # Adjust for desired zoom speed
	var zoom_min = Vector2(0.01,0.01) # Set the minimum zoom level
	var zoom_max = Vector2(200.0,200.0) # Set the maximum zoom level
	var zoom_current = zoom # Get the current zoom value
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_current += zoom_speed
			if zoom_current > zoom_max:
				zoom_current = zoom_max
			zoom = Vector2(zoom_current.x, zoom_current.y)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_current -= zoom_speed
			if zoom_current < zoom_min:
				zoom_current = zoom_min
			zoom = Vector2(zoom_current.x, zoom_current.y)

func _process(delta):
	var camera_speed = 150 # Adjust for desired speed
	var direction = Vector2.ZERO # Initialize direction vector
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	# Calculate movement vector based on direction
	var move_vector = direction * camera_speed * delta

	# Update camera position
	position += move_vector
