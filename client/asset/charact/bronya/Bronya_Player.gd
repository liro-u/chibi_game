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

export var AMMO_ATTACK = 15
var ammo_attack = AMMO_ATTACK
export var RELOAD_AMMO_TIME = 3
var reload_ammo_timer = RELOAD_AMMO_TIME
#--------------------------------------------------

func _ready():
	projectile_point = get_node(projectile_point_path)
	
	exception_colision.append(self)
	

#-----------------------------------------------
#### ATTACK ####
func process_attacking(delta):
	if last_attack_is_shoot == true:
		if can_attack == false:
			if ammo_attack > 0:
				if timer_reload_attack <= 0:
					timer_reload_attack = TIMER_RELOAD_ATTACK
					can_attack = true
				else:
					timer_reload_attack -= delta
			else:
				if reload_ammo_timer <= 0:
					reload_ammo_timer = RELOAD_AMMO_TIME
					ammo_attack = AMMO_ATTACK
				else:
					reload_ammo_timer -= delta
					
func reload_basic_attack():
	ammo_attack = AMMO_ATTACK
	reload_ammo_timer = RELOAD_AMMO_TIME
	timer_reload_attack = TIMER_RELOAD_ATTACK

sync func make_attack():
	last_attack_is_shoot = true
	ammo_attack -= 1
	var projectile = bronya_projectile.instance()
	var scene_player_projectile = Server.world.get_node("PlayersWeapon")
	scene_player_projectile.add_child(projectile)
	
	projectile.exception = exception_colision
	projectile.player_property_id = int(name)
	
	var target_node = $target_system.current_target
	if target_node != null:
		var target_point = target_node.global_transform.origin
		var projectile_point_coord = projectile_point.global_transform.origin
		target_point.y = projectile_point_coord.y
		projectile.look_at_from_position(projectile_point_coord, target_point, Vector3(0, 1, 0))
		projectile.rotate_y(PI)
	else:
		projectile.global_transform = projectile_point.global_transform
	audio_node.play_sound("attack")
#-----------------------------------------------------

