extends "res://asset/charact/player/Player_Control.gd"

#-----------------------------------------------
# Node and Path
export(NodePath) var projectile_point_path
var projectile_point
#------------------------------------------------

#------------------------------------------------
# Basic attack
var bronya_projectile = preload("res://asset/charact/bronya/weapon/BronyaProjectile.tscn")
var exception_colision = []

export var TIMER_RELOAD_ATTACK = 0.2
var timer_reload_attack = TIMER_RELOAD_ATTACK
#--------------------------------------------------

func _ready():
	projectile_point = get_node(projectile_point_path)
	
	exception_colision.append(self)

#-----------------------------------------------
#### ATTACK ####
func process_attacking(delta):
	if last_attack_is_shoot == true:
		if can_attack == false:
			if timer_reload_attack <= 0:
				timer_reload_attack = TIMER_RELOAD_ATTACK
				can_attack = true
			else:
				timer_reload_attack -= delta
			
sync func make_attack():
	last_attack_is_shoot = true
	var projectile = bronya_projectile.instance()
	var scene_player_projectile = Server.world.get_node("PlayersWeapon")
	scene_player_projectile.add_child(projectile)
	
	projectile.exception = exception_colision
	projectile.player_property_id = int(name)
	projectile.global_transform = projectile_point.global_transform
#-----------------------------------------------------
