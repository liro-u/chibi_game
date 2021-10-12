tool
extends TextureRect

export(NodePath) var text_zone_path
var text_zone
export var base_text = "value_name : "
var margin_node
export var start_value = ""

export(Font) var font

func _ready():
	margin_node = get_child(0)
	text_zone = get_node(text_zone_path)
	if font != null:
		text_zone.add_font_override("font", font)
	set_text(start_value)

func set_text(text):
	if text_zone != null:
		if not text_zone.text == base_text + str(text):
			text_zone.text = base_text + str(text)
			resized()
			
func resized():
	text_zone.hide()
	text_zone.show()
	rect_min_size = text_zone.rect_size + Vector2(20, 10)
	rect_size = rect_min_size
	
