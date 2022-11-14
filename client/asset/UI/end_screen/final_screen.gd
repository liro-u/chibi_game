extends ColorRect

var team_stat_node = preload("res://asset/UI/end_screen/team_stat/team_pannel_stat.tscn")
var player_stat_node = preload("res://asset/UI/end_screen/player_stat/player_stat_game.tscn")
var lobby = preload("res://asset/UI/lobby/lobby.tscn")
var waiting_room = preload("res://asset/UI/lobby/waiting_room.tscn")

export(NodePath) var team_list_node_path
var team_list_node

func _ready():
	team_list_node = get_node(team_list_node_path)
	if Server.teamMode:
		new_team_stat(0)
		new_team_stat(1)
	else:
		new_team_stat()
			
func new_team_stat(team = -1):
	var team_stat = team_stat_node.instance()
	team_list_node.add_child(team_stat)
	var player_stat
	for player in Server.players:
		if team == -1 or Server.players[player]["team"] == team:
			player_stat = player_stat_node.instance()
			player_stat.player = player
			team_stat.player_stat_list.add_child(player_stat)


func _on_back_pressed():
	Server.leave_server_input()
	
func replace_by_lobby():
	get_tree().get_root().add_child(lobby.instance())
	queue_free()

func _on_restart_pressed():
	var wait_room = get_tree().get_root().add_child(waiting_room.instance())
	Server.rpc_id(1, "try_to_load_world")
	queue_free()
