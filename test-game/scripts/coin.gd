extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

@export var is_collected = false


func _on_body_entered(_body):
	UI.add_point()
	is_collected = true
	animation_player.play("pickup")


func set_is_collected():
	is_collected = true
	animated_sprite_2d.hide()
	if !collision_shape_2d.disabled:
		collision_shape_2d.disabled = true


func set_uncollected():
	is_collected = false
	animation_player.play("RESET")


func save():
	var save_dict = {
		"filename" : name,
		"is_collected" : is_collected,
	}
	return save_dict


func load_data(data : Dictionary):
	is_collected = data.get("is_collected")
	if is_collected:
		set_is_collected()
	else:
		set_uncollected()
