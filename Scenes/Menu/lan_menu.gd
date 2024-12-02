extends Control

@onready var GamePort = 51001

var GamePeer = ENetMultiplayerPeer.new()

@onready var player_container: VBoxContainer = $Control/PlayerBrowser/VBoxContainer
var PlayerInfo = preload("res://Scenes/Menu/player_info.tscn")


func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


# Called for all peers, when a peer connects
func peer_connected(id):
	print("Player Connected "+ str(id))
	append_player_browser.rpc_id(id,Infoautoload.client_username,Infoautoload.CLIENT_IP,GamePeer.get_unique_id())


# Called for all peers, when a peer disconnects
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	remove_player_browser(id)


# Called Client side, when peer connects
func connected_to_server():
	print("Connected To Sever!")
	append_player_browser(Infoautoload.client_username,Infoautoload.CLIENT_IP,GamePeer.get_unique_id())


# Called Client side, when peer couldnt connect
func connection_failed():
	print("Couldnt Connect")


@rpc("any_peer","reliable")
func append_player_browser(username,ip,id):
	var new_player_info = PlayerInfo.instantiate()
	new_player_info.name = str(id)
	new_player_info.get_child(0).text = username
	new_player_info.get_child(1).text =  ip.split(".")[2] + "/" + ip.split(".")[3] + "/" + str(id)
	player_container.add_child(new_player_info)


func remove_player_browser(id):
	player_container.get_node(str(id)).queue_free()


func _on_create_pressed() -> void:
	var error_check = GamePeer.create_server(GamePort)
	if error_check != OK:
		print("Creating Server Error : " + str(error_check))
		return
	multiplayer.set_multiplayer_peer(GamePeer)
	print("Created Server at " + Infoautoload.CLIENT_IP)
	append_player_browser(Infoautoload.client_username,Infoautoload.CLIENT_IP,GamePeer.get_unique_id())


func _on_join_pressed() -> void:
	var error_check = GamePeer.create_client(Infoautoload.SERVER_IP, GamePort)
	if error_check != OK:
		print("Joining "+ Infoautoload.SERVER_IP +" Error : " + str(error_check))
		return
	multiplayer.set_multiplayer_peer(GamePeer)


func _on_start_pressed() -> void:
	pass # Replace with function body.
