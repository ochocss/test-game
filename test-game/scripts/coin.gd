extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var ui = %UI

func _on_body_entered(_body):
	ui.add_point()
	animation_player.play("pickup")
