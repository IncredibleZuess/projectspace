extends CanvasLayer


func _get_input():
	var key = $LoginScreen/VBoxContainer/Key
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
	getDataOnAPI(_get_input())


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print(result)
	print(response_code)
	if response_code == 401:
		ShowMessage("Invalid API Key")
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["data"]["account"]["email"])
	ShowMessage(json["data"]["account"]["email"])
