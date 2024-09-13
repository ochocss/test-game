extends Area2D

@onready var timer = $Timer
@onready var death_audio_stream_player = $DeathAudioStreamPlayer
@onready var collision_shape_2d = $CollisionShape2D

var is_dying = false


func _on_body_entered(body):
	if !is_instance_of(body, CharacterBody2D) || !has_node("CollisionShape2D"):
		return
	
	body.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	if name == "KillzoneBound":
		collision_shape_2d.queue_free()
	
	death_audio_stream_player.play()
	Engine.time_scale = 0.3
	
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
	
	if name == "KillzoneBound":
		create_world_boundary()
	
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


func create_world_boundary():
	var new_collision_shape = CollisionShape2D.new()
	new_collision_shape.shape = WorldBoundaryShape2D.new()
	
	add_child(new_collision_shape)


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
