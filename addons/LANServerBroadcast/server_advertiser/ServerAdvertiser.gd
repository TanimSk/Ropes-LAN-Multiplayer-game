extends Node
class_name ServerAdvertiser, 'res://addons/LANServerBroadcast/server_advertiser/server_advertiser.png'

const DEFAULT_PORT := 3119

# How often to broadcast out to the network that this host is active
export (float) var broadcast_interval: float = 1.0
var serverInfo := {"name": "LAN Game"}

var socketUDP: PacketPeerUDP
var broadcastTimer := Timer.new()
var broadcastPort := DEFAULT_PORT

func _enter_tree():
	broadcastTimer.wait_time = broadcast_interval
	broadcastTimer.one_shot = false
	broadcastTimer.autostart = true
	
	if get_tree().is_network_server():
		add_child(broadcastTimer)
		broadcastTimer.connect("timeout", self, "broadcast") 
		
		socketUDP = PacketPeerUDP.new()
		socketUDP.set_broadcast_enabled(true)

func broadcast():
	#print('Broadcasting game...')
	for address in IP.get_local_addresses():
		var parts = address.split('.')
		if (parts.size() == 4):
			parts[3] = '255'
			socketUDP.set_dest_address(parts.join('.'), broadcastPort)
			var packetMessage := to_json(serverInfo)
			var packet := packetMessage.to_ascii()
			socketUDP.put_packet(packet)


func _exit_tree():
	broadcastTimer.stop()
	if socketUDP != null:
		socketUDP.close()
