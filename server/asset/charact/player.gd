extends Node

remote func update_player(update_translation, mesh_rotation):
	rpc_unreliable("update_player", update_translation, mesh_rotation)

remote func update_player_anim(anim_name):
	rpc("update_anim", anim_name)
	
remote func kill_player(death_id, killer_id):
	rpc("kill_player")
	get_tree().get_root().get_node("Server").update_player_stat(death_id, killer_id)
	
remote func revive_player():
	rpc("revive_player")
	
remote func make_attack():
	rpc("make_attack")
