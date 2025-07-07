extends Node2D
var coordinates = []
var node = preload("res://galnode.tscn")
@export var verticalDivider: int
@export var horizontalDivider: int
var systems = 20

func getSystemData(data: String):
	$systemRequest.request(
		"https://api.spacetraders.io/v2/systems/"+ data,
		["Authorization: Bearer " + Data.playerKey]
	)
	

func _draw() -> void:
	print("draw")
	print(coordinates.size())
	if coordinates.size() == 0:
		pass
	else:
		for x in coordinates:
			print(x["x"], x["y"])
			#draw_circle(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider), 20, Color("Red"))
			#var label = Label.new()
			var galnode = node.instantiate()
			galnode.set_global_position(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider))
			galnode.get_node("Control").get_node("Label").text = x["symbol"]
			#label.set_position(Vector2(x["x"]/verticalDivider -30,x["y"]/horizontalDivider +20))
			#label.text = x["symbol"]
			#add_child(label)a
			add_child(galnode)
			#TODO Implement A* to connect these lines
			#draw_multiline(points, lineColor) #This is to connect points together but it is left out for now because it connects to invisible points
			systems = systems + 1
		coordinates.clear()
	pass

func _ready() -> void:
	getSystemData(Data.systemSelected)
	
	
func _systemDataReceived(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray)->void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	#print(JSON.stringify(res, "\t"))
	print(res.data.symbol)
	print(res.data.type)
	coordinates.append({"type": res.data.type, "symbol": res.data.symbol + " - SUN", "x": 0, "y": 0})
	
	for x in res.data.waypoints:
		print(x)
		#if x["symbol"] in Data.ships:
			#coordinates.append({"symbol": x["symbol"] + " Ship", "x": x["x"], "y": x["y"]})
		coordinates.append({"type": x["type"], "symbol": x["symbol"], "x": x["x"], "y": x["y"]})
	queue_redraw()
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://map.tscn")
	pass # Replace with function body.
