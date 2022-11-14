extends TouchScreenButton

var radius = Vector2(36, 36)
var boundary = 100

var ongoing_drag = -1

var threshold = 10

var min_value_uni_dir = sin(PI/8)

var correctly_stop = true

func _ready():
	position = - radius
	
func get_button_pos():
	return position + radius
	
func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - get_parent().global_position).length()
		
		if event_dist_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
		
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radius)
			
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		position = - radius
		correctly_stop = false
		
func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0, 0)
	
func _process(delta):
	if ongoing_drag != -1 or !correctly_stop:
		var dir = get_value()
		if dir.x > min_value_uni_dir:
			Input.action_press("movement_right")
		else:
			Input.action_release("movement_right")
		if dir.x < -min_value_uni_dir:
			Input.action_press("movement_left")
		else:
			Input.action_release("movement_left")
			
		if dir.y > min_value_uni_dir:
			Input.action_press("movement_backward")
		else:
			Input.action_release("movement_backward")
		if dir.y < -min_value_uni_dir:
			Input.action_press("movement_forward")
		else:
			Input.action_release("movement_forward")
		if ongoing_drag == -1:
			correctly_stop = true
