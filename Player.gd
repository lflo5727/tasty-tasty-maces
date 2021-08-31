extends Area2D

# Player has been hit by poison
signal hit

#Player ate a Mace
signal mace_eat

export var speed = 400
var screen_size

# Handle audio feedback, signals and removing objects collided with
func collide(signal_to_emit, audio, body):
	emit_signal(signal_to_emit)
	audio.play()
	body.queue_free()


# Spawn player at given position
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Handle player death
func die():
	hide()
	$DeathSound.play()
	$CollisionShape2D.set_deferred("disabled", true)


# Setup player
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.animation = "move"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.stop()
		
	#Rotate entire player depending on direction
	if velocity.x > 0 && velocity.y == 0:
		rotation_degrees = 90
	elif velocity.x > 0 && velocity.y < 0:
		rotation_degrees = 45
	elif velocity.x > 0 && velocity.y > 0:
		rotation_degrees = 135
	elif velocity.x == 0 && velocity.y > 0:
		rotation_degrees = 180
	elif velocity.x < 0 && velocity.y > 0:
		rotation_degrees = 225
	elif velocity.x < 0 && velocity.y == 0:
		rotation_degrees = 270
	elif velocity.x < 0 && velocity.y < 0:
		rotation_degrees = 315
	elif velocity.x == 0 && velocity.y < 0:
		rotation_degrees = 0
	
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_body_entered(body):
	if (body.is_in_group("poisons")):
		collide("hit", $RyderHit, body)
		
		# Flash the shader to indicate the player has been hit by poison
		var material = $AnimatedSprite.get_material()
		material.set("shader_param/flash_modifier", 0.4)
		yield(get_tree().create_timer(0.2), "timeout")
		material.set("shader_param/flash_modifier", 0.0)
		
	elif (body.is_in_group("maces")):
		collide("mace_eat", $MaceEat, body)
