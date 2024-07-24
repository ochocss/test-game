extends Area2D

var player_node = preload("res://scenes/player.tscn")

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
	get_tree().current_scene.get_node("Player").queue_free()
	
	get_tree().current_scene.add_child(player_node.instantiate())
	UI.reset_score()
	
	if get_tree().current_scene.has_node("Coins"):
		var coins = get_tree().current_scene.get_node("Coins")
		for coin in coins.get_children():
			coin.is_collected = false
			coin.set_uncollected()
	
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
