tool
extends Node
class_name spawn_nb_item

export var name_text = "explosive_baril"
export(PackedScene) var item
export(int) var nb_item = 0

export var need_to_delete = false
export var need_to_create = false
	
func _process(delta):
	if need_to_delete == true:
		delete_all_child()
	elif need_to_create == true:
		create_new_item()
		
func delete_all_child():
	var children = get_children()
	if children.size() > 0:
		for child in children:
			child.queue_free()
		need_to_delete = false
	
func create_new_item():
	var new_item
	for i in range(0, nb_item):
		new_item = item.instance()
		if i != 0:
			name_text += str(i + 1)
		new_item.name = name_text
		add_child(new_item)
		new_item.set_owner(get_tree().get_edited_scene_root())
	need_to_create = false
