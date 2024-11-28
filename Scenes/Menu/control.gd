extends Control

@onready var serverid: HScrollBar = $Serverid
@onready var local_ip: TextEdit = $LocalIP
@onready var server_ip: TextEdit = $ServerIP
@onready var player_name: TextEdit = $PlayerName

var CLIENT_IP = "192.168.1.1"
var JOIN_IP = "192.168.1.1"


func _ready() -> void:
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168"):
			CLIENT_IP = ip
	local_ip.text = "     Local ID : " + CLIENT_IP.split(".")[2] + "/" + CLIENT_IP.split(".")[3]
	serverid.value = int((CLIENT_IP.split("."))[3])
	Infoautoload.CLIENT_IP = CLIENT_IP


func _process(delta: float) -> void:
	var new_JOIN_IP = "192.168." + CLIENT_IP.split(".")[2] + "." + str(serverid.value)
	if JOIN_IP != new_JOIN_IP:
		JOIN_IP = new_JOIN_IP
		Infoautoload.SERVER_IP = JOIN_IP
		server_ip.text = "       Join ID : " + JOIN_IP.split(".")[2] + "/" + JOIN_IP.split(".")[3]
	if player_name.text != "" and Infoautoload.client_username != (player_name.text).left(20):
		Infoautoload.client_username = (player_name.text).left(20)
	
	
