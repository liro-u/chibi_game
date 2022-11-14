extends Spatial
class_name explosive_baril
	
var RESPAWN_TIME = 5
var respawn_timer = RESPAWN_TIME

var is_activ = true

func _process(delta):
	if not is_activ:
		if respawn_timer <= 0:
			respawn_baril()
		else:
			respawn_timer -= delta
			
remote func destroy_baril():
	rpc("destroy_baril")
	is_activ = false
	
func respawn_baril():
	rpc("respawn_baril")
	respawn_timer = RESPAWN_TIME
	is_activ = true
