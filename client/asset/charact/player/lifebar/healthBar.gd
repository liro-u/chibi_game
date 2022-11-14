tool
extends CenterContainer

export(NodePath) var health_bar_under_path
var health_bar_under

export(NodePath) var health_bar_over_path
var health_bar_over

export(NodePath) var value_tween_path
var value_tween

export(NodePath) var alpha_tween_path
var alpha_tween

export(Color) var color_friend
export(Color) var color_enemi

export(Vector2) var size_bar = Vector2(150, 14)

export(NodePath) var properti_node_path
var properti_node

func _ready():
	set_physics_process(false)
	if properti_node_path != "":
		set_property_node(get_node(properti_node_path))
	health_bar_over = get_node(health_bar_over_path)
	health_bar_under = get_node(health_bar_under_path)
	value_tween = get_node(value_tween_path)
	alpha_tween = get_node(alpha_tween_path)
	health_bar_over.rect_min_size = size_bar
	health_bar_under.rect_min_size = size_bar
	hide()
	show()
	
func set_property_node(node):
	set_physics_process(true)
	properti_node = node
	init_health(properti_node.health)
	properti_node.connect("update_health_bar", self, "update_health")
	properti_node.connect("init_health_bar", self, "init_health")
	init_color()
	
func init_color():
	if properti_node.is_in_group("team_" + str(Server.players[Server.local_player_id]["team"])):
		health_bar_over.tint_progress = color_friend
	else:
		health_bar_over.tint_progress = color_enemi
	
func init_health(health):
	health_bar_over.value = health
	health_bar_under.value = health
	
func update_health(health):
	health_bar_over.value = health
	value_tween.play(1, health_bar_under.value, health)
	alpha_tween.play(1, 1.0, 0.0)
	
func _on_valueTween_curve_tween(sat):
	health_bar_under.value = sat

func _on_alphaTween2_curve_tween(sat):
	health_bar_under.tint_progress.a = sat
