extends Node2D

@export var PLAYER_SPEED = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Movement
	if Input.is_action_pressed("Up"):
		position.y -= PLAYER_SPEED*delta
	if Input.is_action_pressed("Down"):
		position.y += PLAYER_SPEED*delta
	if Input.is_action_pressed("Left"):
		position.x -= PLAYER_SPEED*delta
	if Input.is_action_pressed("Right"):
		position.x += PLAYER_SPEED*delta
