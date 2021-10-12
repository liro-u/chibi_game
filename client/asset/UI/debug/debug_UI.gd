extends MarginContainer

#-------------------------------------------
# Node and Path
export (NodePath) var player_Path
var player_Node
#---------------------------------------------

var key_pressed

func _ready():
	if player_Path == "":
		set_physics_process(false)
	else:
		player_Node = get_node(player_Path)
	
func set_player(node):
	player_Node = node
	player_Path = node.get_path()
	set_physics_process(true)
	
func _physics_process(delta):
	$list_node/movement/Label_Direction.text = "Direction : " + str(player_Node.dir.round())
	$list_node/movement/Label_Velocity.text = "Velocity : " + str(player_Node.vel.round())
	
	$list_node/health/Label_Health.text = "Health : " + str(player_Node.health)
	$list_node/health/Label_Health_Tic.text = "Health tic : " + str(stepify(player_Node.health_tic_time, 0.1))
	$list_node/health/Label_Health_no_damage.text = "Health no damage : " + str(stepify(player_Node.health_time_no_damage, 0.1))
	
	$list_node/respawn/Label_Respawn.text = "Time respawn : " + str(stepify(player_Node.time_respawn, 0.1))
	$list_node/respawn/Label_is_dead.text = "is dead : " + str(player_Node.is_dead)
	
	$list_node/dodge/Label_is_Dodging.text = "Is dodging : " + str(player_Node.is_dodging)
	$list_node/dodge/Label_dodge.text = "Dodge : " + str(player_Node.dodge)
	$list_node/dodge/Label_dodge_timer_reload.text = "dodge timer reload : " + str(stepify(player_Node.dodge_reload_timer, 0.1))
	
	$list_node/attack/Label_can_attack.text = "Can attack : " + str(player_Node.can_attack)
	$list_node/attack/Label_last_attack_shoot.text = "Last attack is shoot : " + str(player_Node.last_attack_is_shoot)
	$list_node/attack/Label_attack_timer.text = "Attack timer reload : " + str(stepify(player_Node.timer_reload_attack, 0.1))
	$list_node/attack/Label_attack_ammo.text = "Ammo : " + str(player_Node.ammo_attack)
	$list_node/attack/Label_attack_reload_ammo.text = "Reload ammo timer : " + str(stepify(player_Node.reload_ammo_timer, 0.1))
	
	$list_node/score_board/death.text = "Death : " + str(Server.players[int(player_Node.name)]["death"])
	$list_node/score_board/kill.text = "Kill : " + str(Server.players[int(player_Node.name)]["kill"])
	$list_node/score_board/has_start.text = "Game has start : " + str(Server.game_has_start)
	$list_node/score_board/timer_game.text = "Timer of game : " + str(Server.minute) + ":" + str(Server.seconde)
	
	$list_node/shield/shield_on.text = "Shield is on : " + str(player_Node.shield_on)
	$list_node/shield/time_shield.text = "Shield life timer : " + str(stepify(player_Node.shield_respawn_time, 0.1))
