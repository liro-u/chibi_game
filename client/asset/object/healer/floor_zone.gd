extends MeshInstance

export(NodePath) var alpha_tween_path
onready var alpha_tween = get_node(alpha_tween_path)

export var SPEED = 180

func _ready():
	material_override = material_override.duplicate()
	
func _physics_process(delta):
	rotation_degrees.y += SPEED * delta

func start_tween(t, a, b):
	alpha_tween.play(t, a, b)

func set_alpha_mat(sat):
	material_override.albedo_color.a = sat
