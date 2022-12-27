extends Sprite

func _process(_delta):
	global_position.x -= .24
	if global_position.x < -200:
		global_position.x = get_viewport().size.x + 200

