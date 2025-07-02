extends Node2D

@export var Sun : Color
@export var verticalDivider: int
@export var horizontalDivider: int
var coordinates = []
var shipLocation
var node = preload("res://galnode.tscn")


func _ready() -> void:
	print("ready")
	# Debug: print(Data.playerKey) # Uncomment for debugging only, do not use in production
	getShipLocation()
	await getMap()

func _draw() -> void:
	print("draw")
	print(coordinates.size())
	if coordinates.size() == 0:
		draw_circle(Vector2(get_viewport_rect().size/2), 10, Color("Red"))
	else:
		for x in coordinates:
			#draw_circle(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider), 20, Color("Red"))
			#var label = Label.new()
			var galnode = node.instantiate()
			galnode.set_position(Vector2(x["x"]/verticalDivider,x["y"]/horizontalDivider))
			galnode.get_node("Label").text = x["symbol"]
			#label.set_position(Vector2(x["x"]/verticalDivider -30,x["y"]/horizontalDivider +20))
			#label.text = x["symbol"]
			#add_child(label)
			add_child(galnode)
	pass

func getShipLocation():
	$ShipRequest.request_completed.connect(_handleShipRequest)
	$ShipRequest.request(
		"https://api.spacetraders.io/v2/my/ships",
		["Authorization: Bearer " + Data.playerKey]
		)
	pass

func getMap():
	$MapRequest.request_completed.connect(_handleMapRequest)
	await $MapRequest.request(
		"https://api.spacetraders.io/v2/systems",
		["Authorization: Bearer " + Data.playerKey]
		)
	pass


func _on_draw() -> void:
	pass # Replace with function body.


func _handleShipRequest(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	print(response_code)
	print(res)
	var shipNum = 0
	if response_code == 401:
		print("Your token has expired... resetting config")
		Data.delete()
		get_tree().change_scene_to_file("res://MainMenu.tscn")
	for x in res["data"]:
		print("Ship " + str(shipNum))
		print(x["nav"])
		shipNum += 1
	pass # Replace with function body.


func _handleMapRequest(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	print("\n\n\n\n STARMAP")
	#print(res["data"])
	for x in res["data"]:
		print(x["symbol"])
		coordinates.append({"symbol": x["symbol"], "x": x["x"], "y": x["y"]})
	$Control/Label.hide()
	queue_redraw()
	pass # Replace with function body.
