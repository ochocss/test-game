extends Node2D

@onready var player = $Player


func _ready():
	var cam : Camera2D 
	cam = player.get_node("Camera2D")
	
	player.position.x = -104
	player.position.y = -65
	
	cam.set_limit(SIDE_LEFT, -750)
	cam.set_limit(SIDE_TOP, -400)
	cam.set_limit(SIDE_RIGHT, 0)
	cam.set_limit(SIDE_BOTTOM, 0)
