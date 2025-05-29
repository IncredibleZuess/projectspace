extends Node2D

@export var Sun : Color
@export var verticalDivider: int
@export var horizontalDivider: int
var coordinates = []
var shipLocation
var node = preload("res://galnode.tscn")

func _ready() -> void:
	print("ready")
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
			galnode.get_child(1).text = x["symbol"]
			#label.set_position(Vector2(x["x"]/verticalDivider -30,x["y"]/horizontalDivider +20))
			#label.text = x["symbol"]
			#add_child(label)
			add_child(galnode)
	pass

func getShipLocation():
	$ShipRequest.request_completed.connect(_handleShipRequest)
	$ShipRequest.request(
		"https://api.spacetraders.io/v2/my/ships",
		["Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjoiWlVFU1MiLCJ2ZXJzaW9uIjoidjIuMy4wIiwicmVzZXRfZGF0ZSI6IjIwMjUtMDUtMjUiLCJpYXQiOjE3NDg1MjY1MzMsInN1YiI6ImFnZW50LXRva2VuIn0.ZCc3TDQQ-_rTw7QNMkKgRlLmPiewn33_ciD7vnrVH_yVitPX4fBAUMkGrwTSlQ5rV8cQOTqqCMWeC1Nau-PMkt-UaTJKBG71ia7CeI0uHAsN4UqQloVivkmvVMly1htrJmYZFp-_SsnSZq3BeNgyn7f2BrPByDqxMj6NJl0LR4R361xEtzQkgSgGYjKQnifF7wEX15gJwbfopDgXXVdXgqwQx46WnekA584eY63enwHhYsSxTKCXachYipH_dInG8XYc1GC0d7HXzVZ_h7KHmOpgx1v6ysvO3Znq8nGYoIKm_qnGFSEzF_86fWpmDnPy0Cx8uDwES1SdrSwCjNsKqRJrsIxJUJlSOzxbCRDw7YBb-GXvxSoaRr3IT_FAQ--7HyVa522-uu6QWy_8a1IWQsY9bukg0DMDZIte-HK2x-9eBakgmvT1eMLqe9jqxirqFaXfy6jqqf293cHS7pM-D-apnoDzJIX-XNkp0QRRpqLNZmwSZuqhu-hppdnhOCNshKzCa89WkZk82EKOCa9hZyxmub99RnK1AQQAeiwDdNokHgczuRC-IzcMSSEZX6JgERMZX94TCIsJ94Q9Yxtf6Z-Yhuu4yrDygH-Nq0dOiFUmZhZy1XXxIre3BYQmXYHMecKRy0rnMEb9XonyufYKs9KWWr3NRxiATC4xEhKDJMo"]
		)
	pass

func getMap():
	$MapRequest.request_completed.connect(_handleMapRequest)
	await $MapRequest.request(
		"https://api.spacetraders.io/v2/systems",
		["Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjoiWlVFU1MiLCJ2ZXJzaW9uIjoidjIuMy4wIiwicmVzZXRfZGF0ZSI6IjIwMjUtMDUtMjUiLCJpYXQiOjE3NDg1MjY1MzMsInN1YiI6ImFnZW50LXRva2VuIn0.ZCc3TDQQ-_rTw7QNMkKgRlLmPiewn33_ciD7vnrVH_yVitPX4fBAUMkGrwTSlQ5rV8cQOTqqCMWeC1Nau-PMkt-UaTJKBG71ia7CeI0uHAsN4UqQloVivkmvVMly1htrJmYZFp-_SsnSZq3BeNgyn7f2BrPByDqxMj6NJl0LR4R361xEtzQkgSgGYjKQnifF7wEX15gJwbfopDgXXVdXgqwQx46WnekA584eY63enwHhYsSxTKCXachYipH_dInG8XYc1GC0d7HXzVZ_h7KHmOpgx1v6ysvO3Znq8nGYoIKm_qnGFSEzF_86fWpmDnPy0Cx8uDwES1SdrSwCjNsKqRJrsIxJUJlSOzxbCRDw7YBb-GXvxSoaRr3IT_FAQ--7HyVa522-uu6QWy_8a1IWQsY9bukg0DMDZIte-HK2x-9eBakgmvT1eMLqe9jqxirqFaXfy6jqqf293cHS7pM-D-apnoDzJIX-XNkp0QRRpqLNZmwSZuqhu-hppdnhOCNshKzCa89WkZk82EKOCa9hZyxmub99RnK1AQQAeiwDdNokHgczuRC-IzcMSSEZX6JgERMZX94TCIsJ94Q9Yxtf6Z-Yhuu4yrDygH-Nq0dOiFUmZhZy1XXxIre3BYQmXYHMecKRy0rnMEb9XonyufYKs9KWWr3NRxiATC4xEhKDJMo"]
		)
	pass


func _on_draw() -> void:
	pass # Replace with function body.


func _handleShipRequest(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	#print(res["data"])
	var shipNum = 0
	for x in res["data"]:
		print("Ship " + str(shipNum))
		print(x["nav"])
		shipNum = shipNum + 1
	pass # Replace with function body.


func _handleMapRequest(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	print("\n\n\n\n STARMAP")
	#print(res["data"])
	for x in res["data"]:
		print(x["symbol"])
		coordinates.append({"symbol": x["symbol"], "x": x["x"], "y": x["y"]})
	$Control/Label.hide()
	queue_redraw()
	pass # Replace with function body.
