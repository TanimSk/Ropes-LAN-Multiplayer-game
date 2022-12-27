extends Sprite

func _process(_delta):
	global_position.x -= .28
	if global_position.x < -180:
		global_position.x = get_viewport().size.x + 300

