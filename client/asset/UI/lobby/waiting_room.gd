extends Control

export(NodePath) var player_list_path
var player_list

func _ready():
	player_list = get_node(player_list_path)
	
	refresh_players()
	
func refresh_players():
	player_list.clear()
	for player_id in Server.players:
		var player = Server.players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
