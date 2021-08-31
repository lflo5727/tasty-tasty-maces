extends RigidBody2D


export var min_speed = 150
export var max_speed = 250

# Called every frame. 'delta' is the elapsed time since the previous fsrame.
func _process(delta):
	var rot_speed = rad2deg(0.1)
	#You spin me right round, baby, right round
	$AnimatedSprite.rotation = ($AnimatedSprite.rotation + rot_speed * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
