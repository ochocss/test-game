extends Area2D

@onready var timer = $Timer
@onready var death_audio_stream_player = $DeathAudioStreamPlayer

var is_dying = false


func _on_body_entered(body):
	if body.name != "Player":
		return
	
	death_audio_stream_player.play()
	Engine.time_scale = 0.35
	body.get_node("CollisionShape2D").queue_free()
	is_dying = true
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
	UI.reset_score()
	Engine.time_scale = 1.0
	is_dying = false


func save():
	var save_dict = {
		"is_dying" : is_dying,
	}
	return save_dict


func load_data(data : Dictionary):
	var player = $"../Player"
	is_dying = data.get("is_dying")
	
	if !is_dying:
		return
	
	Engine.time_scale = 0.35
	player.get_node("CollisionShape2D").queue_free()
	is_dying = true
	timer.start()
