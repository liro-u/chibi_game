extends Spatial

var SPEED = 30
var DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

const WAIT_KILL_TIMER = 2.3
var wait_timer = 0

var exception = []
var player_property_id

var Area_node

export var speed_rotation = 10

var projectile_is_active = true

onready var sphere_particles = $sphere_particles
onready var trail_particles = $trail_particles

func _ready():
	Area_node = $"Area"

func _physics_process(delta):
	if projectile_is_active:
		movement_process(delta)
	else:
		process_kill_projectile(delta)
	
func movement_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir *SPEED * delta)
	
	timer += delta
	if timer >= KILL_TIMER:
		set_projectile_off()
		
func set_projectile_off():
	sphere_particles.hide()
	trail_particles.emitting = false
	projectile_is_active = false
	
func process_kill_projectile(delta):
	wait_timer += delta
	if wait_timer >= WAIT_KILL_TIMER:
		queue_free()
		
func collided(body):
	if projectile_is_active:
		if not body.is_in_group("team_" + str(Server.players[int(player_property_id)]["team"])):
			if exception.has(body) == false:
				if body.has_method("take_damage"):
					body.take_damage(DAMAGE, player_property_id)
				set_projectile_off()
	
