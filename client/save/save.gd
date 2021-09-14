extends Node

const SAVEGAME = "user://Savegame.json"
var new_value_added = true

var save_data = {}

func _ready():
	var file = File.new()
	
	if not file.file_exists(SAVEGAME) or new_value_added == true:
		save_data = {"Player_name":"Unamed", "Last_charact":"res://asset/charact/bronya/Bronya_Player.tscn"}
		save_game()
	file.open(SAVEGAME, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	file.close()
	return data
	
func save_game():
	var save_game = File.new()
	save_game.open(SAVEGAME, File.WRITE)
	save_game.store_line(to_json(save_data))
