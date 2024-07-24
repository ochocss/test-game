extends Node2D

@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	var cam : Camera2D 
	cam = player.get_node("Camera2D")
	
	cam.set_limit(SIDE_LEFT, -750)
	cam.set_limit(SIDE_TOP, -400)
	cam.set_limit(SIDE_RIGHT, 0)
	cam.set_limit(SIDE_BOTTOM, 0)
