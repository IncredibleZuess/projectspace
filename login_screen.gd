extends CanvasLayer

var key = ""
var config = ConfigFile.new()
## Gets input from the login screen box
func _get_input():
	key = $LoginScreen/VBoxContainer/Key
	return key.text
	
func getDataOnAPI(key):
	$HTTPRequest.request_completed.connect(_on_http_request_request_completed)
	$HTTPRequest.request(
		"https://api.spacetraders.io/v2/my/account",
		["Authorization: Bearer " + key]
	)

func ShowMessage(text):
	var message = $LoginScreen/VBoxContainer/Display
	message.text = text
	message.show()
	

func _on_login_pressed() -> void:
	key = _get_input()
	getDataOnAPI(key)


func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print(result)
	print(response_code)
	if response_code == 401:
		ShowMessage("Invalid API Key")
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	# print(key) # Removed to avoid exposing credentials
	config.set_value("PlayerDATA", "key", key)
	config.save("user://pData.cfg")
	print(json["data"]["account"]["email"])
	ShowMessage(json["data"]["account"]["email"])
	get_tree().change_scene_to_file("res://map.tscn")
