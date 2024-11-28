extends Node2D

@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_player = player_scene.instantiate()
	new_player.name = "1"
	get_node("Players").add_child(new_player)
	
	for player in get_tree().get_nodes_in_group("Player"):
		player.position.x = randi_range(70,1080)
		player.position.y = randi_range(70,570)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
