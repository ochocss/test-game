extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	UI.add_point()
	animation_player.play("pickup")
