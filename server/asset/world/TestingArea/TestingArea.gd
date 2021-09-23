extends Spatial

export var time_of_game = 300
signal time_end

var server

func _ready():
	server = get_tree().get_root().get_node("Server")
	server.set_game_time(time_of_game)
	

		
