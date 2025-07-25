extends Node

var config = ConfigFile.new()
var err = config.load("user://pData.cfg") #TODO implement error handling if a file becomes corrupted
var playerKey = ""
var ships = []
var systemSelected = ""

var shipReq = HTTPRequest.new()

#Helper method to delete the config if the token expires
func delete():
	print("clearing config")
	config.clear()


func checkValid():
	var req = HTTPRequest.new()
	add_child(req)
	req.request_completed.connect(self._http_request_completed)
	var headers = ["Authorization: Bearer " + playerKey]
	print(playerKey)
	req.request("https://api.spacetraders.io/v2/my/account",headers)
	print("Checking if token is valid")
		

func getShipLocation():

	add_child(shipReq)
	shipReq.request_completed.connect(_handleShipRequest)
	shipReq.request(
		"https://api.spacetraders.io/v2/my/ships",
		["Authorization: Bearer " + Data.playerKey]
		)

func _http_request_completed(_result, response_code, headers, body):
	print(response_code)
	if response_code == 401:
		print("Your token has expired... resetting config")
		delete()
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		return
	get_tree().change_scene_to_file("res://map.tscn")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var res = json.get_data()
	print(res)
	
func _handleShipRequest(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	print(response_code)
	var shipNum = 0
	for x in res["data"]:
		print(x["nav"]["systemSymbol"])
		print("Ship " + str(shipNum))
		#print(x["nav"])
		ships.append(x["nav"]["systemSymbol"])
		shipNum += 1
	
	shipReq.queue_free()
	

func _ready():
	for player in config.get_sections():
		playerKey = config.get_value(player, "key")
	checkValid()
	getShipLocation()
