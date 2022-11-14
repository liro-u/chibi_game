extends Area
		
export(NodePath) var zone_detection_path
onready var zone_detection = get_node(zone_detection_path)

export(NodePath) var raycast_path
onready var raycast = get_node(raycast_path)

export(NodePath) var aim_marker_path
onready var aim_marker = get_node(aim_marker_path)

export(NodePath) var timer_path
onready var timer = get_node(timer_path)

export(NodePath) var debug_path
onready var debug = get_node(debug_path)

export(bool) var is_active = true
export(int) var radius = 22
export(float) var max_angle = 22

var target_list = []
var organised_target_list = []
var current_target = null

func _ready():
	zone_detection.shape.radius = radius
	var r = debug.get_node("RayCast")
	var r2 = debug.get_node("RayCast2")
	r.rotation_degrees.y = max_angle
	r2.rotation_degrees.y = - max_angle
	r.cast_to.z = radius
	r2.cast_to.z = radius
	
func new_body_entered(body):
	if body.has_method("take_damage"):
		if not body.is_in_group("team_" + str(Server.players[int(get_parent().name)]["team"])):
			target_list.append(body)
			
func body_exited(body):
	target_list.erase(body)
	if body == current_target:
		current_target = null
		update()
		timer.start()
	
func _physics_process(delta):
	debug.global_transform = get_parent().mesh_Node.global_transform
	debug.global_transform.origin.y = global_transform.origin.y
	if current_target != null:
		aim_marker.global_transform.origin = current_target.global_transform.origin
		
func update():
	current_target = null
	if is_active:
		sort()
		choose_target()
	if current_target == null:
		aim_marker.hide()
	else:
		aim_marker.show()
	

func sort():
	organised_target_list = []
	if target_list.size() != 0:
		var temp = target_list.duplicate()
		var best_target
		var best_target_distance
		while temp.size() != 0:
			best_target = temp[0]
			best_target_distance = global_transform.origin.distance_to(best_target.global_transform.origin)
			for target in temp:
				if target.global_transform.origin.distance_to(global_transform.origin) < best_target_distance:
					best_target = target
					best_target_distance = global_transform.origin.distance_to(best_target.global_transform.origin)
			organised_target_list.append(best_target)
			temp.erase(best_target)

func choose_target():
	if organised_target_list.size() != 0:
		var i = 0
		var potential_target
		while current_target == null and organised_target_list.size() > i:
			potential_target = organised_target_list[i]
			i += 1
			
			raycast.look_at(potential_target.get_node("target_point").global_transform.origin, Vector3(0, 1, 0))
			raycast.force_raycast_update()
			if raycast.get_collider() == potential_target:
				var vector3d_view = -raycast.global_transform.basis.z
				var vector3d_target = get_parent().mesh_Node.global_transform.basis.z
				var vector2d_view = Vector2(vector3d_view.x, vector3d_view.z)
				var vector2d_target = Vector2(vector3d_target.x, vector3d_target.z)
				
				var angle_between_aim = abs(rad2deg(vector2d_target.angle_to(vector2d_view)))

				if angle_between_aim <= max_angle:
					current_target = potential_target
					aim_marker.global_transform.origin = current_target.global_transform.origin
