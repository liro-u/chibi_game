extends Spatial

export(NodePath) var damage_zone_path
var damage_zone
export(NodePath) var mesh_path
var mesh
export(NodePath) var body_colision_path
var body_colision
export(NodePath) var smoke_particle_path
var smoke_particle
export(NodePath) var ember_particle_path
var ember_particle
export(NodePath) var timer_before_explosion_path
var timer_before_explosion
export(NodePath) var animation_player_path
var animation_player
export(NodePath) var progress_texture_path
onready var progress_texture = get_node(progress_texture_path)

export var TIME_BEFORE_EXPLOSION = 0.3
export var DAMAGE = 30

var baril_is_activ = true
var baril_has_start_explosed = false
var player_origin

func start_explosion(player_origin_damage):
	if not baril_has_start_explosed:
		timer_before_explosion.start()
		player_origin = player_origin_damage
		baril_has_start_explosed = true
		animation_player.current_animation = "explosion"
		animation_player.play()
		progress_texture.start_resize()
	
	
func _ready():
	damage_zone = get_node(damage_zone_path)
	mesh = get_node(mesh_path)
	body_colision = get_node(body_colision_path)
	ember_particle = get_node(ember_particle_path)
	smoke_particle = get_node(smoke_particle_path)
	timer_before_explosion = get_node(timer_before_explosion_path)
	animation_player = get_node(animation_player_path)
	
	timer_before_explosion.wait_time = TIME_BEFORE_EXPLOSION
	animation_player.playback_speed = TIME_BEFORE_EXPLOSION
	$"visualisation_zone/progress_visualisation_zone/size_bar_tween".playback_speed = 1/TIME_BEFORE_EXPLOSION
	
func take_damage():
	if baril_is_activ:
		baril_is_activ = false
		for bodie in damage_zone.get_overlapping_bodies():
			var team_exeption = "team_" + str(Server.players[int(player_origin)]["team"])
			if bodie.name == str(player_origin) or not bodie.is_in_group(team_exeption):
				if bodie.has_method("take_damage"):
					bodie.take_damage(DAMAGE, player_origin)
		rpc_id(1, "destroy_baril")
		
sync func destroy_baril():
	baril_is_activ = false
	baril_has_start_explosed = true
	ember_particle.emitting = true
	smoke_particle.emitting = true
	mesh.hide()
	progress_texture.get_parent().hide()
	body_colision.disabled = true
	
sync func respawn_baril():
	animation_player.current_animation = "idle"
	animation_player.play()
	baril_has_start_explosed = false
	baril_is_activ = true
	mesh.show()
	body_colision.disabled = false
