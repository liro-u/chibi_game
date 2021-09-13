extends Node

remote func update_player(update_translation, mesh_rotation):
	rpc_unreliable("update_player", update_translation, mesh_rotation)

remote func update_player_anim(anim_name):
	rpc("update_anim", anim_name)
	
remote func kill_player():
	rpc("kill_player")
	
remote func revive_player():
	rpc("revive_player")
	
remote func make_attack():
	rpc("make_attack")
