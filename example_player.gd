extends Node2D

@export var PLAYER_SPEED = 150

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# If player is Client's player
	if is_multiplayer_authority():
		# Movement
		if Input.is_action_pressed("Up"):
			position.y -= PLAYER_SPEED * delta
		if Input.is_action_pressed("Down"):
			position.y += PLAYER_SPEED * delta
		if Input.is_action_pressed("Left"):
			position.x -= PLAYER_SPEED * delta
		if Input.is_action_pressed("Right"):
			position.x += PLAYER_SPEED * delta
		
