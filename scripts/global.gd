extends Node

var saved_data
var is_host:bool
var player
var result

var peer = NetworkedMultiplayerENet.new()

var rematch_count:int = 1

func _exit_tree():
	if not get_tree().network_peer == null:
		peer.close_connection()
		get_tree().network_peer = null
