extends Spatial

var audio_list = []

func _ready():
	randomize()
	
func play_sound():
	if audio_list != []:
		var audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
		audio_player.stream = audio_list[randi()%audio_list.size()]
		audio_player.connect("finished", audio_player, "queue_free")
		audio_player.play()
