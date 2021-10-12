extends Control

export(NodePath) var player_name_path
var player_name
export(NodePath) var selected_IP_path
var selected_IP
export(NodePath) var selected_port_path
var selected_port

var waiting_room_path = preload("res://asset/UI/lobby/waiting_room.tscn")
var waiting_room

export(NodePath) var charact_button_path
var charact_button

func _ready():
	player_name = get_node(player_name_path)
	selected_IP = get_node(selected_IP_path)
	selected_port = get_node(selected_port_path)
	charact_button = get_node(charact_button_path)
	
	charact_button.selected = Save.save_data["Last_charact"]
	player_name.text = Save.save_data["Player_name"]
	selected_IP.text = Server.DEFAULT_IP
	selected_port.text = str(Server.DEFAULT_PORT)
	
func _on_JoinBtn_pressed():
	Server.selected_IP = selected_IP.text
	Server.selected_port = int(selected_port.text)
	Server._connect_to_server()
	show_waiting_room()

func _on_NameTextBox_text_changed(new_text):
	Save.save_data["Player_name"] = new_text
	Save.save_game()

func show_waiting_room():
	waiting_room = get_tree().get_root().add_child(waiting_room_path.instance())
	queue_free()

func _on_charact_button_item_selected(index):
	Save.save_data["Last_charact"] = index
	Save.save_game()
