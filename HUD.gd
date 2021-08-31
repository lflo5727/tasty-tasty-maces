extends CanvasLayer

signal start_game


# Display message and kick off message timer
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	

# Handle game over UI
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "Tasty Tasty Mace!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


# Update score counter
func update_score(score):
	$ScoreLabel.text = str(score)


# Update life counter
func update_lives(lives):
	$Lives.text = str(lives)
	

# Setup HUD
func _ready():
	$Ryder.texture = load("res://Assets/art/ryderlife.png")

# Hide message after timer expires
func _on_MessageTimer_timeout():
	$MessageLabel.hide()


# Start game
func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
