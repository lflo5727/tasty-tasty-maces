extends Node


export (PackedScene) var Mace
export (PackedScene) var Poison
var score
var lives


#Setup new game
func new_game():
	score = 0
	lives = 3
	
	$HUD.update_score(score)
	$HUD.update_lives(lives)
	$HUD.show_message("Get Ready")
	
	$Player.start($StartPosition.position)
	$StartTimer.start()


# Handle player death
func game_over():
	$Player.die()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	get_tree().call_group("maces", "queue_free")
	get_tree().call_group("poisons", "queue_free")


# Setup randomizer 
func _ready():
	randomize()


# Handle player hits and lives
func _on_Player_hit():
	if lives > 0:
		lives -= 1
	else:
		game_over()
		
	$HUD.update_lives(lives)


# Handle score increase
func _on_Player_mace_eat():
	score += 1
	$HUD.update_score(score)


# Kick off mob spawn timer on start-timer timeout
func _on_StartTimer_timeout():
	$MobTimer.start()

# Spawn Maces and Poison
func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	# Get a weighted chance of spawning a Mace vs a poison
	var spawn_mace = rand_range(0, 10) > 3
	var mob
	if (spawn_mace):
		mob = Mace.instance()
	else:
		mob = Poison.instance()
	
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	# Only send Maces in a random direction, poison goes straight down
	if (spawn_mace):
		direction += rand_range(-PI / 4, PI / 4)
		
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
