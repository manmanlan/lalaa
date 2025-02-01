extends CharacterBody2D

const ENEMEY_BULLET = preload("res://enemey_bullet.tscn")
var speed = 50
var target_direction
var shoot = false
var walk = false
var walking = false

func _physics_process(delta: float):
	# Access the global player position
	var player_position = Global.player_pos

	# Calculate the direction towards the player
	target_direction = (player_position - global_position).normalized()
	
	if not walking:
		# Move the enemy towards the player
		if global_position.distance_to(player_position) > 3:
			velocity = target_direction * speed
			move_and_slide()
	
	if not walk:
		walk = true
		$Timer.start()
		await $Timer.timeout
		walking = true
		if not shoot:
			shoot = true
			$Timer.start()
			await $Timer.timeout
			shoot_bullet()
			shoot_bullet()
			shoot = false
			walk = false
			walking = false

func shoot_bullet() -> void:
	# Create two bullets
	var bullet_temp1 = ENEMEY_BULLET.instantiate()
	var bullet_temp2 = ENEMEY_BULLET.instantiate()
	
	# Add the bullets to the scene
	get_parent().add_child(bullet_temp1)
	get_parent().add_child(bullet_temp2)
	
	# Set the positions of the bullets
	bullet_temp1.position = position
	bullet_temp2.position = position
	bullet_temp1.speed=200
	bullet_temp2.speed=200

	# Define the angle offset for the V shape (in radians)
	var angle_offset = 0.2 # Adjust this value to control the spread of the bullets

	# Calculate the new directions for the bullets
	var direction1 = target_direction.rotated(angle_offset)
	var direction2 = target_direction.rotated(-angle_offset)
	
	# Set the directions of the bullets
	if bullet_temp1.has_method("set_direction"):
		bullet_temp1.set_direction(direction1)
	elif bullet_temp1.has_variable("direction"):
		bullet_temp1.direction = direction1

	if bullet_temp2.has_method("set_direction"):
		bullet_temp2.set_direction(direction2)
	elif bullet_temp2.has_variable("direction"):
		bullet_temp2.direction = direction2
