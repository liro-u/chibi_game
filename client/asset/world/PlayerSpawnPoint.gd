extends Node

var position_list = []
var position_in_position_list = 0

func _ready():
	for child in get_children():
		position_list.append(child.global_transform)

func get_next_position():
	position_in_position_list = (position_in_position_list+1)%position_list.size()
	return position_list[position_in_position_list]
