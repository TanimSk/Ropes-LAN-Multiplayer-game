extends Sprite

func _process(_delta):
	global_position.x += .25
	if global_position.x > get_viewport().size.x + 250:
		global_position.x = -180

