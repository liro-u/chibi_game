extends Spatial

remote func destroy(name, health):
	rpc("destroy")
	var server = get_tree().get_root().get_node("Server")
	var body = server.world.get_node("Players").get_node(name)
	body.add_health(health)
	
remote func respawn():
	rpc("respawn")
