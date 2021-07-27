extends Node

const SERVER_PORT:int = 3120
const MAX_PLAYERS:int = 2


func init_host() -> void:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	
func init_client(ip):
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client(ip, SERVER_PORT) != OK:
		return false
	else:
		get_tree().network_peer = peer
		return true
	
