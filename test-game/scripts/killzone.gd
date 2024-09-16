extends Area2D

@onready var timer = $Timer
@onready var death_audio_stream_player = $DeathAudioStreamPlayer

var is_dying = false


func _process(_delta: float):
	if is_dying:
		UI.color_rect.color.a += 0.009


func _on_body_entered(body):
	if !is_instance_of(body, CharacterBody2D) || is_dying:
		return
	
	if is_instance_of(get_parent(), CharacterBody2D):
		body.get_node("AnimatedSprite2D").play("death")
	
	collision_layer = 3
	
	Engine.time_scale = 0.65
	
	death_audio_stream_player.play()
	Music.stop()
	
	body.is_dying = true
	is_dying = true
	
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
	
	collision_layer = 1
	
	UI.reset_score()
	
	is_dying = false
	player.is_dying = false
	UI.color_rect.color.a = 0
	
	Music.play()
	Engine.time_scale = 1.0


func save():
	var save_dict = {
		"is_dying" : is_dying,
	}
	return save_dict


func load_data(data : Dictionary):
	var player = get_tree().current_scene.get_node("Player")
	is_dying = data.get("is_dying")
	
	if is_dying:
		_on_body_entered(player)
