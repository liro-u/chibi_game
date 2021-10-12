tool
extends HBoxContainer

export(NodePath) var bar_node_path
var bar_node

export(NodePath) var label_node_path
var label_node

export var max_score = 75
export var base_value = 0

export(Vector2) var size_bar = Vector2(300, 14)
export(Color) var color
export(Font) var font

signal value_bar_is_full

func _ready():
	bar_node = get_node(bar_node_path)
	label_node = get_node(label_node_path)
	
	label_node.add_font_override("font", font)
	bar_node.max_value = max_score
	set_value(base_value)
	rect_min_size = size_bar
	bar_node.tint_progress = color
	
	hide()
	show()

func set_up(max_value, base_score = 0):
	max_score = max_value
	base_value = base_score
	bar_node.max_value = max_score
	set_value(base_value)
	
func set_value(value):
	bar_node.value = value
	update_value()

func add_to_value(value):
	bar_node.value += value
	update_value()
	
func update_value():
	label_node.text = str(bar_node.value) + "/" + str(max_score)
	if bar_node.value >= max_score:
		emit_signal("value_bar_is_full")
