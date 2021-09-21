extends Area

var target_player = null
var list_targetable_player = []
export var max_angle_target = 22.5

func _on_target_view_body_entered(body):
	if body.has_method("take_damage"):
		if not body.is_in_group("team_" + str(Server.players[int(get_parent().name)]["team"])):
			list_targetable_player.append(body)
			
func _on_target_view_body_exited(body):
	list_targetable_player.erase(body)
	if body == target_player:
		target_player = null
	
func refresh_current_target_player():
	var player_num = 0
	var player
	if target_player != null:
		if not check_targetable_player_validity(target_player):
			target_player = null
			
	while target_player == null and player_num < list_targetable_player.size():
		player = list_targetable_player[player_num]
		player_num += 1
		if check_targetable_player_validity(player):
			target_player = player
	return target_player


func check_targetable_player_validity (player):
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
	var vector3d_view = -global_transform.basis.z
	var vector3d_target = get_parent().mesh_Node.global_transform.basis.z
	var vector2d_view = Vector2(vector3d_view.x, vector3d_view.z)
	var vector2d_target = Vector2(vector3d_target.x, vector3d_target.z)
	
	var angle_between_aim = abs(rad2deg(vector2d_target.angle_to(vector2d_view)))
	if angle_between_aim <= max_angle_target:
		return true
	else:
		return false
