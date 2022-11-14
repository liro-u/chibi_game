extends Node

func get_next_position(mode):
	var player_spawn_pos
	if mode:
		player_spawn_pos = get_node("Team" + str(Server.players[Server.local_player_id]["team"]) + "_SpawnPoint").get_next_position()
	else:
		player_spawn_pos = get_node("SoloTeam_SpawnPoint").get_next_position()
	return player_spawn_pos
	
