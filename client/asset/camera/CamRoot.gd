extends Spatial

export (NodePath) var followPoint_nodePath
var followPoint_node

func _ready():
	if followPoint_nodePath == "":
		set_physics_process(false)
	else:
		followPoint_node = get_node(followPoint_nodePath)
		followPoint_node.get_parent().camera_node = self
		
func set_follow_point(node):
	if node != null:
		followPoint_node = node
		followPoint_nodePath = node.get_path()
		if "camera_node" in followPoint_node.get_parent():
			followPoint_node.get_parent().camera_node = self
		set_physics_process(true)
	
func _physics_process(delta):
	transform.origin = followPoint_node.get_global_transform().origin

