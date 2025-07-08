extends Node2D

@export var Sun : Color
@export var verticalDivider: int
@export var horizontalDivider: int
@export var lineColor : Color
var coordinates = []
var cachedCoords = []
var points : PackedVector2Array
var shipLocation
var prevNode : Node2D
var page = 1
var systems = 20
var node = preload("res://galnode.tscn")
var galFile = FileAccess.open("user://planets.json", FileAccess.WRITE)
var shipWindow = preload("res://ShipWindow.tscn")
var ship

func _ready() -> void:
	$MapRequest.request_completed.connect(_handleMapRequest)
	
	# Debug: print(Data.playerKey) # Uncomment for debugging only, do not use in production
	getMap()

func _draw() -> void:
	print(coordinates.size())
	if coordinates.size() == 0:
		pass
	else:
		for x in coordinates:
			#draw_circle(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider), 20, Color("Red"))
			#var label = Label.new()
			var galnode = node.instantiate()
			print(x["type"])
			galnode.set_global_position(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider))
			if x["symbol"] in Data.ships:
				$Camera2D.set_position(Vector2(x["x"],x["y"]))
			galnode.get_node("Control/Label").text = x["symbol"]
			galnode.name = x["symbol"]
			
			#label.set_position(Vector2(x["x"]/verticalDivider -30,x["y"]/horizontalDivider +20))
			#label.text = x["symbol"]
			#add_child(label)a
			add_child(galnode)
			galnode.get_node("Control/Label/Control/Sprite2D").set_animation(x["type"])
			coordinates.pop_front()
			#TODO Implement A* to connect these lines
			#draw_multiline(points, lineColor) #This is to connect points together but it is left out for now because it connects to invisible points
			systems = systems + 1
	pass



func getMap():
	$MapRequest.set_use_threads(true)
	$MapRequest.request(
		"https://api.spacetraders.io/v2/systems?limit=20&page="+str(page),
		["Authorization: Bearer " + Data.playerKey],
		)
	page = page+1
	
	pass


func _on_draw() -> void:
	
	pass # Replace with function body.


func _handleMapRequest(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	#print("\n\n\n\n STARMAP")
	#print(res["data"])
	for x in res["data"]:
		#print(x["symbol"])
		#if x["symbol"] in Data.ships:
			#coordinates.append({"symbol": x["symbol"] + " Ship", "x": x["x"], "y": x["y"]})
		coordinates.append({"type": x["type"],"symbol": x["symbol"], "x": x["x"], "y": x["y"]})
		if FileAccess.file_exists("user://planets.json"):
			cachedCoords.append({"symbol": x["symbol"], "x": x["x"], "y": x["y"]})
		
		points.append(Vector2(x['x'],x["y"]))
		
	$Control/Label.hide()
	
	
	queue_redraw()
	if systems < 7033:
		getMap()
	else:
		galFile.store_line("["+ JSON.stringify(cachedCoords) +"]")
	print("*" + str(systems))
	
	pass # Replace with function body.


func _on_window_close_requested() -> void:
	ship.queue_free()
	pass # Replace with function body.



func _on_window_mouse_entered() -> void:
	
	pass # Replace with function body.


func _on_ship_pressed() -> void:
	var x = 0
	ship = shipWindow.instantiate()
	add_child(ship)
	ship.popup_centered(Vector2(300,300))
	ship.set_title(Data.shipdata[0].symbol)
	ship.close_requested.connect(_on_window_close_requested)
	for i in Data.shipdata[0]:
		var newLabel = Label.new()
		ship.add_child(newLabel)
		newLabel.text = i + ": " +  str(Data.shipdata[0][i])
		newLabel.set_position(Vector2(0,x))
		x+=20
	
	#$"Window/Control/Ship System".set_text("Ship System: "+ Data.shipdata[0].nav.systemSymbol)
	#$"Window/Control/Ship Waypoint".set_text("Ship Waypoint: " + Data.shipdata[0].nav.waypointSymbol)
	pass # Replace with function body.
