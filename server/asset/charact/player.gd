extends Node

remote func update_player(id, update_translation, mesh_rotation):
	rpc_unreliable("update_player", id, update_translation, mesh_rotation)

remote func update_player_anim(id, anim_name):
	rpc("update_anim", id, anim_name)
	
remote func hide_player(id):
	rpc("hide_player", id)
	
remote func show_player(id):
	rpc("show_player", id)
	
