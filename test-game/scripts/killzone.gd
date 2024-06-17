extends Area2D

@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer2D

func _on_body_entered(body):
	audio_stream_player.play()
	Engine.time_scale = 0.35
	body.get_node("CollisionShape2D").queue_free()
	set_process_input(false)
	timer.start()
	

func _on_timer_timeout():
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	set_process_input(true)
