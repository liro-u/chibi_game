extends Spatial

var SPEED = 30
var DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

var exception = []

var Area_node

func _ready():
	Area_node = $"Area"
	
func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir *SPEED * delta)
	
	timer += delta
	if timer >= KILL_TIMER:
		queue_free()
		
func collided(body):
	if exception.has(body) == false:
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
				
		queue_free()
