extends MeshInstance

export(NodePath) var size_bar_tween_path
onready var size_bar_tween = get_node(size_bar_tween_path)

export var size = 16

func _ready():
	mesh = mesh.duplicate()
	
func start_resize():
	get_parent().show()
	size_bar_tween.play(1, 0, 1)

func _on_size_bar_tween_curve_tween(sat):
	mesh.size = Vector2(sat, sat) * size
