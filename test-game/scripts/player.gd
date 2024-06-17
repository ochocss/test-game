extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_animated_sprite = $AttackAnimatedSprite
@onready var knife_collision_shape = $Knife/KnifeCollisionShape

@onready var collision_shape = $CollisionShape2D

@onready var jump_sound_effect = $JumpSoundEffect
@onready var attack_sound_effect = $AttackSoundEffect

@onready var ui = $"../UI"

func _physics_process(delta):
	# Prio to attack anim
	if attack_animated_sprite.is_playing():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound_effect.play()
	
	# Get direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
		attack_animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		attack_animated_sprite.flip_h = true
	
	# Play animations
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction == 0:
		animated_sprite.play("idle")
	elif direction != 0:
		animated_sprite.play("run")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack"):
		if not animated_sprite.flip_h:
			knife_collision_shape.position.x = 10
		else:
			knife_collision_shape.position.x = -10
		
		animated_sprite.stop()
		animated_sprite.visible = false
		
		attack_animated_sprite.visible = true
		attack_animated_sprite.play("attack")
		
		knife_collision_shape.disabled = false
		velocity.x = 0
		velocity.y = 0
		direction = 0
		attack_sound_effect.play()

	move_and_slide()

func _on_knife_body_entered(body):
	if body.get_parent().name == "Enemies":
		body.direction = 0
		body.get_node("AnimationPlayer").play("die")
		body.get_node("AnimatedSprite2D").play("death")
		ui.add_items(body.get_groups()[0])

func _on_attack_animated_sprite_animation_finished():
	attack_animated_sprite.visible = false
	animated_sprite.visible = true
	
	knife_collision_shape.disabled = true
