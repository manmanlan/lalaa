extends CharacterBody2D

var speed = 50
var target_direction

func _physics_process(delta: float):
	# Access the global player position
	var player_position = Global.player_pos
	
	# Calculate the direction towards the player
	target_direction = (player_position - global_position).normalized()
	
	# Move the enemy towards the player
	if global_position.distance_to(player_position) > 3:
		velocity = target_direction * speed
		move_and_slide()
