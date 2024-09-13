extends Area2D

@onready var timer = $Timer
@onready var spawn_timer = $SpawnTimer
@onready var death_audio_stream_player = $DeathAudioStreamPlayer

var is_dying = false


func _on_body_entered(body):
	if !is_instance_of(body, CharacterBody2D) || is_dying:
		return
	
	body.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	death_audio_stream_player.play()
	Engine.time_scale = 0.3
	
	is_dying = true
	set_block_signals(true)
	timer.start()


func _on_timer_timeout():
	if get_tree().current_scene.has_node("Coins"):
		var coins = get_tree().current_scene.get_node("Coins")
		for coin in coins.get_children():
			coin.is_collected = false
			coin.set_uncollected()
			
	var player = get_tree().current_scene.get_node("Player")
	
	player.get_node("CollisionShape2D").disabled = false
	
	if(get_tree().current_scene.name == "GreenArea"):
		player.position.x = -489
		player.position.y = -257
	else:
		player.position.x = -104
		player.position.y = -65
	
	player.velocity.x = 0
	player.velocity.y = 0
	
	UI.reset_score()
	
	is_dying = false
	Engine.time_scale = 1.0
	spawn_timer.start()


func _on_spawn_timer_timeout():
	set_block_signals(false)


func save():
	var save_dict = {
		"is_dying" : is_dying,
	}
	return save_dict


func load_data(data : Dictionary):
	var player = get_tree().current_scene.get_node("Player")
	is_dying = data.get("is_dying")
	
	if !is_dying:
		return
	
	_on_body_entered(player)
