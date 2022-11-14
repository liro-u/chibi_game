extends ColorRect

export(NodePath) var player_stat_list_path
var player_stat_list

func _ready():
	player_stat_list = get_node(player_stat_list_path)
