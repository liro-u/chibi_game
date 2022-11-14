extends MarginContainer

export(NodePath) var health_bar_node_path 
var health_bar_node

export(NodePath) var kill_text_node_path
var kill_text_node

export(NodePath) var death_text_node_path
var death_text_node

export(NodePath) var time_count_node_path
var time_count_node

export(NodePath) var score_node_path
var score_node

export(NodePath) var enemy_score_node_path
var enemy_score_node

var player_node

func _ready():
	score_node = get_node(score_node_path)
	enemy_score_node = get_node(enemy_score_node_path)
	health_bar_node = get_node(health_bar_node_path)
	death_text_node = get_node(death_text_node_path)
	kill_text_node = get_node(kill_text_node_path)
	time_count_node = get_node(time_count_node_path)

func connect_end(function_name):
	enemy_score_node.connect("value_bar_is_full", Server, function_name)
	score_node.connect("value_bar_is_full", Server, function_name)
	
func set_up(max_value, base_value):
	score_node.set_up(max_value, base_value)
	enemy_score_node.set_up(max_value, base_value)
	
func set_player(player):
	player_node = player
	health_bar_node.set_property_node(player)
	player.game_ui = self

func update_value(variable, value):
	match variable:
		"kill":
			kill_text_node.set_text(value)
		"death":
			death_text_node.set_text(value)
		"time":
			time_count_node.set_text(value)
		"team_score":
			score_node.add_to_value(value)
		"enemy_score":
			enemy_score_node.add_to_value(value)
		
