extends KinematicBody

#-----------------------------------------------
# Node and Path
export(NodePath) var animationTree_Path
var animationTree

export(NodePath) var mesh_Path
var mesh_Node
#-----------------------------------------------

#-----------------------------------------------
# Basic Movement
const GRAVITY = 9.8
const MAX_SLOPE_ANGLE = 40

var vel = Vector3()
export var MAX_SPEED = 10
export var ACCEL = 4.5
export var DEACCEL = 16

const MIN_SPEED_ANIMATION = 30

var dir = Vector3()

const ANGULAR_ACCELERATION = 7
#-------------------------------------------------

#-------------------------------------------------
# Player Statistic
export var MAX_HEALTH = 100
var health = MAX_HEALTH

export var HEALTH_BY_TIC = 4

export var HEALTH_TIMER_NO_DAMAGE = 2
var health_time_no_damage = 0

export var HEALTH_TIC_TIMER = 0.6
var health_tic_time = 0

export var TIMER_RESPAWN = 3
var time_respawn = TIMER_RESPAWN
var is_dead = false
#--------------------------------------------------

#-------------------------------------------------
# Attacking
var is_attacking = false
#--------------------------------------------------

#------------------------------------------------
# Dodging
var is_dodging = false

export var MAX_SPEED_DODGE = 20
export var DODGE_ACCEL = 14

export var MAX_DODGE = 3
var dodge = MAX_DODGE

export var DODGE_RELOAD_TIMER = 3
var dodge_reload_timer = DODGE_RELOAD_TIMER

var dodge_reload_amount = 1
#------------------------------------------------

func _ready():
	animationTree = get_node(animationTree_Path)

	if mesh_Path == "":
		error_msg("no  mesh PackedScene assign to " + name + " (path : " + get_path() + ")")
	elif animationTree.active == false or animationTree.anim_player == "":
		error_msg("link AnimationPlayer to " + animationTree.name + " and set it active" + " (path : " + animationTree.get_path() + ")")
	else:
		mesh_Node = get_node(mesh_Path)
		
func error_msg(msg):
	set_physics_process(false)
	print("WARNING : " + msg)
	
func _physics_process(delta):
	if is_network_master():
		process_input(delta)
	
		if health > 0:
			process_movement(delta)
			process_attacking(delta)
			process_dodging(delta)
			process_health(delta)
		else:
			process_respawn(delta)
			
		rpc_unreliable_id(1, "update_player", name, translation, mesh_Node.rotation.y)
		
remote func update_player(id, update_translation, mesh_rotation):
	if not is_network_master():
		if name == id:
			translation = update_translation
			mesh_Node.rotation.y = mesh_rotation
	
func process_input(delta):
	#----------------------------------------
	# Walking
	if is_dodging == false:
		dir = Vector3()
		
		var input_movement_vector = Vector3()
		
		if Input.is_action_pressed("movement_forward"):
			input_movement_vector.z += 1
		if Input.is_action_pressed("movement_backward"):
			input_movement_vector.z -= 1
		if Input.is_action_pressed("movement_left"):
			input_movement_vector.x += 1
		if Input.is_action_pressed("movement_right"):
			input_movement_vector.x -= 1
		
		input_movement_vector = input_movement_vector.normalized()
		
		dir += input_movement_vector
	#--------------------------------------------
	
	#--------------------------------------------
	# Dodging
	if Input.is_action_pressed("dodge"):
		if dodge > 0:
			if is_dodging == false:
				if dir != Vector3(0, 0, 0):
					is_dodging = true
					dodge -= 1
	#---------------------------------------------------
	
	#--------------------------------------------------
	# Attack
	if Input.is_action_pressed("attack"):
		if is_attacking == false:
			is_attacking = true
			
	#--------------------------------------------------
	
	#---------------------------------------------
	# Debug mode
	if Input.is_action_just_pressed("take_damage"):
		take_damage(17)
	#---------------------------------------------
#-----------------------------------------------------------
#### MOVEMENT ####

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	if is_on_floor():
		vel.y = 0
	else:
		vel.y -= delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	if is_dodging == true:
		target *= MAX_SPEED_DODGE
	else:
		target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		if is_dodging == true:
			accel = DODGE_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	
	if dir.length_squared() > 0.01:
		mesh_Node.rotation.y = lerp_angle(mesh_Node.rotation.y, atan2(dir.x,dir.z), delta * ANGULAR_ACCELERATION)
	
	if hvel.length_squared() > MIN_SPEED_ANIMATION:
		set_anim("Walking")
	else:
		set_anim("Idle")
	
	if is_dodging == true:
		set_anim("Dodge")

func set_anim(anim_name):
	animationTree["parameters/playback"].travel(anim_name)
	rpc_id(1, "update_player_anim", name, anim_name)

remote func update_anim(id, anim_name):
	if not is_network_master():
		if name == id:
			animationTree["parameters/playback"].travel(anim_name)

func anim_end(anim_name):
	match anim_name:
		"Dodge":
			is_dodging = false
#-------------------------------------------------------------------
#### HEALTH ####

func process_health(delta):
	if health_time_no_damage <= 0:
		if health != MAX_HEALTH:
			if health_tic_time <= 0:
				add_health(HEALTH_BY_TIC)
				health_tic_time = HEALTH_TIC_TIMER
			else:
				health_tic_time -= delta
	else:
		health_time_no_damage -= delta
	
func add_health(additional_health):
	health += additional_health
	health = min(health, MAX_HEALTH)

#-------------------------------------------------------
#### ATTACKING ####
func process_attacking(delta):
	pass
	
#-------------------------------------------------------
#### TAKE DAMAGE ####
func take_damage(damage):
	health_time_no_damage = HEALTH_TIMER_NO_DAMAGE
	health_tic_time = 0
	health -= damage
	health = max(health, 0)

#----------------------------------------------------------
#### RESPAWN ####

func process_respawn(delta):
	if is_dead == false:
		hide()
		rpc_id(1, "hide_player", name)
		is_dead = true
	if is_dead == true:
		if time_respawn <= 0:
			time_respawn = TIMER_RESPAWN
			is_dead = false
			health = MAX_HEALTH
			health_tic_time = 0
			health_time_no_damage = 0
			transform.origin = Vector3(0, 0, 0)
			show()
			rpc_id(1, "show_player", name)
		else:
			time_respawn -= delta

remote func hide_player(id):
	if not is_network_master():
		if id == name:
			hide()
			
remote func show_player(id):
	if not is_network_master():
		if id == name:
			show()
#---------------------------------------------------
#### DODGING ####

func process_dodging(delta):
	if dodge < MAX_DODGE:
		if dodge_reload_timer <= 0:
			dodge_reload_timer = DODGE_RELOAD_TIMER
			
			dodge += dodge_reload_amount
			dodge = min(dodge, MAX_DODGE)
		else:
			dodge_reload_timer -= delta
