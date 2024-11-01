extends Node2D

var Peer = ENetMultiplayerPeer.new()
@export var example_game_scene : PackedScene

var CLIENT_IP = "192.168.1.1"
@export var PORT = 8080


func _on_host_pressed():
	Peer.create_server(PORT)
	multiplayer.multiplayer_peer = Peer
	multiplayer.peer_connected.connect(add_player)
	add_player()


func _on_join_pressed():
	# Grabs Client IP
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168"):
			CLIENT_IP = ip
	
	# Connects client to server in its IP
	Peer.create_client(CLIENT_IP, PORT)
	multiplayer.multiplayer_peer = Peer


func add_player(id = 1):
	var client = example_game_scene.instantiate()
	client.name = str(id)
	call_deferred("add_child",client)


func del_player(id):
	rpc("_del_player", id)

# Writing function this way helps all clients to delete a node
@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

