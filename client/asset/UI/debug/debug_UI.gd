extends Control

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
	process_input(delta)
	$movement/Label_Direction.text = "Direction : " + str(player_Node.dir.round())
	$movement/Label_Velocity.text = "Velocity : " + str(player_Node.vel.round())
	
	$Label_Key.text = "Key pressed : " + key_pressed
	
	$health/Label_Health.text = "Health : " + str(player_Node.health)
	$health/Label_Health_Tic.text = "Health tic : " + str(stepify(player_Node.health_tic_time, 0.1))
	$health/Label_Health_no_damage.text = "Health no damage : " + str(stepify(player_Node.health_time_no_damage, 0.1))
	
	$respawn/Label_Respawn.text = "Time respawn : " + str(stepify(player_Node.time_respawn, 0.1))
	$respawn/Label_is_dead.text = "is dead : " + str(player_Node.is_dead)
	
	$dodge/Label_is_Dodging.text = "Is dodging : " + str(player_Node.is_dodging)
	$dodge/Label_dodge.text = "Dodge : " + str(player_Node.dodge)
	$dodge/Label_dodge_timer_reload.text = "dodge timer reload : " + str(stepify(player_Node.dodge_reload_timer, 0.1))
	
	$attack/Label_can_attack.text = "Can attack : " + str(player_Node.can_attack)
	$attack/Label_attack_timer.text = "Attack timer reload : " + str(stepify(player_Node.timer_reload_attack, 0.1))
		
func process_input(delta):
	key_pressed = ""
	if Input.is_action_pressed("movement_forward"):
		key_pressed += "Z - "
	if Input.is_action_pressed("movement_backward"):
		key_pressed += "S - "
	if Input.is_action_pressed("movement_left"):
		key_pressed += "Q - "
	if Input.is_action_pressed("movement_right"):
		key_pressed += "D - "
	if Input.is_action_pressed("take_damage"):
		key_pressed += "K - "
	if Input.is_action_pressed("dodge"):
		key_pressed += "Space - "
