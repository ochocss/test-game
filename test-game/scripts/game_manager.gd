extends Node

@onready var ui = $"../UI"
@onready var player = %Player

var score = 0


func add_point():
	score += 1
	ui.get_node("ScoreLabel").text = str(score)
