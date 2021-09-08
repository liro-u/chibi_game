extends Control

export(NodePath) var player_name_path
var player_name
export(NodePath) var selected_IP_path
var selected_IP
export(NodePath) var selected_port_path
var selected_port
export(NodePath) var waiting_room_path
var waiting_room

func _ready():
	player_name = get_node(player_name_path)
	selected_IP = get_node(selected_IP_path)
	selected_port = get_node(selected_port_path)
	waiting_room = get_node(waiting_room_path)
	
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
	waiting_room.show()
