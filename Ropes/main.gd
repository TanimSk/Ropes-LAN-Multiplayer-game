extends Control

onready var global = get_tree().get_root().get_node("/root/PlayerWinner")
onready var username = get_node("first_time/name")
onready var game_scence = preload("res://Control.tscn").instance()

func _ready():
	var file = File.new()
	if file.file_exists("user://user.dat"):
		file.open("user://user.dat", File.READ)
		var content = file.get_as_text()
		file.close()
		global.player_name = content
		queue_free()
		get_tree().get_root().call_deferred("add_child", game_scence)

func _on_done_btn_pressed():
	var f = File.new()
	f.open("user://user.dat", File.WRITE)
	f.store_string(username.text)
	f.close()
	global.player_name = username.text
	load_control_page()


func load_control_page():
	get_tree().get_root().add_child(game_scence)
	queue_free()
