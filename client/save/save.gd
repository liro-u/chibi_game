extends Node

const SAVEGAME = "user://Savegame.json"
var reset_data = false

var save_data = {}

func _ready():
	var file = File.new()
	
	if reset_data:
		print("WARNING : reset data is activate in node : " + name)
		
	if not file.file_exists(SAVEGAME) or reset_data:
		save_data = {"Player_name":"Unamed", "Last_charact":0}
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
