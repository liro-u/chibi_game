extends Control

export(NodePath) var player_list_path
var player_list

func _ready():
	player_list = get_node(player_list_path)
	
	player_list.clear()
	
func refresh_players(players):
	player_list.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
