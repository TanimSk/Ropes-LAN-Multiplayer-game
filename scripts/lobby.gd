extends Control

onready var global:= get_tree().get_root().get_node("/root/Global")

onready var network = global.peer

func _ready():
	if not get_tree().network_peer == null:
		network.close_connection()
		get_tree().network_peer = null

func _on_host_button_up():
	global.is_host = true
	waiting_room()

func _on_join_button_up():
	global.is_host = false
	waiting_room()

func _on_back_button_up():
	var mainMenu_scene:= load("res://scenes/MainMenu.tscn")
	get_tree().get_root().add_child(mainMenu_scene.instance())
	queue_free()

func waiting_room():
	var waiting_room:= load("res://scenes/start_scene/waiting_room.tscn")
	get_tree().get_root().add_child(waiting_room.instance())
	queue_free()
