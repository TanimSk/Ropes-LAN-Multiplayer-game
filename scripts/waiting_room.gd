extends "res://scripts/disconnected_stat.gd"

onready var hosting_anime:= get_node("host/hosting_container/hosting")
onready var searching_anime:= get_node("client/search_container/searching")
onready var host_page:= get_node("host")
onready var host_label:= get_node("host/stat")
onready var play_btn:= get_node("host/play")
onready var client_page:= get_node("client")
onready var client_label:= get_node("client/stat")
onready var curtain:= get_node("close")
onready var close_timer:= get_node("close_timer")

const PORT :int = 3335

var advertiser
var listener

var player
var peer

func _ready():
	peer = global.peer
	
	if global.is_host:
		host_page.show()
		client_page.hide()
		hosting_anime.play("hosting")

		var result = peer.create_server(PORT, 1)
		if result == OK:
			get_tree().set_network_peer(peer)
			print("Game hosted")
		else:
			print("Failed to host game")
			
		advertiser = ServerAdvertiser.new()
		add_child(advertiser)
		
		advertiser.serverInfo["name"] = global.saved_data.name
		advertiser.serverInfo["port"] = PORT

		#connect returns an error msg
		print(get_tree().connect("network_peer_connected", self, "_player_connected"))
		
	else:
		host_page.hide()
		client_page.show()
		searching_anime.play("searching")
		
		listener = ServerListener.new()
		add_child(listener)
		listener.connect("new_server", self, "_found_server")


func _on_back_button_up():
	var lobby:= load("res://scenes/start_scene/lobby.tscn")
	get_tree().get_root().add_child(lobby.instance())
	queue_free()


func _player_connected(_id): # server
	$AdMob.hide_banner()
	host_label.text = "player joined !"
	play_btn.show()
	hosting_anime.play("done")
	print("found client")
	advertiser.queue_free()


func _connected_ok(): # client
	$AdMob.hide_banner()
	searching_anime.play("done")
	client_label.text = "connected with " + player
	print("connected with " + player)


var found_server_stat:bool = false

func _found_server(serverInfo):
	if not found_server_stat:
		print(init_client(serverInfo.ip))
		print(get_tree().connect("connected_to_server", self, "_connected_ok"))
		player = serverInfo.name
		found_server_stat = true


func init_client(ip):
	if peer.create_client(ip, PORT) != OK:
		return false
	else:
		get_tree().network_peer = peer
		return true


func _on_play_button_up():
	rpc("change_scene")

sync func change_scene():
	close_timer.start()

func _on_close_timer_timeout():
	curtain.rect_position.y += 15
	if curtain.rect_position.y > -10:
		close_timer.stop()
		var mainScene:= load("res://scenes/start_scene/mainGame.tscn")
		get_tree().get_root().add_child(mainScene.instance())
		queue_free()

