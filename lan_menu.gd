extends Node2D

@onready var serverip: TextEdit = $serverip
@onready var pingip: TextEdit = $pingip
@onready var clientip: TextEdit = $clientip
@onready var datatext: TextEdit = $Data


@export var example_player_scene : PackedScene

var GamePeer = ENetMultiplayerPeer.new()
var PingPeer = PacketPeerUDP.new()
var ListenPeer = PacketPeerUDP.new()

var CLIENT_IP = "192.168.1.1"
var PING_IP = "192.168.1.255"
var SERVER_IP = "192.168.1.1"


@export var GAME_PORT = 51001
@export var SERVER_PING_PORT = 51010
@export var SERVER_LISTEN_PORT = 51011

@onready var server_ping_timer = $MainMenu/ServerPingTimer
@onready var client_listen_timer = $MainMenu/ClientListenTimer


func _process(_delta):
	if ListenPeer.is_bound():
		if ListenPeer.get_available_packet_count() > 0:
			var data = ListenPeer.get_packet().get_string_from_ascii()
			datatext.text = str(data)
			SERVER_IP = ListenPeer.get_packet_ip()
	serverip.text = "SERVER IP: "+str(SERVER_IP)
	pingip.text = "PING IP: "+str(PING_IP)
	clientip.text = "CLIENT IP: "+str(CLIENT_IP)


func _ready():
	multiplayer.peer_disconnected.connect(del_player)
	del_player(multiplayer.get_remote_sender_id())
	# Makes client listen time more than ping time
	client_listen_timer.wait_time = server_ping_timer.wait_time + 0.1
	# Grabs Client IP and generates Ping IP
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168"):
			CLIENT_IP = ip
			var ipbreak = CLIENT_IP.split('.')
			PING_IP = ipbreak[0] + "." + ipbreak[1] + "." + ipbreak[2] + ".255"


func listen_set_up():
	var ok = ListenPeer.bind(SERVER_LISTEN_PORT)
	client_listen_timer.start()


func ping_set_up():
	PingPeer.set_broadcast_enabled(true)
	PingPeer.set_dest_address(PING_IP, SERVER_LISTEN_PORT)
	var ok = PingPeer.bind(SERVER_PING_PORT)
	server_ping_timer.start()


func listen_shut_down():
	if ListenPeer.is_bound():
		ListenPeer.close()


func _on_join_pressed():
	listen_set_up()


func add_player(id = 1):
	var client = example_player_scene.instantiate()
	client.name = str(id)
	get_node("ExampleGameScene").add_child(client)


func del_player(id):
	if id != 1:
		rpc("_del_player", id)
	else:
		rpc("_del_server")


# Writing function this way helps all clients to delete a node
@rpc("any_peer", "call_local") func _del_player(id):
	if get_node("ExampleGameScene").get_node(str(id)) != null:
		get_node("ExampleGameScene").get_node(str(id)).queue_free()


@rpc("any_peer", "call_local") func _del_server():
	SERVER_IP = "192.168.1.1" # Resets Server


func _on_server_ping_timer_timeout():
	var packet = "data".to_ascii_buffer() # Put data here
	PingPeer.put_packet(packet)


func _on_client_listen_timer_timeout():
	if SERVER_IP == "192.168.1.1":
		GamePeer.create_server(GAME_PORT)
		multiplayer.multiplayer_peer = GamePeer
	else:
		GamePeer.create_client(SERVER_IP, GAME_PORT)
		multiplayer.multiplayer_peer = GamePeer
	
	if multiplayer.is_server() and server_ping_timer.is_stopped():
		ping_set_up()
	
	listen_shut_down()
	multiplayer.peer_connected.connect(add_player)
	add_player()
