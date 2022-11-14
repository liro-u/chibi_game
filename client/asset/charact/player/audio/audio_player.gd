extends Spatial

export(Array, String, FILE, "*.wav") var attack
export(Array, String, FILE, "*.wav") var revive
export(Array, String, FILE, "*.wav") var dodge
export(Array, String, FILE, "*.wav") var die


export(NodePath) var attack_node_path
var attack_node

export(NodePath) var revive_node_path
var revive_node

export(NodePath) var dodge_node_path
var dodge_node

export(NodePath) var die_node_path
var die_node

func _ready():
	attack_node = get_node(attack_node_path)
	revive_node = get_node(revive_node_path)
	dodge_node = get_node(dodge_node_path)
	die_node = get_node(die_node_path)
	
	load_list(attack_node, attack)
	load_list(revive_node, revive)
	load_list(dodge_node, dodge)
	load_list(die_node, die)

func load_list(node, list):
	for elm in list:
		node.audio_list.append(load(elm))
	
func play_sound(sound_name):
	match sound_name:
		"attack":
			attack_node.play_sound()
		"dodge":
			dodge_node.play_sound()
		"revive":
			revive_node.play_sound()
		"die":
			die_node.play_sound()
			

	
