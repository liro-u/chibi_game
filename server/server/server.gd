extends Node

var network = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 2

var players_id = []
var players = {}

var PLAYER = preload("res://asset/charact/player.tscn")
var world

func _ready():
	randomize()
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_connected", self, "_player_connected")
	network.connect("peer_disconnected", self, "_player_disconnected")
	
	print("Server Started")
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	erase_player_info(player_id)
	
remote func send_player_info(id, player_data):
	players_id.append(id)
	players[id] = player_data
	rset("players", players)
	rpc("update_waiting_room")
	load_world()
	
func erase_player_info(id):
	players_id.erase(id)
	players.erase(id)
	rset("players", players)
	rpc("update_waiting_room")

func make_team():
	var players_in_team = 0
	var players_with_team = 0
	var team
	for player_id in players_id:
		if players_with_team - players_in_team < max_players/2 and players_in_team < max_players/2:
			team = randi() % 2
			if team == 0:
				players_in_team += 1
		elif players_in_team == max_players/2:
			team = 1
		else:
			team = 0
				
		players_with_team += 1
		players[player_id]["team"] = team
	print("Team assigned to all players")

func reset_player_stat_game():
	for player_id in players_id:
		players[player_id]["kill"] = 0
		players[player_id]["death"] = 0
	rset("players", players) 
	
func load_world():
	if players.size() == max_players:
		make_team()
		reset_player_stat_game()
		rpc("load_world")
		world = preload("res://asset/world/TestingArea/TestingArea.tscn").instance()
		get_tree().get_root().add_child(world)

remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	world.get_node("Players").add_child(player)
	
	rpc("spawn_player", id)

func update_player_stat(death_id, killer_id):
	players[death_id]["death"] += 1
	if killer_id != null:
		players[killer_id]["kill"] += 1
	rset("players", players)
