extends Node2D

@onready var player = $Player


func _ready():
	SaveFileHandler.load_game()
