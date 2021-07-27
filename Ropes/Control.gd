extends Control

onready var network = get_tree().get_root().get_node("/root/Network")

onready var ip_address = get_node("host_page/ip_address")
onready var ip_input = get_node("join_page/TextEdit")

onready var main_page = get_node("main_page")
onready var host_page = get_node("host_page")


onready var join_page = get_node("join_page")
onready var start_btn = get_node("join_page/start")
onready var ip_label = get_node("host_page/ip_label")
onready var retry_btn = get_node("host_page/retry")

onready var audio = get_node("audio")

var ip_found:bool = false

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")


func _on_host_btn_pressed():
	main_page.hide()
	host_page.show()
	network.init_host()
	for ip in IP.get_local_addresses():
		if '192.168' in ip or '192.168.43' in ip:
			ip_address.text = ip.replace('192.168.', '')
			ip_found = true
	
	if !ip_found:
		ip_label.hide()
		ip_address.text = "please set up your wifi"
		retry_btn.show()
	
	ip_address.show()


func _on_join_btn_pressed():
	main_page.hide()
	join_page.show()


func _player_connected(_id):
	var game_scence = preload("res://assets/game/game.tscn").instance()
	get_tree().get_root().add_child(game_scence)
	queue_free()
	


func _on_start_pressed():
	if !network.init_client('192.168.'+ip_input.text):
		ip_input.text = "Invalid ID"


func _on_retry_pressed():
	for i in IP.get_local_addresses():
		if '192.168.' in i or '192.168.43' in i:
			ip_address.text = i.replace('192.168.', '')
			ip_found = true
			retry_btn.hide()
			ip_label.show()
			break
	
	if !ip_found:
		ip_label.hide()
		ip_address.text = "please set up your wifi"
		retry_btn.show()


func _on_audio_finished():
	audio.play()

	
