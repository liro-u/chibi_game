extends CanvasLayer

export(NodePath) var world_illusatration_path
var world_illusatration

export(NodePath) var world_name_label_path
var world_name_label

export(NodePath) var title_mode_label_path
var title_mode_label

export(NodePath) var description_mode_label_path
var description_mode_label

func _ready():
	world_illusatration = get_node(world_illusatration_path)
	world_name_label = get_node(world_name_label_path)
	title_mode_label = get_node(title_mode_label_path)
	description_mode_label = get_node(description_mode_label_path)

func set_all(mode, world):
	match world:
		"dev_world":
			world_name_label.text = "Dev World"
			world_illusatration.texture = load("res://asset/world/TestingArea/texture_illustration.PNG")
		"fantasy_world":
			world_name_label.text = "Fantasy world"
			world_illusatration.texture = load("res://asset/world/fantasy_world/texture_illustration.PNG")
		_:
			world_name_label.text = ""
			
	match mode:
		"mme":
			title_mode_label.text = "Team Deathmatch"
			description_mode_label.bbcode_text = "Your goal is to [color=#ff0000]kill players[/color] of the other [color=#ff0000]team[/color] with coordination with your mates"
		"mg":
			title_mode_label.text = "Deathmatch"
			description_mode_label.bbcode_text = "Your goal is to be the [color=#ff0000]best player[/color] by killing other players"
		_:
			title_mode_label.text = "Hello mister ;)"
			description_mode_label.bbcode_text = "Enjoy playing this game and share it if you like it ^^"
		
			
	
