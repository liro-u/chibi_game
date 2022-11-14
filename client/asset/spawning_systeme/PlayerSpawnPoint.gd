extends Node

var position_list = []
var position_in_position_list = 0

func _ready():
	if get_child_count() == 0:
		var default_spawn_point = Position3D.new()
		add_child(default_spawn_point)
		print("Warning : no spawnpoint set_up to " + name)
	for child in get_children():
		position_list.append(child.global_transform)

func get_next_position():
	position_in_position_list = (position_in_position_list+1)%position_list.size()
	return position_list[position_in_position_list]
