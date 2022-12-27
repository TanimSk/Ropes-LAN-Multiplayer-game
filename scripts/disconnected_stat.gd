extends Control

onready var global:= get_tree().get_root().get_node("/root/Global")
onready var background:= get_tree().get_root().get_node("/root/Background")
#onready var audio:= get_tree().get_root().get_node("/root/Background/Audio")

func _ready():
	print(get_tree().connect("server_disconnected", self, "_server_disconnected"))
	print(get_tree().connect("network_peer_disconnected", self, "_player_disconnected"))

func _server_disconnected():
	switch_scene()

func _player_disconnected(_id):
	switch_scene()

func switch_scene():
#	if not get_tree().network_peer == null:
#		global.peer.close_connection()
#		get_tree().network_peer = null
	background.audio_loop = false
	background.play_audio("res://assets/audio/draw.wav")
	
	var disconnectScene:= preload("res://scenes/disconnected.tscn")
	get_tree().get_root().add_child(disconnectScene.instance())
	queue_free()
