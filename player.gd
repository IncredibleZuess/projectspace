extends Node

var config = ConfigFile.new()
var err = config.load("user://pData.cfg") #TODO implement error handling if a file becomes corrupted
var playerKey = ""

#Helper method to delete the config if the token expires
func delete():
	print("clearing config")
	config.clear()


func checkValid():
	var req = HTTPRequest.new()
	add_child(req)
	req.request_completed.connect(self._http_request_completed)
	var headers = ["Authorization: Bearer " + playerKey]
	var rerr = req.request("https://api.spacetraders.io/v2/my/account",headers)
	print("Checking if token is valid")
	if rerr == OK:
		print("Token is valid continuing")
		get_tree().change_scene_to_file("res://map.tscn")
		req.queue_free()
	else:
		print("Token is invalid")
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		config.clear()
		req.queue_free()

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var res = json.get_data()
	print(res)
func _ready():
	checkValid()
	for player in config.get_sections():
		playerKey = config.get_value(player, "key")
		
