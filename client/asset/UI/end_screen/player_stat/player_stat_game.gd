extends HBoxContainer

export(NodePath) var name_label_path
var name_label

export(NodePath) var kill_label_path
var kill_label

export(NodePath) var death_label_path
var death_label

export(NodePath) var ratio_label_path
var ratio_label

var player 

func _ready():
	name_label = get_node(name_label_path)
	kill_label = get_node(kill_label_path)
	death_label = get_node(death_label_path)
	ratio_label = get_node(ratio_label_path)
	
	name_label.text = Server.players[player]["Player_name"]
	var kill = Server.players[player]["kill"]
	var death = Server.players[player]["death"]
	kill_label.text = str(kill) + " kill"
	death_label.text = str(death) + " death"
	var ratio
	if death == 0:
		if kill == 0:
			ratio = 1
		else:
			ratio = kill
	else:
		ratio = kill / death
	ratio_label.text = "ratio : " + str(stepify(ratio, 0.01))
