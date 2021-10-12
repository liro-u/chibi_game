extends Node

const DEFAULT_IP = "192.168.1.94"
const DEFAULT_PORT = 3234

var network
var selected_IP
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {}

var wait_screen
var wait_screen_instance = preload("res://asset/UI/wait_screen/wait_screen.tscn")
var end_screen_instance = preload("res://asset/UI/end_screen/final_screen.tscn")
var players_node

sync var teamMode
sync var mode
var world
var player_spawn_point
var game_ui
sync var game_time
sync var game_has_start = false
var minute
var seconde

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	
func _connect_to_server():
	network = NetworkedMultiplayerENet.new()
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)
	
func _player_connected(id):
	print("Player: " + str(id) + " Connected")
	
func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")
	
func _connected_ok():
	print("Successfuly connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
	
func _connected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")

func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data

sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players")
	
sync func start_load_world(world_name):
	wait_screen = wait_screen_instance.instance()
	get_tree().get_root().add_child(wait_screen)
	wait_screen.set_all(mode, world_name)
	load_world(world_name)
	
func load_world(world_name):
	var world_path
	match world_name:
		"dev_world":
			world_path = "res://asset/world/TestingArea/TestingArea.tscn"
	world = load(world_path).instance()
	get_tree().get_root().add_child(world)
	get_tree().call_group("WaitingRoom","queue_free")
	game_ui = world.get_node("Game_UI")
	var max_value
	var base_value = 0
	match mode:
		"mme":
			max_value = (players.size() * 7)
		"mg":
			max_value = 10
	game_ui.set_up(max_value, base_value)
	game_ui.connect_end("end_of_game")
	
	player_spawn_point = world.get_node("PlayerSpawn")
	rpc_id(1, "spawn_players", Server.local_player_id)

sync func spawn_player(id):
	var charact = choosePlayer(int(Server.players[id]["Last_charact"]))
	var player_charact = load(charact)
	var player = player_charact.instance()
	player.name = str(id)
	player.add_to_group("team_" + str(Server.players[id]["team"]))
	players_node = world.get_node("Players")
	players_node.add_child(player)
	player.global_transform = player_spawn_point.get_next_position(teamMode)
	if id == local_player_id:
		world.get_node("debug_UI").set_player(player)
		game_ui.set_player(player)
		world.get_node("CamRoot").set_follow_point(player.get_node("CameraPoint"))
	player.set_network_master(id)
	if players_node.get_child_count() >= players.size():
		rpc_id(1, "start_game")
	
func choosePlayer(index):
	match index:
		0:
			return "res://asset/charact/bronya/Bronya_Player.tscn"
		_:
			print("WARNING : too big value on node : " + name)

remote func update_player_score(players_info, death_id, killer_id):
	players = players_info
	if local_player_id == death_id:
		game_ui.update_value("death", players[death_id]["death"])
	if killer_id != null:
		if local_player_id == killer_id:
			game_ui.update_value("kill", players[killer_id]["kill"])	
		if players[killer_id]["team"] == players[local_player_id]["team"]:
			game_ui.update_value("team_score", 1)
		else:
			match mode:
				"mme":
					game_ui.update_value("enemy_score", 1)
				"mg":
					if players[killer_id]["kill"] >= game_ui.enemy_score_node.bar_node.value:
						game_ui.update_value("enemy_score", 1)
						
func second2minute(time):
	minute = int(time)/60
	seconde = int(time - (minute*60))
	
func process_time(delta):
	game_time -= delta
	second2minute(game_time)
	var fix_zero_on_seconde = ""
	if seconde < 10:
		fix_zero_on_seconde = "0"
	
	game_ui.update_value("time", str(minute) + ":" + fix_zero_on_seconde + str(seconde))
	
func _physics_process(delta):
	if game_has_start:
		process_time(delta)

sync func end_of_game():
	game_has_start = false
	get_tree().get_root().add_child(end_screen_instance.instance())
	world.queue_free()
	
sync func start_game():
	wait_screen.queue_free()
	game_has_start = true

func leave_server_input():
	rpc_id(1, "leave_server", local_player_id)
	
remote func leave_server():
	get_tree().network_peer.close_connection(0)
	get_tree().get_root().get_node("final_screen").replace_by_lobby()
	print("you have leaved the server")
	players = {}
	
