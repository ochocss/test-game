extends Area2D

@onready var timer = $Timer
@onready var death_audio_stream_player = $DeathAudioStreamPlayer
@onready var player = %Player

var is_dying = false


func _on_body_entered(body):
	if body.name == "Player":
		death_anim()


func death_anim():
	death_audio_stream_player.play()
	Engine.time_scale = 0.35
	player.get_node("CollisionShape2D").queue_free()
	is_dying = true
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	is_dying = false


func save():
	var save_dict = {
		"filename" : get_path(),
		"parent" : get_parent().get_path(),
		"is_dying" : is_dying,
	}
	return save_dict


func load_data(data : Dictionary):
	is_dying = data.get("is_dying")
	if is_dying:
		death_anim()
