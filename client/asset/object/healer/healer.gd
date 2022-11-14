extends Area

export(NodePath) var mesh_path
onready var mesh = get_node(mesh_path)

export(NodePath) var higth_tween_path
onready var higth_tween = get_node(higth_tween_path)

export(NodePath) var texture_floor_path
onready var texture_floor = get_node(texture_floor_path)

export var init_transform = 1.1
export var max_translation = 1.5

export var TIME_BEFORE_RESPAWN = 30
var timer_respawn = TIME_BEFORE_RESPAWN

export var FADE_OUT_TIME = 1
export var FADE_IN_TIME = 1

export var HEALTH_BONUS = 40

var is_active = true

func _ready():
	higth_tween.play(2, init_transform, init_transform + max_translation)
	
func _physics_process(delta):
	if not is_active:
		if timer_respawn < 0:
			timer_respawn = TIME_BEFORE_RESPAWN
			rpc_id(1, "respawn")
		else:
			timer_respawn -= delta
			
func _on_higth_tween_curve_tween(sat):
	mesh.translation.y = sat

func pick_up_health(body):
	if is_active:
		if body.is_in_group("player"):
			rpc_id(1, "destroy", body.name, HEALTH_BONUS)
			
sync func destroy():
	mesh.emitting = false
	is_active = false
	for child in texture_floor.get_children():
		child.start_tween(FADE_OUT_TIME, 1, 0)
	
sync func respawn():
	mesh.emitting = true
	is_active = true
	for child in texture_floor.get_children():
		child.start_tween(FADE_IN_TIME, 0, 1)

