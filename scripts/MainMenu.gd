extends Control

onready var background:= get_tree().get_root().get_node("/root/Background")

onready var curtain1:= get_node("close1")
onready var curtain2:= get_node("close2")
onready var close_timer:= get_node("close_timer")

onready var global:= get_tree().get_root().get_node("/root/Global")

onready var admob:= $AdMob

func _ready():
	admob.load_banner()
	admob.show_banner()

	var file = File.new()
	
	if file.file_exists("user://user.dat"):
		file.open("user://user.dat", File.READ)
		global.saved_data = file.get_var()
		file.close()
		background.color = global.saved_data.bg_color
		$menu_buttons/options/hand.queue_free()
	else:
		file.open("user://user.dat", File.WRITE)
		global.saved_data = {
			'name': '',
			'sound_level': 70,
			'muted': false,
			'bg_color': Color(0.867,0.867,0.867,1)
		}
		file.store_var(global.saved_data)
		file.close()
		$AnimationPlayer.play("hand")
	
	if not global.saved_data.muted:
		background.set_volume(
			((35*global.saved_data.sound_level)/100) - 30
		)
	else:
		background.set_volume(-80)
	
#	if not get_tree().network_peer == null:
#		global.peer.close_connection()
#		get_tree().network_peer = null

func _on_start_button_up():
	var start_scene:= load("res://scenes/start_scene/lobby.tscn")
	get_tree().get_root().add_child(start_scene.instance())
	queue_free()

func _on_options_button_up():
	var options_scene:= load("res://scenes/options.tscn")
	get_tree().get_root().add_child(options_scene.instance())
	queue_free()

func _on_exit_button_up():
	admob.hide_banner()
	close_timer.start()

func _on_close_timer_timeout():
	curtain1.rect_position.y += 10
	curtain2.rect_position.y -= 10
	if curtain1.rect_position.y > -100:
		close_timer.stop()
		get_tree().quit()
	
